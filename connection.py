from flask import Flask, render_template
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'fdsafdsa'

mysql = MySQL(app)


@app.route('/')
def home():
    return render_template("home.html")


@app.route('/students')
def students():
    return render_template("students.html")


if __name__ == "__main__":
    app.run(debug=True)
