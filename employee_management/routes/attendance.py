from flask import Blueprint, render_template, request, redirect, url_for, flash
from config import get_db
from datetime import date, datetime
from flask_login import login_required

attendance_bp = Blueprint('attendance', __name__)

def is_weekend(d=None):
    """Trả về True nếu là thứ 7 (5) hoặc chủ nhật (6)."""
    if d is None:
        d = date.today()
    return d.weekday() >= 5


@attendance_bp.route('/')
@login_required
def list_attendance():
    db  = get_db()
    cur = db.cursor(dictionary=True)
    selected_date = request.args.get('date', date.today().isoformat())

    cur.execute("""
        SELECT e.first_name, e.last_name, d.dept_name,
               a.check_in_time, a.check_out_time, a.status, a.remarks
        FROM ATTENDANCE a
        JOIN EMPLOYEE   e ON a.employee_id = e.employee_id
        JOIN DEPARTMENT d ON e.dept_id     = d.dept_id
        WHERE a.attendance_date = %s
        ORDER BY d.dept_name, a.check_in_time
    """, (selected_date,))
    records = cur.fetchall()

    cur.execute("""
        SELECT employee_id, first_name, last_name
        FROM EMPLOYEE WHERE is_active = 1
        ORDER BY first_name
    """)
    employees = cur.fetchall()

    # Lấy danh sách employee_id đã check-in hôm nay
    cur.execute("""
        SELECT employee_id FROM ATTENDANCE
        WHERE attendance_date = CURDATE()
    """)
    checked_in_today = {row['employee_id'] for row in cur.fetchall()}

    cur.close(); db.close()

    today = date.today()
    weekend = is_weekend(today)

    return render_template('attendance/list.html',
                           records=records,
                           selected_date=selected_date,
                           employees=employees,
                           checked_in_today=checked_in_today,
                           is_weekend=weekend)


@attendance_bp.route('/checkin', methods=['POST'])
@login_required
def checkin():
    # Không cho check-in vào cuối tuần
    if is_weekend():
        flash('No attendance required on weekends.', 'warning')
        return redirect(url_for('attendance.list_attendance'))

    db  = get_db()
    cur = db.cursor(dictionary=True)
    emp_id  = request.form['employee_id']
    remarks = request.form.get('remarks', '')

    # Kiểm tra đã check-in hôm nay chưa
    cur.execute("""
        SELECT attendance_id FROM ATTENDANCE
        WHERE employee_id = %s AND attendance_date = CURDATE()
    """, (emp_id,))
    if cur.fetchone():
        flash('This employee has already checked in today.', 'warning')
        cur.close(); db.close()
        return redirect(url_for('attendance.list_attendance'))

    cur2 = db.cursor()
    cur2.execute("""
        INSERT INTO ATTENDANCE
          (employee_id, attendance_date, check_in_time, status, remarks)
        VALUES (%s, CURDATE(), CURTIME(),
                CASE WHEN CURTIME() > '08:30:00' THEN 'Late' ELSE 'Present' END,
                %s)
    """, (emp_id, remarks))
    db.commit()
    cur2.close(); cur.close(); db.close()
    flash('Check-in successful!', 'success')
    return redirect(url_for('attendance.list_attendance'))


@attendance_bp.route('/checkout', methods=['POST'])
@login_required
def checkout():
    db  = get_db()
    cur = db.cursor()
    emp_id  = request.form['employee_id']
    remarks = request.form.get('remarks', '')

    cur.execute("""
        UPDATE ATTENDANCE
        SET check_out_time = CURTIME(),
            remarks = CASE
                WHEN %s != '' THEN
                    CONCAT(COALESCE(remarks, ''),
                           IF(remarks IS NOT NULL AND remarks != '', ' | ', ''),
                           %s)
                ELSE remarks
            END
        WHERE employee_id = %s
          AND attendance_date = CURDATE()
          AND check_out_time IS NULL
    """, (remarks, remarks, emp_id))

    if cur.rowcount == 0:
        flash('No active check-in found for this employee today.', 'warning')
    else:
        db.commit()
        flash('Check-out successful!', 'success')

    cur.close(); db.close()
    return redirect(url_for('attendance.list_attendance'))


@attendance_bp.route('/mark-absent', methods=['POST'])
@login_required
def mark_absent():
    """
    Gọi thủ công hoặc từ scheduler: đánh Absent cho nhân viên
    chưa check-in hôm nay, chỉ chạy vào ngày thường sau 17:30.
    """
    today = date.today()
    if is_weekend(today):
        flash('No attendance required on weekends.', 'warning')
        return redirect(url_for('attendance.list_attendance'))

    now = datetime.now().time()
    if now < datetime.strptime('17:30', '%H:%M').time():
        flash('Can only mark absent after 17:30.', 'warning')
        return redirect(url_for('attendance.list_attendance'))

    db  = get_db()
    cur = db.cursor()

    # Insert Absent cho mọi nhân viên active chưa có record hôm nay
    cur.execute("""
        INSERT INTO ATTENDANCE (employee_id, attendance_date, status, remarks)
        SELECT e.employee_id, CURDATE(), 'Absent', 'Auto-marked absent after 17:30'
        FROM EMPLOYEE e
        WHERE e.is_active = 1
          AND e.employee_id NOT IN (
              SELECT employee_id FROM ATTENDANCE
              WHERE attendance_date = CURDATE()
          )
    """)
    count = cur.rowcount
    db.commit()
    cur.close(); db.close()

    flash(f'Marked {count} employee(s) as Absent.', 'info')
    return redirect(url_for('attendance.list_attendance'))