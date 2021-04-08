import random
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


@app.route('/events')
def events():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaEvent ORDER BY Date;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("events.html", events=fetchdata)


@app.route('/suggestions')
def suggestions():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM AnonymousSuggestions;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("suggestions.html", suggestions=fetchdata)


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
    string = "SELECT * FROM lesson INNER JOIN course ON lesson.CourseID = course.CourseID ORDER BY lesson.weekNumber"
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

@app.route('/resource/<string:lessonID>')
def resource(lessonID):
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM resources WHERE LessonID = %s;"
    cursor.execute(string, lessonID)
    resources = cursor.fetchall()
    cursor.close()
    return render_template("resource.html", resources=resources)


@app.route('/students', methods=['GET', 'POST'])
def studentTable():
    cursor = mysql.get_db().cursor()
    cursor.execute("SELECT * FROM goaUser")
    fetchdata = cursor.fetchall()
    cursor.close()
    # print(fetchdata)
    return render_template("students.html", student=fetchdata)


@app.route('/student_profile', methods=['GET', 'POST'])
def studentSearch():
    id = request.form['id']
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM goaUser WHERE UserID = %s ;"
    cursor.execute(string, id)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("student_profile.html", student=fetchdata)


@app.route('/teams', methods=['GET', 'POST'])
def teams():
    cursor = mysql.get_db().cursor()
    string = "SELECT * FROM team ORDER BY VotesReceived DESC;"
    cursor.execute(string)
    fetchdata = cursor.fetchall()
    cursor.close()
    return render_template("teams.html", teams=fetchdata)


if __name__ == "__main__":
    app.run(debug=True)
