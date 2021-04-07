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

    return render_template("student_profile.html", student=fetchdata, badge=badgeURL, assign=assignComplete, challenge=challengeComplete)

@app.route('/students/deleteUser/<string:userid>', methods=['GET', 'POST'])
def deleteUser(userid):
    # deleting user
    goaUser.query.filter(goaUser.UserID == userid).delete()
    db.session.commit()
    flash('User Successfully Deleted!')
    return redirect(url_for('studentTable'))



if __name__ == "__main__":
    app.run(debug=True)