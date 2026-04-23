from flask import Blueprint, render_template, request, redirect, url_for, flash
from config import get_db

employees_bp = Blueprint('employees', __name__)

@employees_bp.route('/')
def list_employees():
    db  = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT e.employee_id, e.first_name, e.last_name,
               e.email, e.position, e.is_active, d.dept_name
        FROM EMPLOYEE e
        LEFT JOIN DEPARTMENT d ON e.dept_id = d.dept_id
        ORDER BY d.dept_name, e.last_name
    """)
    employees = cur.fetchall()
    cur.close(); db.close()
    return render_template('employees/list.html', employees=employees)

@employees_bp.route('/add', methods=['GET', 'POST'])
def add_employee():
    db  = get_db()
    cur = db.cursor(dictionary=True)
    if request.method == 'POST':
        cur.execute("""
            INSERT INTO EMPLOYEE
              (first_name, last_name, email, hire_date, position, dept_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            request.form['first_name'],
            request.form['last_name'],
            request.form['email'],
            request.form['hire_date'],
            request.form['position'],
            request.form['dept_id']
        ))
        db.commit()
        flash('Thêm nhân viên thành công!', 'success')
        cur.close(); db.close()
        return redirect(url_for('employees.list_employees'))
    cur.execute("SELECT dept_id, dept_name FROM DEPARTMENT")
    departments = cur.fetchall()
    cur.close(); db.close()
    return render_template('employees/add.html', departments=departments)

@employees_bp.route('/delete/<int:emp_id>')
def delete_employee(emp_id):
    db  = get_db()
    cur = db.cursor()
    cur.execute("UPDATE EMPLOYEE SET is_active=0 WHERE employee_id=%s", (emp_id,))
    db.commit()
    cur.close(); db.close()
    flash('Đã vô hiệu hóa nhân viên.', 'warning')
    return redirect(url_for('employees.list_employees'))