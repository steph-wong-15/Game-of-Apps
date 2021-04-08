


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
    UserID = db.Column(db.Integer, primary_key = True)
    FirstName = db.Column(db.String(50))
    LastName = db.Column(db.String(50))
    School = db.Column(db.String(50))
    ImageURL = db.Column(db.String)
    Email = db.Column(db.String(100))
    UserType = db.Column(db.String(50))
    TeamID = db.Column(db.Integer)
    CohortID = db.Column(db.Integer)
    Password = db.Column(db.String(15))



@app.route("/")
def homePage():
    return render_template("home.html")


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
    return render_template("events.html",events=fetchdata,eventsOC=fetchdata2)




@app.route('/suggestions',methods=['POST','GET'])
def suggestions():
    if request.method == 'POST':
        suggestion = request.form['SuggestionID']
        device = request.form['Device']
        text = request.form['Text']
        conn = mysql.get_db()
        cursor = mysql.get_db().cursor()
        cursor.execute("INSERT INTO AnonymousSuggestions (SuggestionID,Device,Text) VALUES (%s,%s,%s)",(suggestion,device,text))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('suggestions'))
    else:
        cursor = mysql.get_db().cursor()
        string = "SELECT * FROM AnonymousSuggestions;"
        cursor.execute(string)
        fetchdata = cursor.fetchall()
        cursor.close()
        return render_template("suggestions.html",suggestions=fetchdata)



@app.route('/eventDetails', methods=['GET', 'POST'])
def eventDetails():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaEvent WHERE EventID = %s;"
    cursor.execute(string, (id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("eventDetails.html", eventData=fetchdata)


@app.route('/suggestionDetails', methods=['GET', 'POST'])
def suggestionDetails():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions WHERE SuggestionID = %s;"
    cursor.execute(string, (id))
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("suggestionDetails.html", suggestionData=fetchdata)


@app.route('/lessons')
def lessons():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM lesson ORDER BY weekNumber"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("lessons.html", lessons=fetchdata)


@app.route('/assignment/<string:lessonID>')
def assignment(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM assignment WHERE LessonID = %s ;"
    cursor.execute(string, lessonID)
    assignmentData = cursor.fetchall()
    cursor.close()
    return render_template("assignment.html", assignmentData=assignmentData)


@app.route('/challenge/<string:lessonID>')
def challenge(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM question WHERE ChallengeID IN (SELECT challengeID FROM challenge WHERE LessonID = %s);"
    cursor.execute(string, lessonID)
    questions = cursor.fetchall()
    cursor.close()

    #randomize the challenge questions!
    randomized = []
    for question in questions:
        temp = [question[2], question[3], question[4], question[5]]
        random.shuffle(temp)
        temp.append(question[6])
        temp.append(question[0])
        temp.append(question[1])
        randomized.append(temp)

    print(randomized)
    return render_template("challenge.html", questions=randomized)


@app.route('/challengeComplete/<string:challengeID>', methods=['GET', 'POST'])
def challengeComplete(challengeID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM question WHERE ChallengeID = %s;"
    cursor.execute(string, challengeID)
    q = cursor.fetchall()
    cursor.close()

    #check if they passed all the questions
    passed = True
    total = len(q)
    score = 0;
    for question in q:
        print(question[1])
        answer = request.form.get(str(question[1]))
        if answer != question[2]:
            passed = False;
        else:
            score = score + 1
    return render_template("challengeComplete.html", passed = passed, score = score, total = total)


@app.route('/students', methods=['GET', 'POST'])
def studentTable():
    cursor = mysql.get_db().cursor()
    cursor.execute("SELECT * FROM goaUser")
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("students.html", student =fetchdata)


@app.route('/student_profile', methods=['GET', 'POST'])
def studentSearch():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, id)
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
    return render_template("student_profile.html", student=fetchdata, badge=badgeURL, assign=assignComplete, challenge=challengeComplete)

@app.route('/teams', methods=['GET', 'POST'])
def teams():

	#get a list of all the teams (in descending order by number of votes received)
	cursor = mysql.get_db().cursor()
	string = "SELECT * FROM team ORDER BY VotesReceived DESC;"
	cursor.execute(string)
	teamsdata = cursor.fetchall()
	cursor.close()

	#get the team with the max number of votes
	cursor = mysql.get_db().cursor()
	string = "SELECT Name, VotesReceived FROM Team WHERE VotesReceived = (SELECT MAX(VotesReceived) FROM Team);"
	cursor.execute(string)
	winnersdata = cursor.fetchall()
	cursor.close()

	return render_template("teams.html", teams=teamsdata, winners=winnersdata)

@app.route('/members/<string:teamID>')
def members(teamID):

	#get the members in each team
	cursor = mysql.get_db().cursor()
	string = "SELECT teamID, FirstName, LastName FROM goaUser WHERE teamID = %s;"
	cursor.execute(string, teamID)
	membersdata = cursor.fetchall()
	cursor.close()

	return render_template("members.html", members=membersdata)

if __name__ == "__main__":
    app.run(debug=True)
