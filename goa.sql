CREATE TABLE Challenge (
    ChallengeID 	INT NOT NULL UNIQUE,
    BadgeID		INT,
    LessonID		INT,
    PRIMARY KEY	(ChallengeID));      

CREATE TABLE Question (
  ChallengeID 	INT NOT NULL,
  QuestionID 		INT NOT NULL,
  Answer 		VARCHAR(200),
  fakeAnswer1	VARCHAR(200) ,
  FakeAnswer2 	VARCHAR(200),
  FakeAnswer3 	VARCHAR(200),
  Text 			text,
PRIMARY KEY (QuestionID));

CREATE TABLE Assignment (
    AssignmentID	INT NOT NULL UNIQUE,
    LessonID	INT,
    Format	VARCHAR(200),
    Description	TEXT,
    DueTime	TIME,
    PRIMARY KEY (AssignmentID));

CREATE TABLE AnonymousSuggestions (
    SuggestionID	INT NOT NULL UNIQUE,
    Device		VARCHAR(100),
    Text		TEXT,
    PRIMARY KEY (SuggestionID));
       
CREATE TABLE AssignmentCompletes(
    AssignmentID	INT NOT NULL,
    UserID		INT NOT NULL,
    CompletionStatus   VARCHAR(100),
    PRIMARY KEY (AssignmentID, UserID));
    
CREATE TABLE ChallengeCompletes (
    ChallengeID		 INT NOT NULL,
    UserID			 INT NOT NULL,
    Mark			 INT,
    Progress		 VARCHAR(100),
    PRIMARY KEY(ChallengeID, UserID));
    
 CREATE TABLE LessonIsIn (
     LessonID		INT NOT NULL,
     CohortID		INT NOT NULL,
     PRIMARY KEY(LessonID, CohortID));
     
     
 CREATE TABLE Earned (
     UserID	INT NOT NULL,
     BadgeID	INT NOT NULL,
     PRIMARY KEY (UserID, BadgeID));



CREATE TABLE Team (
TeamID INT NOT NULL UNIQUE,
Name VARCHAR(100) NOT NULL, 
TeamVideos VARCHAR(100), 
VotesReceived INT ,
PRIMARY KEY(TeamID));


CREATE TABLE Cohort (
CohortID INT NOT NULL UNIQUE, 
ProgressDate Date,
PRIMARY KEY(CohortID));


CREATE TABLE goaEvent(
EventID INT NOT NULL UNIQUE, 
Description TEXT,
Date DATE,
Location VARCHAR(100),
CohortID INT, 
PRIMARY KEY(EventID));

CREATE TABLE Badge (
	BadgeID	INT 	NOT NULL UNIQUE,
	Ordinal 		VARCHAR(10),
	Name		VARCHAR(100),
	NotEarnedURL	TEXT,
	EarnedURL	TEXT,
	Description	TEXT,
	CourseID	INT	NOT NULL,
	PRIMARY KEY	(BadgeID));	


CREATE TABLE goaUser(
	UserID		INT 	NOT NULL UNIQUE,
	FirstName	VARCHAR(50),
	MiddleInitial	VARCHAR(50),
	LastName	VARCHAR(50),
	School	VARCHAR(50),
	ImageURL	TEXT,
	Email		VARCHAR(100),
	UserType	VARCHAR(50),
	TeamID	INT	NOT NULL,
	CohortID	INT	NOT NULL,
	Password 	VARCHAR(15),
	PRIMARY KEY	(UserID));	

CREATE TABLE Resources(
ResourceID	INT NOT NULL UNIQUE, 
URL 		TEXT, 
Description	TEXT, 
LessonID	INT, 
PRIMARY KEY(ResourceID));

CREATE TABLE Lesson(
LessonID	INT NOT NULL UNIQUE, 
Type		VARCHAR(50), 
Description	TEXT, 
weekNumber	INT, 
Title		VARCHAR(50), 
startDate	DATE, 
endDate	DATE, 
slidesURL	TEXT, 
CourseID	INT, 
PRIMARY KEY(LessonID));

CREATE TABLE Course(
CourseID	INT NOT NULL UNIQUE, 
Name		VARCHAR(50), 
PRIMARY KEY(CourseID));

CREATE TABLE CanadianLocations(
	Location VARCHAR(100));


ALTER TABLE Resources ADD FOREIGN KEY (LessonID)  REFERENCES Lesson (LessonID);

ALTER TABLE Lesson ADD FOREIGN KEY (CourseID)  REFERENCES Course (CourseID);

ALTER TABLE Badge ADD FOREIGN KEY (CourseID)  REFERENCES Course(CourseID);

ALTER TABLE Earned ADD FOREIGN KEY (BadgeID)  REFERENCES Badge (BadgeID);

ALTER TABLE Earned ADD FOREIGN KEY (UserID)  REFERENCES goaUser (UserID) ON DELETE CASCADE;

ALTER TABLE goaUser ADD FOREIGN KEY (CohortID)  REFERENCES Cohort(CohortID);

ALTER TABLE goaUser ADD FOREIGN KEY (TeamID)  REFERENCES Team(TeamID);

ALTER TABLE goaEvent ADD FOREIGN KEY (CohortID)  REFERENCES Cohort(CohortID);

ALTER TABLE Challenge ADD FOREIGN KEY (LessonID)  REFERENCES Lesson (LessonID);

ALTER TABLE Challenge ADD FOREIGN KEY (BadgeID)  REFERENCES Badge (BadgeID);

ALTER TABLE Question ADD FOREIGN KEY (ChallengeID)  REFERENCES Challenge(ChallengeID);

ALTER TABLE Assignment ADD FOREIGN KEY (LessonID)  REFERENCES Lesson (LessonID);

ALTER TABLE AssignmentCompletes ADD FOREIGN KEY (AssignmentID) REFERENCES Assignment(AssignmentID);

ALTER TABLE AssignmentCompletes ADD FOREIGN KEY (UserID)  REFERENCES goaUser(UserID) ON DELETE CASCADE;

ALTER TABLE ChallengeCompletes ADD FOREIGN KEY (ChallengeID)  REFERENCES Challenge (ChallengeID);

ALTER TABLE ChallengeCompletes ADD FOREIGN KEY (UserID)  REFERENCES goaUser(UserID) ON DELETE CASCADE;

ALTER TABLE LessonIsIn ADD FOREIGN KEY (LessonID)  REFERENCES Lesson (LessonID);

ALTER TABLE LessonIsIn ADD FOREIGN KEY (CohortID)  REFERENCES Cohort (CohortID);

ALTER TABLE Earned ADD FOREIGN KEY (UserID)  REFERENCES goaUser (UserID) ON DELETE CASCADE;

ALTER TABLE Earned ADD FOREIGN KEY (BadgeID)  REFERENCES Badge (BadgeID);


DELIMITER $$
CREATE TRIGGER before_insert_suggestion 
BEFORE INSERT ON AnonymousSuggestions 
FOR EACH ROW
BEGIN
IF NEW.Device <> 'Android' AND NEW.Device <> 'iOS' THEN 
SET NEW.Device = 'Android';
END IF;

END $$

DELIMITER ;


DELIMITER $$
CREATE TRIGGER middleinitial_upper
BEFORE INSERT ON goaUser
FOR EACH ROW
BEGIN
   SET NEW.MiddleInitial = UPPER(NEW.MiddleInitial);
END $$

DELIMITER ;



INSERT INTO Course  VALUES(123456, 'Typography');
INSERT INTO Course  VALUES(234567, 'Colour Schemes');
INSERT INTO Course  VALUES(345678, 'Intro to Java');
INSERT INTO Course  VALUES(456789, 'Enums');
INSERT INTO Course  VALUES(567890, 'Design Sprint');

INSERT INTO Lesson VALUES(
111111, 
'design', 
'Importance of type choice and how to use it',
1, 
'Introduction to Design and Typography', 
'2020-10-06',
'2020-10-13',
'https://drive.google.com/file/d/1BSbW78Aha2U15ryaVIjQjXg3UqPWF0io/view?usp=shg',
123456);

INSERT INTO Lesson VALUES(
222222, 
'design', 
'Examples of typography choice in real application design',
2, 
'Typography Tips & Elements of Design', 
'2020-10-13',
'2020-10-20',
'https://drive.google.com/file/d/12gIlt7lb1-Dw-tESMYTOAE1d3t2e_jSo/view?usp=sharin',
123456);

INSERT INTO Lesson VALUES(
	333333, 
'dev', 
'Intro to java: functions',
4, 
'Functions', 
'2020-11-03',
'2020-11-10',
'https://drive.google.com/file/d/1aGjxpHQeUryd-YCcyXjs9vqJVxaiUjUW/view?usp=sharing',
345678);

INSERT INTO Lesson VALUES(
	444444, 
'dev', 
'Java collection data structures: Arrays, ArrayLists, and HashMaps',
5, 
'Collections', 
'2020-11-10',
'2020-11-17',
'https://drive.google.com/file/d/1xSoKpDctnN5F20eGeSybouz3I3OZuu-O/view?usp=sharing',
345678);

INSERT INTO Lesson VALUES(
	555555, 
'design', 
'First lesson of the design sprint series',
14, 
'Design Sprint_Planning and Mapping', 
'2021-02-09',
'2021-02-16',
'https://drive.google.com/file/d/1It-XwEYEQ4yFrIiGjcoz-NkBLqXOeP1h/view?usp=sharing',
567890);




INSERT INTO Badge VALUES (654321,'First','Hoarder to Order','www.earnedurl.com/fasfdsfsgagds','https://lh3.googleusercontent.com/proxy/fMrlcygqXMN-DOo69-iuVsIOBAcVENNUxkTAK6QpN8hMPINYQzVihVKRpPpyKW2S7P-PXRZT3X0qh4EyNZlRgFRXI4-AWCBNMUa_rljp5-4w7L95LeEtmyRxZw','Collections', 345678);

INSERT INTO Badge VALUES (765432,'Second','Finest of Fonts','www.earnedurl.com/fasfdsfsgagds','https://image.freepik.com/free-vector/2-winner-silver-medal-award-with-ribbon-realistic-icon-isolated-number-one-2nd-second-place-best-victory-champion-prize-award-silver-shiny-medal-badge_186921-65.jpg','Typography & Figma Tutorial: Typesetting',123456);

INSERT INTO Badge VALUES (876543,'Third','Fun-ctions','www.earnedurl.com/fasfdsfsgagds','https://builder.crownawards.com/StoreFront/ImageCompositionServlet?files=jsp/builderimages/BaseFiles/ROSBKRD.png,jsp/builderimages/ColorInsert/CM1013PXB.png,,&width=378&trim=true','Functions', 345678);

INSERT INTO Badge VALUES (987654,'Fourth','Mapping','www.earnedurl.com/fasfdsfsgagds', 'https://i.pinimg.com/originals/c3/e7/8c/c3e78caa6957b8d0406352aac8d29a9c.png', 'Design Sprint: Mapping', 567890);

INSERT INTO Badge VALUES (098765,'Fifth','Welcome Designer','www.earnedurl.com/fasfdsfsgagds','http://thetruthaboutcancer.com/wp-content/uploads/2014/08/5th.png','Intro to Design', 123456);


INSERT INTO Challenge VALUES (13579,654321,444444);
INSERT INTO Challenge VALUES (24680,765432,222222);
INSERT INTO Challenge VALUES (35791,876543,333333);
INSERT INTO Challenge VALUES (46802,987654,555555);
INSERT INTO Challenge VALUES (57913,098765,111111);

INSERT INTO Question VALUES(35791, 968567, 'String dogName = "Rufus";', 'dogName = "Rufus";', 'String dogName = Rufus', 'String dogName = "Rufus"', 'Create a variable that represents the name of your dog “Rufus”');

INSERT INTO Question VALUES(57913, 295867, 'collection of different\r\nstyles of a typefaces ', 'The size of the text you use', 'The language the text is in', 'The style of your design pattern', 'What is the definition of Font?');

INSERT INTO Question VALUES(57913, 548957, 'You should never combine type faces', 'When you wish to express two different dialogues', 'When you want to express two different emotions', 'When combining two different design styles', 'When should you combine more than two typefaces together?');

INSERT INTO Question VALUES(57913, 586646, 'All of the above', 'To make acronyms', 'To make emphasis', 'To make initials', 'When should you use small letters in Typography?');

INSERT INTO Question VALUES(13579, 898989, 'Hashmaps', 'Arrays', 'ArrayLists', 'To make initials', 'Which java data structure allows you to access values based on a key value?');

INSERT INTO Question VALUES(24680, 989898, 'Clan Pro', 'FF DIN
', 'Proxima Nova', 'Gilroy', 'What is Uber’s primary font?');

INSERT INTO Question VALUES(46802, 969696, 'To problem solve and create value', 'To make pretty drawings', 'To create UI/UX', 'To tell developers what to make', 'What is design?');




INSERT INTO Assignment  VALUES(
231231,
555555,
'Journey Map and User Flow Diagram',
'Update your maps by asking your intent users to verify the steps based on their tasks. Search up examples of similar apps to your ideas AND/OR certain cool things you like about other apps. Then, take notes of what in particular you like about other peoples ideas (your teammates will not have time to wait for you to show everything about the app).',
'11:59:59');

INSERT INTO Assignment  VALUES(
123123,
111111,
'Short Answer',
'Summarize the main points from the introduction to design and topography lecture',
'03:00:00'
);

INSERT INTO Assignment  VALUES(
321321,
222222,
'1 page write-up including images of the landing page screenshot',
'Pick your favourite productivity app. Analyze their landing page and identify the elements used. Explain why they were used.',
'06:59:59'
);

INSERT INTO Assignment  VALUES(
213213,
444444,
'Code',
'Create a variable that represents the name of your dog Rufus. Create a sentence using the above variable. The sentence should be "Come here, Rufus!" and should be printed to screen. Create another variable that represents whether Rufus is awake or asleep. Modify the above code so the sentence "Come here, Rufus!" is only printed when Rufus is awake. Otherwise, print the sentence "Shhh...".',
'12:00:00'
);

INSERT INTO Assignment  VALUES(
312312,
333333,
'Code',
'Write a basic Java program that allows users to make a To-Do list',
'03:00:00'
);


INSERT INTO Cohort VALUES(202110, '2021-10-01');
INSERT INTO Cohort VALUES(202010, '2020-10-01');
INSERT INTO Cohort VALUES(201910, '2019-10-01');
INSERT INTO Cohort VALUES(201810, '2018-10-01');
INSERT INTO Cohort VALUES(201710, '2017-10-01');

INSERT INTO Team  VALUES(789789, 'SandsView', 'https://www.youtube.com/watch?v=4xRkzG-oCcA', 10 );
INSERT INTO Team  VALUES(987987, 'RecyclerView', 'https://www.youtube.com/watch?v=y6KZt7FD4cw', 11);
INSERT INTO Team  VALUES(897897, 'Mission Impossible', 'https://www.youtube.com/watch?v=6Z99e6xjy8A', 15);
INSERT INTO Team  VALUES(798798, 'iVolunteer','https://www.youtube.com/watch?v=aiGR3uaEMOE', 12);
INSERT INTO Team  VALUES(879879, 'TBD', 'https://www.youtube.com/watch?v=n82M7Y0Y_1g',13 );

INSERT INTO goaEvent VALUES(190516, 'Field trip to Microsoft Vancouver', '2019-05-16','Vancouver',201910);
INSERT INTO goaEvent VALUES(190702, 'Soccer event to improve teamwork', '2019-07-02','Vancouver',201910);
INSERT INTO goaEvent VALUES(180417, 'Hackathon 2021', '2018-04-17','Vancouver',201810);
INSERT INTO goaEvent VALUES(170503, 'Frisbee event to improve teamwork', '2017-05-03','Vancouver',201710);
INSERT INTO goaEvent VALUES(200215, 'Field trip to EA Vancouver to learn more about video game industry', '2020-02-15','Vancouver',202010);

INSERT INTO goaUser VALUES(852852,'Andy','D','Jun','SFU','https://www.shareicon.net/data/512x512/2016/07/26/802016_man_512x512.png', 'ADJ@sfu.ca', 'CohortUser',789789, 202110,'abcd123');

INSERT INTO goaUser VALUES(582582,'Annie','A','Yao','SFU','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcKkr4jxij-WH9aUOAds3uX4JAwxcfaJz8vpr3OgG8uv7K0NLDa2_UZntJo_KrpPo9xXLm5-5peBA&usqp=CAU', 'AAY@sfu.ca', 'CohortUser',987987, 202110,'dcba123');

INSERT INTO goaUser VALUES(258258,'Stephanie','D','Wong','SFU','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK3Q7BhoMbLDHed_hHII9iS_SJvv0jTiFBRyoBAtlgWwSaQUjYvXN1RhWxKuc-nvItiFQEcwqYX2g&usqp=CAU', 'SDW@sfu.ca', 'CohortUser',987987, 202110,'efgh123');

INSERT INTO goaUser VALUES(528528,'Halakseka','H','Jegatheesan','SFU','https://casasanjose.org/wp-content/uploads/2020/07/woman-avatar-profile-round-icon_24640-14048-1.jpg', 'HHJ@sfu.ca', 'CohortUser',798798,202110,'hgfe123');

INSERT INTO goaUser VALUES(285285,'Mohammad','A','Tam','SFU',' https://i.dlpng.com/static/png/1376086-png-svg-profile-png-512_512_preview.png', 'MAT@sfu.ca', 'GraduatedUser',879879, 202010,'m1234a');

INSERT INTO goaEvent
VALUES(181010,"Machine Learning Seminar in Seoul","2018-10-10","Seoul",201810);

INSERT INTO goaEvent
VALUES(190510,"Field Trip to Silicon Valley","2019-05-10","San Jose",201910);

INSERT INTO goaEvent
VALUES(200120,"Hackathon 2020","2020-01-20","Toronto",202010);



INSERT INTO Earned VALUES(852852, 654321);
INSERT INTO Earned VALUES(582582, 654321);
INSERT INTO Earned VALUES(582582, 876543);
INSERT INTO Earned VALUES(258258, 098765);
INSERT INTO Earned VALUES(528528, 098765);


INSERT INTO Resources  VALUES(1010, 'https://www.youtube.com/watch?v=eIrMbAQSU34'    ,' Tutorial for Java', 333333);
INSERT INTO Resources  VALUES( 2020, 'https://docs.repl.it/tutorials/00-overview' ,'Basics of using repl.it', 333333);
INSERT INTO Resources  VALUES( 3030, ' https://www.youtube.com/watch?v=Xzk3XLveA00'    ,' Overview of Data S
tructures', 444444);
INSERT INTO Resources  VALUES( 4040, ' https://www.gv.com/sprint/'    ,' How Design Sprint works', 555555);
INSERT INTO Resources  VALUES( 5050, ' https://www.educba.com/user-interface-design-principles/'  ,' User Design Principles' ,111111);
INSERT INTO Resources  VALUES( 6060, ' https://creativemarket.com/blog/typography-rules'  ,' 20 Typography Rules Every Designer Should Know' ,222222);

INSERT INTO ChallengeCompletes VALUES(35791, 852852, 80, '100/100');
INSERT INTO ChallengeCompletes VALUES(57913, 582582, 60, '100/100');
INSERT INTO ChallengeCompletes VALUES(35791, 582582, 75, '100/100');
INSERT INTO ChallengeCompletes VALUES(24680, 258258, 93, '100/100');
INSERT INTO ChallengeCompletes VALUES(57913, 285285, 85, '100/100');

   
INSERT INTO LessonIsIn VALUES(111111, 202110);
INSERT INTO LessonIsIn VALUES(222222, 202110);
INSERT INTO LessonIsIn VALUES(333333, 202110);	
INSERT INTO LessonIsIn VALUES(444444, 202110);
INSERT INTO LessonIsIn VALUES(555555, 202110);


INSERT INTO AssignmentCompletes VALUES(231231, 852852, 'Complete' );
INSERT INTO AssignmentCompletes VALUES(123123, 852852, 'Incomplete');
INSERT INTO AssignmentCompletes VALUES(231231, 582582, 'Complete' );
INSERT INTO AssignmentCompletes VALUES(123123, 258258, 'Complete' );
INSERT INTO AssignmentCompletes VALUES(321321, 258258, 'Incomplete' );
INSERT INTO AssignmentCompletes VALUES(213213, 528528, 'Incomplete' );

INSERT INTO AnonymousSuggestions  VALUES(1,'Android', 'Can you guys make it simpler?!');
INSERT INTO AnonymousSuggestions  VALUES(2,'iOS', 'Not in detail');
INSERT INTO AnonymousSuggestions  VALUES(3,'Android', 'less homework');
INSERT INTO AnonymousSuggestions  VALUES(4,'Android', 'Hard to follow');
INSERT INTO AnonymousSuggestions  VALUES(5,'iOS', 'Not much effort put in');


INSERT INTO CanadianLocations
VALUES ("Vancouver");

INSERT INTO CanadianLocations
VALUES ("Toronto");

INSERT INTO CanadianLocations
VALUES ("Calgary");

