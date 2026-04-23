from flask import Blueprint, render_template, request, redirect, url_for, flash
from config import get_db

leave_bp = Blueprint('leave', __name__)

@leave_bp.route('/')
def list_leave():
    db  = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT lr.leave_id, lr.start_date, lr.end_date, lr.status, lr.reason,
               CONCAT(e.first_name,' ',e.last_name) AS full_name,
               lt.type_name,
               DATEDIFF(lr.end_date, lr.start_date)+1 AS days_requested
        FROM LEAVE_REQUEST lr
        JOIN EMPLOYEE   e  ON lr.employee_id = e.employee_id
        JOIN LEAVE_TYPE lt ON lr.leave_type  = lt.type_id
        ORDER BY FIELD(lr.status,'Pending','Approved','Rejected'), lr.start_date
    """)
    requests = cur.fetchall()
    cur.close(); db.close()
    return render_template('leave/list.html', requests=requests)

@leave_bp.route('/approve/<int:leave_id>')
def approve(leave_id):
    db  = get_db()
    cur = db.cursor()
    cur.execute("UPDATE LEAVE_REQUEST SET status='Approved' WHERE leave_id=%s", (leave_id,))
    db.commit()
    cur.close(); db.close()
    flash('Đã duyệt đơn nghỉ phép.', 'success')
    return redirect(url_for('leave.list_leave'))

@leave_bp.route('/reject/<int:leave_id>')
def reject(leave_id):
    db  = get_db()
    cur = db.cursor()
    cur.execute("UPDATE LEAVE_REQUEST SET status='Rejected' WHERE leave_id=%s", (leave_id,))
    db.commit()
    cur.close(); db.close()
    flash('Đã từ chối đơn nghỉ phép.', 'warning')
    return redirect(url_for('leave.list_leave'))