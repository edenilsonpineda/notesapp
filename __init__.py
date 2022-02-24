import os

from flask import Flask, render_template, redirect, url_for, request, session, flash
from flask_migrate import Migrate
from werkzeug.security import generate_password_hash, check_password_hash


def create_app(test_config=None):
    app = Flask(__name__)
    app.config.from_mapping(
        SECRET_KEY=os.environ.get('SECRET_KEY', default='dev')
    )

    if test_config is None:
        app.config.from_pyfile('config.py', silent=True)
    else:
        app.config.from_mapping(test_config)

    from .models import db, User
    db.init_app(app)
    migrate = Migrate(app, db)

    @app.route('/sign_up', methods=('GET', 'POST'))
    def sign_up():
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            error = None

            if not username:
                error = 'El nombre de usuario es requerido.'
            elif not password:
                error = 'La contraseña es requerida.'
            elif User.query.filter_by(userName=username).first():
                error = 'El usuario ingresado no se encuentra disponible. Intenta con otro nombre!'

            if error is None:
                user = User(userName=username, password=generate_password_hash(password))
                db.session.add(user)
                db.session.commit()
                flash('Registro completado exitosamente! Por favor inicia sesión', 'success')
                return redirect(url_for('log_in'))

            flash(error, 'error')

        return render_template('sign_up.html')

    @app.route('/log_in', methods=('GET', 'POST'))
    def log_in():
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            error = None

            user = User.query.filter_by(userName=username).first()

            if not user or not check_password_hash(user.password, password):
                error = 'Usuario / Contraseña incorrectos. Por favor verificar!'

            if error is None:
                session.clear()
                session['user_id'] = user.id
                return redirect(url_for('index'))

            flash(error, 'error')

        return render_template('login.html')

    @app.route('/log_out', methods=('GET', 'DELETE'))
    def log_out():
        session.clear()
        flash('Sesión cerrada exitosamente', 'success')
        return redirect(url_for('log_in'))

    @app.route('/')
    def index():
        return "Index"

    return app

