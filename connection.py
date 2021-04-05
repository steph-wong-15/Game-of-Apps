from flask import Flask, render_template, request
from flaskext.mysql import MySQL

app = Flask(__name__)

app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'goa'

mysql = MySQL(app)


@app.route("/")
def homePage():
    return render_template("home.html")


@app.route('/students', methods=['GET', 'POST'])
def studentTable():
    cursor = mysql.get_db().cursor()
    cursor.execute("SELECT * FROM goaUser")
    fetchdata = cursor.fetchall()
    cursor.close()
    #print(fetchdata)
    return render_template("students.html", student =fetchdata)

@app.route('/student_profile', methods=['GET', 'POST'])
def studentSearch():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, (id))
    fetchdata = cursor.fetchall()
    cursor.close()

    #getting badge
    badgeURL = ''
    cursor = mysql.get_db().cursor()
    string = "SELECT B.EarnedURL FROM Badge B JOIN Earned E WHERE E.UserID = %s AND B.BadgeID = E.BadgeID;"
    cursor.execute(string, (id))
    badgeURL = cursor.fetchall()
    cursor.close()
    
    # getting completed assignments
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT AssignmentID FROM AssignmentCompletes WHERE UserID = %s AND CompletionStatus = 'Complete' ;"
    cursor.execute(string, (id))
    assignComplete = cursor.fetchall()
    cursor.close()

    #getting completed challenges
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT ChallengeID, Mark FROM ChallengeCompletes WHERE UserID = %s AND Progress = '100/100' ;"
    cursor.execute(string, (id))
    challengeComplete = cursor.fetchall()
    cursor.close()
    print(challengeComplete)

    return render_template("student_profile.html", student=fetchdata, badge=badgeURL, assign=assignComplete, challenge=challengeComplete)




if __name__ == "__main__":
    app.run(debug=True)