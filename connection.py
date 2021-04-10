import random
from flask import Flask, render_template, request, flash, redirect, url_for
from flaskext.mysql import MySQL
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'goa'

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/goa'

db = SQLAlchemy(app)

mysql = MySQL(app)

app.secret_key = 'secret'


class goaUser(db.Model):
    __tablename__ = 'goaUser'
    UserID = db.Column(db.Integer, primary_key=True)
    FirstName = db.Column(db.String(50))
    LastName = db.Column(db.String(50))
    School = db.Column(db.String(50))
    ImageURL = db.Column(db.String)
    Email = db.Column(db.String(100))
    UserType = db.Column(db.String(50))
    TeamID = db.Column(db.Integer)
    CohortID = db.Column(db.Integer)
    Password = db.Column(db.String(15))


@app.route("/", methods=['POST', 'GET'])
def login():
    global signedIn
    signedIn = False
    if request.method == "POST":
        if 'email' in request.form and 'password' in request.form:
            email = request.form["email"]
            password = request.form["password"]
            cursor = mysql.get_db().cursor()
            cursor.execute("SELECT Email,Password FROM goaUser WHERE Email = %s and Password = %s", (email, password))
            info = cursor.fetchone()
            if info is not None:
                cursor.execute("SELECT UserID FROM goaUser WHERE Email = %s;", email)
                global userID  # save the user who logged in in a global variable
                userID = cursor.fetchall()
                userID = userID[0][0]
                signedIn = True
                return redirect(url_for('lessons'))
            else:
                print("LOGIN FAILED, TRY AGAIN")
                return redirect(url_for('login'))  # should redirect to the 'login'
    return render_template("login.html")

@app.route('/update', methods=['POST', 'GET'])

def updatePassword():
    if request.method == 'POST':
        userID = request.form['userID']
        password = request.form['password']
        user = goaUser.query.filter(goaUser.UserID == userID).one()
        user.Password = password
        db.session.commit()
        return render_template("login.html")
    else:
        return render_template("update.html")

@app.route('/events')
def events():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaEvent ORDER BY Date;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    string2 = "SELECT * FROM goaEvent A WHERE NOT EXISTS (SELECT Location FROM CanadianLocations B WHERE A.Location = B.Location);"
    cursor.execute(string2)
    fetchdata2 = cursor.fetchall()
    cursor.close()
    return render_template("events.html", events=fetchdata, eventsOC=fetchdata2, userID = userID)


@app.route('/suggestions', methods=['POST', 'GET'])
def suggestions():
    # Inserting Data
    if request.method == 'POST':
        suggestion = request.form['SuggestionID']
        device = request.form['Device']
        text = request.form['Text']
        conn = mysql.get_db()
        cursor = mysql.get_db().cursor()
        cursor.execute("INSERT INTO AnonymousSuggestions (SuggestionID,Device,Text) VALUES (%s,%s,%s)",
                       (suggestion, device, text))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('suggestions'))
    # Searching the Data
    else:
        cursor = mysql.get_db().cursor()
        string = "SELECT * FROM AnonymousSuggestions;"
        cursor.execute(string)
        fetchdata = cursor.fetchall()
        cursor.close()
        return render_template("suggestions.html", suggestions=fetchdata, userID = userID)


@app.route('/mentor_suggestions', methods=['POST', 'GET'])
def mentor_suggestions():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("mentor_suggestions.html", suggestions=fetchdata)


@app.route('/lessons')
def lessons():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM lesson INNER JOIN course ON lesson.CourseID = course.CourseID ORDER BY lesson.weekNumber"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("lessons.html", lessons=fetchdata, userID = userID)


@app.route('/assignment/<string:lessonID>')
def assignment(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM assignment WHERE LessonID = %s ;"
    cursor.execute(string, lessonID)
    assignmentData = cursor.fetchall()
    cursor.close()
    return render_template("assignment.html", assignmentData=assignmentData, userID = userID)


@app.route('/challenge/<string:lessonID>')
def challenge(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM question WHERE ChallengeID IN (SELECT challengeID FROM challenge WHERE LessonID = %s);"
    cursor.execute(string, lessonID)
    questions = cursor.fetchall()
    cursor.close()

    # randomize the challenge questions!
    randomized = []
    for question in questions:
        temp = [question[2], question[3], question[4], question[5]]
        random.shuffle(temp)
        temp.append(question[6])
        temp.append(question[0])
        temp.append(question[1])
        randomized.append(temp)

    print(randomized)
    return render_template("challenge.html", questions=randomized, userID = userID)


@app.route('/challengeComplete/<string:challengeID>', methods=['GET', 'POST'])
def challengeComplete(challengeID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM question WHERE ChallengeID = %s;"
    cursor.execute(string, challengeID)
    q = cursor.fetchall()
    cursor.close()

    # check if they passed all the questions
    passed = True
    total = len(q)
    score = 0
    for question in q:
        print(question[1])
        answer = request.form.get(str(question[1]))
        if answer != question[2]:
            passed = False
        else:
            score = score + 1
    return render_template("challengeComplete.html", passed=passed, score=score, total=total, userID = userID)


@app.route('/resource/<string:lessonID>')
def resource(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM resources WHERE LessonID = %s;"
    cursor.execute(string, lessonID)
    resources = cursor.fetchall()
    cursor.close()
    return render_template("resource.html", resources=resources, userID = userID)


@app.route('/students', methods=['GET', 'POST'])
def studentTable():
    cursor = mysql.get_db().cursor()
    cursor.execute("SELECT * FROM goaUser")
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("students.html", student=fetchdata)


@app.route('/student_profile/<string:userID>', methods=['GET', 'POST'])
def studentSearch(userID):

    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, userID)
    fetchdata = cursor.fetchall()
    cursor.close()

    # getting badge
    badgeURL = ''
    cursor = mysql.get_db().cursor()
    string = "SELECT B.EarnedURL FROM Badge B JOIN Earned E WHERE E.UserID = %s AND B.BadgeID = E.BadgeID;"
    cursor.execute(string, (userID))
    badgeURL = cursor.fetchall()
    cursor.close()

    # getting completed assignments
    cursor = mysql.get_db().cursor()
    string = "SELECT Title FROM lesson WHERE LessonID IN (SELECT LessonID FROM Assignment WHERE AssignmentID IN (SELECT AssignmentID FROM AssignmentCompletes WHERE UserID = %s AND CompletionStatus = 'Complete'));"
    cursor.execute(string, (userID))
    assignComplete = cursor.fetchall()
    cursor.close()

    # getting completed challenges
    cursor = mysql.get_db().cursor()
    string = "SELECT lesson.Title, challengecompletes.Mark FROM lesson INNER JOIN challenge ON lesson.LessonID = challenge.LessonID INNER JOIN challengecompletes ON challenge.ChallengeID = challengecompletes.ChallengeID WHERE challengecompletes.UserID = %s;"
    cursor.execute(string, (userID))
    challengeComplete = cursor.fetchall()
    cursor.close()
    return render_template("student_profile.html", student=fetchdata, badge=badgeURL, assign=assignComplete, challenge=challengeComplete, signedIn = signedIn, userID = userID)


@app.route('/students/deleteUser/<string:userid>', methods=['GET', 'POST'])
def deleteUser(userid):
    # deleting user
    goaUser.query.filter(goaUser.UserID == userid).delete()
    db.session.commit()
    flash('User Successfully Deleted!')
    return redirect(url_for('studentTable'))


@app.route('/teams', methods=['GET', 'POST'])
def teams():
    # get a list of all the teams (in descending order by number of votes received)
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM team ORDER BY VotesReceived DESC;"
    cursor.execute(string)
    teamsdata = cursor.fetchall()
    cursor.close()

    # get the team with the max number of votes
    cursor = mysql.get_db().cursor()
    string = "SELECT Name, VotesReceived FROM Team WHERE VotesReceived = (SELECT MAX(VotesReceived) FROM Team);"
    cursor.execute(string)
    winnersdata = cursor.fetchall()
    cursor.close()

    return render_template("teams.html", teams=teamsdata, winners=winnersdata, userID = userID)


@app.route('/members/<string:teamID>')
def members(teamID):
    # get the members in each team
    cursor = mysql.get_db().cursor()
    string = "SELECT teamID, FirstName, LastName FROM goaUser WHERE teamID = %s;"
    cursor.execute(string, teamID)
    membersdata = cursor.fetchall()
    cursor.close()

    return render_template("members.html", members=membersdata, userID = userID)


if __name__ == "__main__":
    app.run(debug=True)
