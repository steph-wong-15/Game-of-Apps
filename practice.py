from flask import Flask, render_template, request
from flaskext.mysql import MySQL

app = Flask(__name__)

app.config['MYSQL_DATABASE_HOST'] = '127.0.0.1'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'Atjdwkd0124@'
app.config['MYSQL_DATABASE_DB'] = 'FLASK'

mysql = MySQL(app)


@app.route("/")
def searchPage():
    return render_template("home.html")

@app.route('/students')
def students():
    return render_template("students.html")

@app.route('/events')
def events():
    return render_template("events.html")

@app.route('/suggestions')
def suggestions():
    return render_template("suggestions.html")

@app.route('/event_profile',methods=['GET','POST'])
def eventProfile():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaEvent WHERE EventID = %s;"
    cursor.execute(string,(id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("event_profile.html",data=fetchdata)

@app.route('/student_profile', methods=['GET', 'POST'])
def studentProfile():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, (id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("student_profile.html", data=fetchdata)

@app.route('/suggestion_profile',methods=['GET','POST'])
def suggestionProfile():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions WHERE SuggestionID = %s;"
    cursor.execute(string,(id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("suggestion_profile.html",data=fetchdata)


if __name__ == "__main__":
    app.run(debug=True)