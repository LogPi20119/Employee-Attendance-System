from flask import Flask, render_template
from routes.employees  import employees_bp
from routes.attendance import attendance_bp
from routes.leave      import leave_bp
from config import get_db

app = Flask(__name__)
app.secret_key = 'emps-secret-2026'

app.register_blueprint(employees_bp,  url_prefix='/employees')
app.register_blueprint(attendance_bp, url_prefix='/attendance')
app.register_blueprint(leave_bp,      url_prefix='/leave')

@app.route('/')
def dashboard():
    db  = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("SELECT COUNT(*) AS total FROM EMPLOYEE WHERE is_active=1")
    total_emp = cur.fetchone()['total']
    cur.execute("""
        SELECT COUNT(*) AS total FROM ATTENDANCE
        WHERE attendance_date=CURDATE() AND status='Present'
    """)
    present_today = cur.fetchone()['total']
    cur.execute("SELECT COUNT(*) AS total FROM LEAVE_REQUEST WHERE status='Pending'")
    pending_leave = cur.fetchone()['total']
    cur.close(); db.close()
    return render_template('dashboard.html',
        total_emp=total_emp,
        present_today=present_today,
        pending_leave=pending_leave)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5000)