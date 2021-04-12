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


class completedChallenges(db.Model):
    __tablename__ = 'challengecompletes'
    ChallengeID = db.Column(db.Integer, primary_key=True)
    UserID = db.Column(db.Integer, primary_key=True)
    Mark = db.Column(db.Integer)
    Progress = db.Column(db.String(50))


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
        password = request.form['password']
        user = goaUser.query.filter(goaUser.UserID == userID).one()
        user.Password = password
        db.session.commit()
        return redirect(url_for("studentSearch", userID = userID))
        
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
    return render_template("events.html", events=fetchdata, eventsOC=fetchdata2, userID=userID)


@app.route('/suggestions', methods=['POST', 'GET'])
def suggestions():
    suggestionInserted = False;

    # Inserting Data
    if request.method == 'POST':

        suggestionInserted = True;

        cursor = mysql.get_db().cursor()
        cursor.execute("SELECT MAX(SuggestionID) FROM AnonymousSuggestions")

        suggestion = cursor.fetchall()
        suggestion = int(suggestion[0][0])
        suggestion = suggestion + 1

        print(suggestion)

        device = request.form['Device']
        text = request.form['Text']
        conn = mysql.get_db()
        cursor = mysql.get_db().cursor()
        cursor.execute("INSERT INTO AnonymousSuggestions (SuggestionID,Device,Text) VALUES (%s,%s,%s)",
                       (suggestion, device, text))
        conn.commit()
        cursor.close()
        conn.close()
        return render_template("suggestions.html", userID=userID, suggestionInserted=suggestionInserted)

    # Searching the Data
    else:
        return render_template("suggestions.html", userID=userID, suggestionInserted=suggestionInserted)



@app.route('/mentor_suggestions', methods=['POST', 'GET'])
def mentor_suggestions():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    string2 = "SELECT Device,COUNT(*) AS 'count' FROM AnonymousSuggestions GROUP BY Device;"
    cursor.execute(string2)
    fetchdata2 = cursor.fetchall()
    cursor.close()
    return render_template("mentor_suggestions.html", suggestions=fetchdata,device_suggestions=fetchdata2)


@app.route('/lessons')
def lessons():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM lesson INNER JOIN course ON lesson.CourseID = course.CourseID ORDER BY lesson.weekNumber"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("lessons.html", lessons=fetchdata, userID=userID)


@app.route('/assignment/<string:lessonID>')
def assignment(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM assignment WHERE LessonID = %s ;"
    cursor.execute(string, lessonID)
    assignmentData = cursor.fetchall()
    cursor.close()
    return render_template("assignment.html", assignmentData=assignmentData, userID=userID)


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

    return render_template("challenge.html", questions=randomized, userID=userID)


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
        answer = request.form.get(str(question[1]))
        if answer != question[2]:
            passed = False
        else:
            score = score + 1

    newMark = int(score / total * 100)

    # Update challenge mark
    cursor = mysql.get_db().cursor()
    cursor.execute("SELECT Mark FROM challengecompletes WHERE ChallengeID = %s and UserID = %s", (challengeID, userID))
    cursor.close()
    mark = cursor.fetchone()
    #add mark if doesn't already exist
    if mark is not None:
        mark = int(mark[0])
        if newMark > mark:
            progress = completedChallenges.query.filter((completedChallenges.ChallengeID == challengeID) & (completedChallenges.UserID == userID)).one()
            progress.Mark = newMark
            db.session.commit()
    #if exists: update if new score is higher
    else:
        conn = mysql.get_db()
        cursor = mysql.get_db().cursor()
        cursor.execute("INSERT INTO challengecompletes (ChallengeID, UserID, Mark, Progress) VALUES (%s,%s,%s,%s)",
                       (challengeID, userID, newMark, '100/100'))
        conn.commit()
        cursor.close()

    # ADD BADGE IF FULL MARKS
    alreadyEarned = False
    badgeURL = "null"
    if passed:
        #get badge ID
        cursor = mysql.get_db().cursor()
        cursor.execute("SELECT BadgeID FROM challenge WHERE ChallengeID = %s;", challengeID)
        cursor.close()
        badgeID = cursor.fetchone()[0]

        #check if user already has badge
        cursor = mysql.get_db().cursor()
        cursor.execute("SELECT BadgeID, UserID FROM earned WHERE BadgeID = %s and UserID = %s", (badgeID, userID))
        ifExists = cursor.fetchone()
        cursor.close()

        #if they don't add the badge
        if ifExists is None:
            conn = mysql.get_db()
            cursor = mysql.get_db().cursor()
            cursor.execute("INSERT INTO earned (UserID, BadgeID) VALUES (%s,%s)",
                           (userID, badgeID))
            conn.commit()
            cursor.execute("SELECT EarnedURL From badge WHERE BadgeID IN (SELECT BadgeID From Challenge WHERE ChallengeID = %s)", challengeID)
            badgeURL = cursor.fetchall()[0]
            cursor.close()
            conn.close()

        else:
            alreadyEarned = True

    return render_template("challengeComplete.html", passed=passed, score=score, total=total, userID=userID,
                           alreadyEarned=alreadyEarned, badgeURL = badgeURL)


@app.route('/resource/<string:lessonID>')
def resource(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM resources WHERE LessonID = %s;"
    cursor.execute(string, lessonID)
    resources = cursor.fetchall()
    cursor.close()
    return render_template("resource.html", resources=resources, userID=userID)


@app.route('/students', methods=['GET', 'POST'])
def studentTable():
    cursor = mysql.get_db().cursor()
    cursor.execute("SELECT * FROM goaUser")
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("students.html", student=fetchdata)


@app.route('/student_profile/<string:userID>', methods=['GET', 'POST'])
def studentSearch(userID):
    if (userID == '000000'):
        userID = request.form["id"]
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
    return render_template("student_profile.html", student=fetchdata, badge=badgeURL, assign=assignComplete,
                           challenge=challengeComplete, signedIn=signedIn, userID=userID)


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

    return render_template("teams.html", teams=teamsdata, winners=winnersdata, userID=userID)


@app.route('/members/<string:teamID>')
def members(teamID):
    # get the members in each team
    cursor = mysql.get_db().cursor()
    string = "SELECT teamID, FirstName, LastName FROM goaUser WHERE teamID = %s;"
    cursor.execute(string, teamID)
    membersdata = cursor.fetchall()
    cursor.close()

    return render_template("members.html", members=membersdata, userID=userID)


if __name__ == "__main__":
    app.run(debug=True)
