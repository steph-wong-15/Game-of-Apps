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
    id = request.form['id']
    cursor = mysql.connection.cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, (id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("students.html", data = fetchdata)


if __name__ == "__main__":
    app.run(debug=True)
