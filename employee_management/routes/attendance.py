from flask import Blueprint, render_template, request, redirect, url_for, flash
from config import get_db
from datetime import date

attendance_bp = Blueprint('attendance', __name__)

@attendance_bp.route('/')
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
    cur.close(); db.close()
    return render_template('attendance/list.html',
                           records=records, selected_date=selected_date)

@attendance_bp.route('/checkin', methods=['POST'])
def checkin():
    db  = get_db()
    cur = db.cursor()
    cur.execute("""
        INSERT INTO ATTENDANCE (employee_id, attendance_date, check_in_time, status)
        VALUES (%s, CURDATE(), CURTIME(),
            CASE WHEN CURTIME() > '08:30:00' THEN 'Late' ELSE 'Present' END)
    """, (request.form['employee_id'],))
    db.commit()
    cur.close(); db.close()
    flash('Check-in thành công!', 'success')
    return redirect(url_for('attendance.list_attendance'))