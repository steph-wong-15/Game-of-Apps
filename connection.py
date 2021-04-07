from flask import Flask, render_template, request
from flaskext.mysql import MySQL

app = Flask(__name__)

app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'goa'

mysql = MySQL(app)


@app.route("/")
def searchPage():
    return render_template("home.html")

@app.route('/students')
def students():
    return render_template("students.html")

@app.route('/events')
def events():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaEvent ORDER BY Date;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("events.html",events=fetchdata)

@app.route('/suggestions')
def suggestions():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("suggestions.html",suggestions=fetchdata)

@app.route('/eventDetails',methods=['GET','POST'])
def eventDetails():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaEvent WHERE EventID = %s;"
    cursor.execute(string,(id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("eventDetails.html",eventData=fetchdata)

@app.route('/student_profile', methods=['GET', 'POST'])
def studentProfile():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, (id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("student_profile.html", data=fetchdata)

@app.route('/suggestionDetails',methods=['GET','POST'])
def suggestionDetails():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions WHERE SuggestionID = %s;"
    cursor.execute(string,(id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("suggestionDetails.html",suggestionData=fetchdata)


if __name__ == "__main__":
    app.run(debug=True)