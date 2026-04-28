from flask import Blueprint, render_template, request, redirect, url_for, flash
from config import get_db
from datetime import date
from flask_login import login_required

attendance_bp = Blueprint('attendance', __name__)

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
    
    # Lấy danh sách nhân viên cho dropdown check-in
    cur.execute("""
        SELECT employee_id, first_name, last_name
        FROM EMPLOYEE WHERE is_active = 1
        ORDER BY first_name
    """)
    employees = cur.fetchall()
    
    cur.close(); db.close()
    return render_template('attendance/list.html',
                           records=records, selected_date=selected_date, employees=employees)

@attendance_bp.route('/checkin', methods=['POST'])
@login_required
def checkin():
    db  = get_db()
    cur = db.cursor()

    emp_id  = request.form['employee_id']
    remarks = request.form.get('remarks', '')
    status  = request.form.get('status', 'auto')

    # Nếu chọn Auto thì tự tính dựa vào giờ hiện tại
    if status == 'auto':
        status = "CASE WHEN CURTIME() > '08:30:00' THEN 'Late' ELSE 'Present' END"
        cur.execute(f"""
            INSERT INTO ATTENDANCE
              (employee_id, attendance_date, check_in_time, status, remarks)
            VALUES (%s, CURDATE(), CURTIME(), {status}, %s)
        """, (emp_id, remarks))
    else:
        cur.execute("""
            INSERT INTO ATTENDANCE
              (employee_id, attendance_date, check_in_time, status, remarks)
            VALUES (%s, CURDATE(), CURTIME(), %s, %s)
        """, (emp_id, status, remarks))

    db.commit()
    cur.close(); db.close()
    flash(f'Check-in successful!', 'success')
    return redirect(url_for('attendance.list_attendance'))

@attendance_bp.route('/checkout', methods=['POST'])
@login_required
def checkout():
    db  = get_db()
    cur = db.cursor()

    emp_id = request.form['employee_id']

    # Cập nhật check_out_time cho bản ghi hôm nay
    cur.execute("""
        UPDATE ATTENDANCE
        SET check_out_time = CURTIME()
        WHERE employee_id = %s
          AND attendance_date = CURDATE()
          AND check_out_time IS NULL
    """, (emp_id,))

    if cur.rowcount == 0:
        flash('No active check-in found for this employee today.', 'warning')
    else:
        db.commit()
        flash('Check-out successful!', 'success')

    cur.close(); db.close()
    return redirect(url_for('attendance.list_attendance'))