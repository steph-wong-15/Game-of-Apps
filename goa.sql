-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 13, 2021 at 09:52 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `goa`
--

-- --------------------------------------------------------

--
-- Table structure for table `anonymoussuggestions`
--

CREATE TABLE `anonymoussuggestions` (
  `SuggestionID` int(11) NOT NULL,
  `Device` varchar(100) DEFAULT NULL,
  `Text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `anonymoussuggestions`
--

INSERT INTO `anonymoussuggestions` (`SuggestionID`, `Device`, `Text`) VALUES
(1, 'Android', 'Can you guys make it simpler?!'),
(2, 'iOS', 'Not in detail'),
(3, 'Android', 'less homework'),
(4, 'Android', 'Hard to follow'),
(5, 'iOS', 'Not much effort put in');

--
-- Triggers `anonymoussuggestions`
--
DELIMITER $$
CREATE TRIGGER `before_insert_suggestion` BEFORE INSERT ON `anonymoussuggestions` FOR EACH ROW BEGIN
	IF NEW.Device <> 'Android' AND NEW.Device <> 'iOS' THEN 
		SET NEW.Device = 'Android';
	END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `assignment`
--

CREATE TABLE `assignment` (
  `AssignmentID` int(11) NOT NULL,
  `LessonID` int(11) DEFAULT NULL,
  `Format` varchar(200) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `DueTime` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `assignment`
--

INSERT INTO `assignment` (`AssignmentID`, `LessonID`, `Format`, `Description`, `DueTime`) VALUES
(123123, 111111, 'Short Answer', 'Summarize the main points from the introduction to design and topography lecture', '03:00:00'),
(213213, 444444, 'Code', 'Create a variable that represents the name of your dog Rufus. Create a sentence using the above variable. The sentence should be \"Come here, Rufus!\" and should be printed to screen. Create another variable that represents whether Rufus is awake or asleep. Modify the above code so the sentence \"Come here, Rufus!\" is only printed when Rufus is awake. Otherwise, print the sentence \"Shhh...\".', '12:00:00'),
(231231, 555555, 'Journey Map and User Flow Diagram', 'Update your maps by asking your intent users to verify the steps based on their tasks. Search up examples of similar apps to your ideas AND/OR certain cool things you like about other apps. Then, take notes of what in particular you like about other peoples ideas (your teammates will not have time to wait for you to show everything about the app).', '11:59:59'),
(312312, 333333, 'Code', 'Write a basic Java program that allows users to make a To-Do list', '03:00:00'),
(321321, 222222, '1 page write-up including images of the landing page screenshot', 'Pick your favourite productivity app. Analyze their landing page and identify the elements used. Explain why they were used.', '06:59:59');

-- --------------------------------------------------------

--
-- Table structure for table `assignmentcompletes`
--

CREATE TABLE `assignmentcompletes` (
  `AssignmentID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `CompletionStatus` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `assignmentcompletes`
--

INSERT INTO `assignmentcompletes` (`AssignmentID`, `UserID`, `CompletionStatus`) VALUES
(123123, 258258, 'Complete'),
(123123, 852852, 'Incomplete'),
(213213, 528528, 'Incomplete'),
(231231, 582582, 'Complete'),
(231231, 852852, 'Complete'),
(321321, 258258, 'Incomplete');

-- --------------------------------------------------------

--
-- Table structure for table `badge`
--

CREATE TABLE `badge` (
  `BadgeID` int(11) NOT NULL,
  `Ordinal` varchar(10) DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `NotEarnedURL` text DEFAULT NULL,
  `EarnedURL` text DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `CourseID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `badge`
--

INSERT INTO `badge` (`BadgeID`, `Ordinal`, `Name`, `NotEarnedURL`, `EarnedURL`, `Description`, `CourseID`) VALUES
(98765, 'Fifth', 'Welcome Designer', 'www.earnedurl.com/fasfdsfsgagds', 'http://thetruthaboutcancer.com/wp-content/uploads/2014/08/5th.png', 'Intro to Design', 123456),
(654321, 'First', 'Hoarder to Order', 'www.earnedurl.com/fasfdsfsgagds', 'https://lh3.googleusercontent.com/proxy/fMrlcygqXMN-DOo69-iuVsIOBAcVENNUxkTAK6QpN8hMPINYQzVihVKRpPpyKW2S7P-PXRZT3X0qh4EyNZlRgFRXI4-AWCBNMUa_rljp5-4w7L95LeEtmyRxZw', 'Collections', 345678),
(765432, 'Second', 'Finest of Fonts', 'www.earnedurl.com/fasfdsfsgagds', 'https://image.freepik.com/free-vector/2-winner-silver-medal-award-with-ribbon-realistic-icon-isolated-number-one-2nd-second-place-best-victory-champion-prize-award-silver-shiny-medal-badge_186921-65.jpg', 'Typography & Figma Tutorial: Typesetting', 123456),
(876543, 'Third', 'Fun-ctions', 'www.earnedurl.com/fasfdsfsgagds', 'https://builder.crownawards.com/StoreFront/ImageCompositionServlet?files=jsp/builderimages/BaseFiles/ROSBKRD.png,jsp/builderimages/ColorInsert/CM1013PXB.png,,&width=378&trim=true', 'Functions', 345678),
(987654, 'Fourth', 'Mapping', 'www.earnedurl.com/fasfdsfsgagds', 'https://i.pinimg.com/originals/c3/e7/8c/c3e78caa6957b8d0406352aac8d29a9c.png', 'Design Sprint: Mapping', 567890);

-- --------------------------------------------------------

--
-- Table structure for table `canadianlocations`
--

CREATE TABLE `canadianlocations` (
  `Location` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `canadianlocations`
--

INSERT INTO `canadianlocations` (`Location`) VALUES
('Vancouver'),
('Toronto'),
('Calgary');

-- --------------------------------------------------------

--
-- Table structure for table `challenge`
--

CREATE TABLE `challenge` (
  `ChallengeID` int(11) NOT NULL,
  `BadgeID` int(11) DEFAULT NULL,
  `LessonID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `challenge`
--

INSERT INTO `challenge` (`ChallengeID`, `BadgeID`, `LessonID`) VALUES
(13579, 654321, 444444),
(24680, 765432, 222222),
(35791, 876543, 333333),
(46802, 987654, 555555),
(57913, 98765, 111111);

-- --------------------------------------------------------

--
-- Table structure for table `challengecompletes`
--

CREATE TABLE `challengecompletes` (
  `ChallengeID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Mark` int(11) DEFAULT NULL,
  `Progress` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `challengecompletes`
--

INSERT INTO `challengecompletes` (`ChallengeID`, `UserID`, `Mark`, `Progress`) VALUES
(24680, 258258, 93, '100/100'),
(35791, 582582, 75, '100/100'),
(35791, 852852, 80, '100/100'),
(57913, 285285, 85, '100/100'),
(57913, 582582, 60, '100/100');

-- --------------------------------------------------------

--
-- Table structure for table `cohort`
--

CREATE TABLE `cohort` (
  `CohortID` int(11) NOT NULL,
  `ProgressDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cohort`
--

INSERT INTO `cohort` (`CohortID`, `ProgressDate`) VALUES
(201710, '2017-10-01'),
(201810, '2018-10-01'),
(201910, '2019-10-01'),
(202010, '2020-10-01'),
(202110, '2021-10-01');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `CourseID` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`CourseID`, `Name`) VALUES
(123456, 'Typography'),
(234567, 'Colour Schemes'),
(345678, 'Intro to Java'),
(456789, 'Enums'),
(567890, 'Design Sprint');

-- --------------------------------------------------------

--
-- Table structure for table `earned`
--

CREATE TABLE `earned` (
  `UserID` int(11) NOT NULL,
  `BadgeID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `earned`
--

INSERT INTO `earned` (`UserID`, `BadgeID`) VALUES
(258258, 98765),
(528528, 98765),
(582582, 654321),
(582582, 876543),
(852852, 654321);

-- --------------------------------------------------------

--
-- Table structure for table `goaevent`
--

CREATE TABLE `goaevent` (
  `EventID` int(11) NOT NULL,
  `Description` text DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `CohortID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `goaevent`
--

INSERT INTO `goaevent` (`EventID`, `Description`, `Date`, `Location`, `CohortID`) VALUES
(170503, 'Frisbee event to improve teamwork', '2017-05-03', 'Vancouver', 201710),
(180417, 'Hackathon 2021', '2018-04-17', 'Vancouver', 201810),
(181010, 'Machine Learning Seminar in Seoul', '2018-10-10', 'Seoul', 201810),
(190510, 'Field Trip to Silicon Valley', '2019-05-10', 'San Jose', 201910),
(190516, 'Field trip to Microsoft Vancouver', '2019-05-16', 'Vancouver', 201910),
(190702, 'Soccer event to improve teamwork', '2019-07-02', 'Vancouver', 201910),
(200120, 'Hackathon 2020', '2020-01-20', 'Toronto', 202010),
(200215, 'Field trip to EA Vancouver to learn more about video game industry', '2020-02-15', 'Vancouver', 202010);

-- --------------------------------------------------------

--
-- Table structure for table `goauser`
--

CREATE TABLE `goauser` (
  `UserID` int(11) NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `MiddleInitial` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `School` varchar(50) DEFAULT NULL,
  `ImageURL` text DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `UserType` varchar(50) DEFAULT NULL,
  `TeamID` int(11) NOT NULL,
  `CohortID` int(11) NOT NULL,
  `Password` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `goauser`
--

INSERT INTO `goauser` (`UserID`, `FirstName`, `MiddleInitial`, `LastName`, `School`, `ImageURL`, `Email`, `UserType`, `TeamID`, `CohortID`, `Password`) VALUES
(258258, 'Stephanie', 'D', 'Wong', 'SFU', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK3Q7BhoMbLDHed_hHII9iS_SJvv0jTiFBRyoBAtlgWwSaQUjYvXN1RhWxKuc-nvItiFQEcwqYX2g&usqp=CAU', 'SDW@sfu.ca', 'CohortUser', 987987, 202110, 'efgh123'),
(285285, 'Mohammad', 'A', 'Tam', 'SFU', ' https://i.dlpng.com/static/png/1376086-png-svg-profile-png-512_512_preview.png', 'MAT@sfu.ca', 'GraduatedUser', 879879, 202010, 'm1234a'),
(528528, 'Halakseka', 'H', 'Jegatheesan', 'SFU', 'https://casasanjose.org/wp-content/uploads/2020/07/woman-avatar-profile-round-icon_24640-14048-1.jpg', 'HHJ@sfu.ca', 'CohortUser', 798798, 202110, 'hgfe123'),
(582582, 'Annie', 'A', 'Yao', 'SFU', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcKkr4jxij-WH9aUOAds3uX4JAwxcfaJz8vpr3OgG8uv7K0NLDa2_UZntJo_KrpPo9xXLm5-5peBA&usqp=CAU', 'AAY@sfu.ca', 'CohortUser', 987987, 202110, 'dcba123'),
(852852, 'Andy', 'D', 'Jun', 'SFU', 'https://www.shareicon.net/data/512x512/2016/07/26/802016_man_512x512.png', 'ADJ@sfu.ca', 'CohortUser', 789789, 202110, 'abcd123');

--
-- Triggers `goauser`
--
DELIMITER $$
CREATE TRIGGER `middleinitial_upper` BEFORE INSERT ON `goauser` FOR EACH ROW BEGIN
   SET NEW.MiddleInitial = UPPER(NEW.MiddleInitial);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lesson`
--

CREATE TABLE `lesson` (
  `LessonID` int(11) NOT NULL,
  `Type` varchar(50) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `weekNumber` int(11) DEFAULT NULL,
  `Title` varchar(50) DEFAULT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `slidesURL` text DEFAULT NULL,
  `CourseID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lesson`
--

INSERT INTO `lesson` (`LessonID`, `Type`, `Description`, `weekNumber`, `Title`, `startDate`, `endDate`, `slidesURL`, `CourseID`) VALUES
(111111, 'design', 'Importance of type choice and how to use it', 1, 'Introduction to Design and Typography', '2020-10-06', '2020-10-13', 'https://drive.google.com/file/d/1BSbW78Aha2U15ryaVIjQjXg3UqPWF0io/view?usp=shg', 123456),
(222222, 'design', 'Examples of typography choice in real application design', 2, 'Typography Tips & Elements of Design', '2020-10-13', '2020-10-20', 'https://drive.google.com/file/d/12gIlt7lb1-Dw-tESMYTOAE1d3t2e_jSo/view?usp=sharin', 123456),
(333333, 'dev', 'Intro to java: functions', 4, 'Functions', '2020-11-03', '2020-11-10', 'https://drive.google.com/file/d/1aGjxpHQeUryd-YCcyXjs9vqJVxaiUjUW/view?usp=sharing', 345678),
(444444, 'dev', 'Java collection data structures: Arrays, ArrayLists, and HashMaps', 5, 'Collections', '2020-11-10', '2020-11-17', 'https://drive.google.com/file/d/1xSoKpDctnN5F20eGeSybouz3I3OZuu-O/view?usp=sharing', 345678),
(555555, 'design', 'First lesson of the design sprint series', 14, 'Design Sprint_Planning and Mapping', '2021-02-09', '2021-02-16', 'https://drive.google.com/file/d/1It-XwEYEQ4yFrIiGjcoz-NkBLqXOeP1h/view?usp=sharing', 567890);

-- --------------------------------------------------------

--
-- Table structure for table `lessonisin`
--

CREATE TABLE `lessonisin` (
  `LessonID` int(11) NOT NULL,
  `CohortID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lessonisin`
--

INSERT INTO `lessonisin` (`LessonID`, `CohortID`) VALUES
(111111, 202110),
(222222, 202110),
(333333, 202110),
(444444, 202110),
(555555, 202110);

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE `question` (
  `ChallengeID` int(11) NOT NULL,
  `QuestionID` int(11) NOT NULL,
  `Answer` varchar(200) DEFAULT NULL,
  `fakeAnswer1` varchar(200) DEFAULT NULL,
  `FakeAnswer2` varchar(200) DEFAULT NULL,
  `FakeAnswer3` varchar(200) DEFAULT NULL,
  `Text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`ChallengeID`, `QuestionID`, `Answer`, `fakeAnswer1`, `FakeAnswer2`, `FakeAnswer3`, `Text`) VALUES
(57913, 295867, 'collection of different\r\nstyles of a typefaces ', 'The size of the text you use', 'The language the text is in', 'The style of your design pattern', 'What is the definition of Font?'),
(57913, 548957, 'You should never combine type faces', 'When you wish to express two different dialogues', 'When you want to express two different emotions', 'When combining two different design styles', 'When should you combine more than two typefaces together?'),
(57913, 586646, 'All of the above', 'To make acronyms', 'To make emphasis', 'To make initials', 'When should you use small letters in Typography?'),
(13579, 898989, 'Hashmaps', 'Arrays', 'ArrayLists', 'To make initials', 'Which java data structure allows you to access values based on a key value?'),
(35791, 968567, 'String dogName = \"Rufus\";', 'dogName = \"Rufus\";', 'String dogName = Rufus', 'String dogName = \"Rufus\"', 'Create a variable that represents the name of your dog “Rufus”'),
(46802, 969696, 'To problem solve and create value', 'To make pretty drawings', 'To create UI/UX', 'To tell developers what to make', 'What is design?'),
(24680, 989898, 'Clan Pro', 'FF DIN\r\n', 'Proxima Nova', 'Gilroy', 'What is Uber’s primary font?');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `ResourceID` int(11) NOT NULL,
  `URL` text DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `LessonID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`ResourceID`, `URL`, `Description`, `LessonID`) VALUES
(1010, 'https://www.youtube.com/watch?v=eIrMbAQSU34', ' Tutorial for Java', 333333),
(2020, 'https://docs.repl.it/tutorials/00-overview', 'Basics of using repl.it', 333333),
(3030, ' https://www.youtube.com/watch?v=Xzk3XLveA00', ' Overview of Data S\r\ntructures', 444444),
(4040, ' https://www.gv.com/sprint/', ' How Design Sprint works', 555555),
(5050, ' https://www.educba.com/user-interface-design-principles/', ' User Design Principles', 111111),
(6060, ' https://creativemarket.com/blog/typography-rules', ' 20 Typography Rules Every Designer Should Know', 222222);

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `TeamID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `TeamVideos` varchar(100) DEFAULT NULL,
  `VotesReceived` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `team`
--

INSERT INTO `team` (`TeamID`, `Name`, `TeamVideos`, `VotesReceived`) VALUES
(789789, 'SandsView', 'https://www.youtube.com/watch?v=4xRkzG-oCcA', 10),
(798798, 'iVolunteer', 'https://www.youtube.com/watch?v=aiGR3uaEMOE', 12),
(879879, 'TBD', 'https://www.youtube.com/watch?v=n82M7Y0Y_1g', 13),
(897897, 'Mission Impossible', 'https://www.youtube.com/watch?v=6Z99e6xjy8A', 15),
(987987, 'RecyclerView', 'https://www.youtube.com/watch?v=y6KZt7FD4cw', 11);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anonymoussuggestions`
--
ALTER TABLE `anonymoussuggestions`
  ADD PRIMARY KEY (`SuggestionID`),
  ADD UNIQUE KEY `SuggestionID` (`SuggestionID`);

--
-- Indexes for table `assignment`
--
ALTER TABLE `assignment`
  ADD PRIMARY KEY (`AssignmentID`),
  ADD UNIQUE KEY `AssignmentID` (`AssignmentID`),
  ADD KEY `LessonID` (`LessonID`);

--
-- Indexes for table `assignmentcompletes`
--
ALTER TABLE `assignmentcompletes`
  ADD PRIMARY KEY (`AssignmentID`,`UserID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `badge`
--
ALTER TABLE `badge`
  ADD PRIMARY KEY (`BadgeID`),
  ADD UNIQUE KEY `BadgeID` (`BadgeID`),
  ADD KEY `CourseID` (`CourseID`);

--
-- Indexes for table `challenge`
--
ALTER TABLE `challenge`
  ADD PRIMARY KEY (`ChallengeID`),
  ADD UNIQUE KEY `ChallengeID` (`ChallengeID`),
  ADD KEY `LessonID` (`LessonID`),
  ADD KEY `BadgeID` (`BadgeID`);

--
-- Indexes for table `challengecompletes`
--
ALTER TABLE `challengecompletes`
  ADD PRIMARY KEY (`ChallengeID`,`UserID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `cohort`
--
ALTER TABLE `cohort`
  ADD PRIMARY KEY (`CohortID`),
  ADD UNIQUE KEY `CohortID` (`CohortID`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`CourseID`),
  ADD UNIQUE KEY `CourseID` (`CourseID`);

--
-- Indexes for table `earned`
--
ALTER TABLE `earned`
  ADD PRIMARY KEY (`UserID`,`BadgeID`),
  ADD KEY `BadgeID` (`BadgeID`);

--
-- Indexes for table `goaevent`
--
ALTER TABLE `goaevent`
  ADD PRIMARY KEY (`EventID`),
  ADD UNIQUE KEY `EventID` (`EventID`),
  ADD KEY `CohortID` (`CohortID`);

--
-- Indexes for table `goauser`
--
ALTER TABLE `goauser`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `UserID` (`UserID`),
  ADD KEY `CohortID` (`CohortID`),
  ADD KEY `TeamID` (`TeamID`);

--
-- Indexes for table `lesson`
--
ALTER TABLE `lesson`
  ADD PRIMARY KEY (`LessonID`),
  ADD UNIQUE KEY `LessonID` (`LessonID`),
  ADD KEY `CourseID` (`CourseID`);

--
-- Indexes for table `lessonisin`
--
ALTER TABLE `lessonisin`
  ADD PRIMARY KEY (`LessonID`,`CohortID`),
  ADD KEY `CohortID` (`CohortID`);

--
-- Indexes for table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`QuestionID`),
  ADD KEY `ChallengeID` (`ChallengeID`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`ResourceID`),
  ADD UNIQUE KEY `ResourceID` (`ResourceID`),
  ADD KEY `LessonID` (`LessonID`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`TeamID`),
  ADD UNIQUE KEY `TeamID` (`TeamID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignment`
--
ALTER TABLE `assignment`
  ADD CONSTRAINT `assignment_ibfk_1` FOREIGN KEY (`LessonID`) REFERENCES `lesson` (`LessonID`);

--
-- Constraints for table `assignmentcompletes`
--
ALTER TABLE `assignmentcompletes`
  ADD CONSTRAINT `assignmentcompletes_ibfk_1` FOREIGN KEY (`AssignmentID`) REFERENCES `assignment` (`AssignmentID`),
  ADD CONSTRAINT `assignmentcompletes_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `goauser` (`UserID`) ON DELETE CASCADE;

--
-- Constraints for table `badge`
--
ALTER TABLE `badge`
  ADD CONSTRAINT `badge_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `course` (`CourseID`);

--
-- Constraints for table `challenge`
--
ALTER TABLE `challenge`
  ADD CONSTRAINT `challenge_ibfk_1` FOREIGN KEY (`LessonID`) REFERENCES `lesson` (`LessonID`),
  ADD CONSTRAINT `challenge_ibfk_2` FOREIGN KEY (`BadgeID`) REFERENCES `badge` (`BadgeID`);

--
-- Constraints for table `challengecompletes`
--
ALTER TABLE `challengecompletes`
  ADD CONSTRAINT `challengecompletes_ibfk_1` FOREIGN KEY (`ChallengeID`) REFERENCES `challenge` (`ChallengeID`),
  ADD CONSTRAINT `challengecompletes_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `goauser` (`UserID`) ON DELETE CASCADE;

--
-- Constraints for table `earned`
--
ALTER TABLE `earned`
  ADD CONSTRAINT `earned_ibfk_1` FOREIGN KEY (`BadgeID`) REFERENCES `badge` (`BadgeID`),
  ADD CONSTRAINT `earned_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `goauser` (`UserID`) ON DELETE CASCADE,
  ADD CONSTRAINT `earned_ibfk_3` FOREIGN KEY (`UserID`) REFERENCES `goauser` (`UserID`) ON DELETE CASCADE,
  ADD CONSTRAINT `earned_ibfk_4` FOREIGN KEY (`BadgeID`) REFERENCES `badge` (`BadgeID`);

--
-- Constraints for table `goaevent`
--
ALTER TABLE `goaevent`
  ADD CONSTRAINT `goaevent_ibfk_1` FOREIGN KEY (`CohortID`) REFERENCES `cohort` (`CohortID`);

--
-- Constraints for table `goauser`
--
ALTER TABLE `goauser`
  ADD CONSTRAINT `goauser_ibfk_1` FOREIGN KEY (`CohortID`) REFERENCES `cohort` (`CohortID`),
  ADD CONSTRAINT `goauser_ibfk_2` FOREIGN KEY (`TeamID`) REFERENCES `team` (`TeamID`);

--
-- Constraints for table `lesson`
--
ALTER TABLE `lesson`
  ADD CONSTRAINT `lesson_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `course` (`CourseID`);

--
-- Constraints for table `lessonisin`
--
ALTER TABLE `lessonisin`
  ADD CONSTRAINT `lessonisin_ibfk_1` FOREIGN KEY (`LessonID`) REFERENCES `lesson` (`LessonID`),
  ADD CONSTRAINT `lessonisin_ibfk_2` FOREIGN KEY (`CohortID`) REFERENCES `cohort` (`CohortID`);

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`ChallengeID`) REFERENCES `challenge` (`ChallengeID`);

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `resources_ibfk_1` FOREIGN KEY (`LessonID`) REFERENCES `lesson` (`LessonID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
