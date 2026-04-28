from flask import Flask, render_template, flash, request, redirect, url_for
from routes.employees  import employees_bp
from routes.attendance import attendance_bp
from routes.leave      import leave_bp
from config import get_db
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from flask import session, redirect, url_for, request

app = Flask(__name__)
app.secret_key = 'emps-secret-2026'

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'  # redirect về trang login nếu chưa đăng nhập

# User cứng — không cần DB
class AdminUser(UserMixin):
    def __init__(self):
        self.id = 'admin'

@login_manager.user_loader
def load_user(user_id):
    if user_id == 'admin':
        return AdminUser()
    return None

app.register_blueprint(employees_bp,  url_prefix='/employees')
app.register_blueprint(attendance_bp, url_prefix='/attendance')
app.register_blueprint(leave_bp,      url_prefix='/leave')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username == 'admin' and password == '123456':
            login_user(AdminUser())
            return redirect(url_for('dashboard'))
        flash('Invalid username or password.', 'danger')
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/')
@login_required
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