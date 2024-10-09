CREATE DATABASE SPORTS_LEAGUE;

USE SPORTS_LEAGUE;

CREATE TABLE Stadium (
	Stadium_ID INT PRIMARY KEY AUTO_INCREMENT,
	Stadium_Name VARCHAR(60) NOT NULL,
	City VARCHAR(60) NOT NULL,
	Country VARCHAR(60) NOT NULL,
	Capacity INT CHECK (Capacity > 0),
	Pitch_Type VARCHAR(100),
	Average_First_Innings_Score INT CHECK (Average_First_Innings_Score >= 0),
	Total_Matches_Hosted INT DEFAULT 0 CHECK (Total_Matches_Hosted >= 0)
);

CREATE TABLE Coach (
	Coach_ID INT PRIMARY KEY AUTO_INCREMENT,
	First_Name VARCHAR(55) NOT NULL,
	Last_Name VARCHAR(55) NOT NULL,
	Nationality VARCHAR(55),
	Coach_Role ENUM('Head Coach', 'Batting Coach', 'Bowling Coach') NOT NULL,
	Years_Of_Experience INT CHECK (Years_Of_Experience >= 0)
);

CREATE TABLE Team (
	Team_ID INT PRIMARY KEY AUTO_INCREMENT,
    Team_Name VARCHAR(50) NOT NULL,
    City VARCHAR(30) NOT NULL,
    Coach_ID INT,
    Team_Founding_Year DATE,
    Total_Titles_Won INT DEFAULT 0 CHECK (Total_Titles_Won >= 0),
    Team_Logo BLOB, -- Consider moving this to a file server for better performance
    Team_Dress_Colour VARCHAR(20),
    Team_Website_Link VARCHAR(50),
    Team_Net_Worth DECIMAL(15, 2) CHECK (Team_Net_Worth >= 0),
    Home_Stadium_ID INT,
    FOREIGN KEY (Coach_ID) REFERENCES Coach (Coach_ID) ON UPDATE CASCADE,
    FOREIGN KEY (Home_Stadium_ID) REFERENCES Stadium (Stadium_ID) ON UPDATE CASCADE
);

CREATE TABLE Player (
	Player_ID INT PRIMARY KEY AUTO_INCREMENT,
	First_Name VARCHAR(50) NOT NULL,
	Last_Name VARCHAR(50) NOT NULL,
	Date_Of_Birth DATE , 
	Nationality VARCHAR(55),
	Role ENUM('Batsman', 'Bowler', 'All-rounder', 'Wicketkeeper') NOT NULL, -- ENUM for consistency
	Batting_Style ENUM('Right_handed', 'Left_handed') NOT NULL,
	Bowling_Style ENUM('Right_arm Fast', 'Left_arm Fast', 'Left_arm Spin', 'Right_arm Spin') NULL,
	Total_Runs_Scored INT DEFAULT 0 CHECK (Total_Runs_Scored >= 0),
	Total_Wickets_Taken INT DEFAULT 0 CHECK (Total_Wickets_Taken >= 0),
	Total_Catches_Taken INT DEFAULT 0 CHECK (Total_Catches_Taken >= 0),
	Total_Matches_Played INT DEFAULT 0 CHECK (Total_Matches_Played >= 0),
	Total_Half_Centuries INT DEFAULT 0 CHECK (Total_Half_Centuries >= 0),
	Total_Centuries INT DEFAULT 0 CHECK (Total_Centuries >= 0),
	Base_Price INT CHECK (Base_Price >= 0),
	Current_Team_ID INT,
	IPL_Debut_Year DATE CHECK (IPL_Debut_Year >= '2008-01-01'), -- IPL started in 2008
	International_Career_Start DATE,
	Total_IPL_Trophies_Won INT DEFAULT 0 CHECK (Total_IPL_Trophies_Won >= 0),
	FOREIGN KEY (Current_Team_ID) REFERENCES Team (Team_ID) ON UPDATE CASCADE
);

CREATE TABLE Umpire (
	Umpire_ID INT PRIMARY KEY AUTO_INCREMENT,
	First_Name VARCHAR(20) NOT NULL,
	Last_Name VARCHAR(20) NOT NULL,
	Nationality VARCHAR(20),
	Total_Matches INT DEFAULT 0 CHECK (Total_Matches >= 0),
	Date_Of_Birth DATE ,
	Umpire_Rating INT CHECK (Umpire_Rating BETWEEN 0 AND 10)
);

CREATE TABLE Sponsorship (
	Sponsorship_ID INT PRIMARY KEY AUTO_INCREMENT,
	Team_ID INT,
	Sponsor_Name VARCHAR(200) NOT NULL,
	Sponsorship_Type VARCHAR(200) NOT NULL,
	Contract_Start_Year DATE,
	Contract_End_Year DATE,
	Sponsorship_Amount DECIMAL(15, 2) CHECK (Sponsorship_Amount >= 0),
	FOREIGN KEY (Team_ID) REFERENCES Team (Team_ID)
);

CREATE TABLE Contract (
	Contract_ID INT PRIMARY KEY AUTO_INCREMENT,
	Player_ID INT,
	Contract_Start_Year DATE NOT NULL,
	Contract_End_Year DATE NOT NULL,
	Amount DECIMAL(15, 2) CHECK (Amount >= 0),
	Team_ID INT,
	FOREIGN KEY (Player_ID) REFERENCES Player (Player_ID),
	FOREIGN KEY (Team_ID) REFERENCES Team (Team_ID)
);

CREATE TABLE Season (
	Season_ID INT PRIMARY KEY AUTO_INCREMENT,
	Year YEAR CHECK (Year >= 2008), -- IPL started in 2008
	Total_Matches_Played INT DEFAULT 0 CHECK (Total_Matches_Played >= 0),
	Winning_Team_ID INT,
	Runner_Team_ID INT,
	Orange_Cap_Winner_ID INT,
	Purple_Cap_Winner_ID INT,
	FOREIGN KEY (Winning_Team_ID) REFERENCES Team (Team_ID),
	FOREIGN KEY (Runner_Team_ID) REFERENCES Team (Team_ID),
	FOREIGN KEY (Orange_Cap_Winner_ID) REFERENCES Player (Player_ID),
	FOREIGN KEY (Purple_Cap_Winner_ID) REFERENCES Player (Player_ID)
);

CREATE TABLE Matches (
	Match_ID INT AUTO_INCREMENT PRIMARY KEY,
	Season_ID INT,
	Team1_ID INT,
	Team2_ID INT,
	Match_Date DATETIME CHECK (Match_Date >= '2008-01-01'), -- IPL started in 2008
	Umpire1_ID INT,
	Umpire2_ID INT,
	Match_Result VARCHAR(200),
	Team1_Score INT DEFAULT 0 CHECK (Team1_Score >= 0),
	Team2_Score INT DEFAULT 0 CHECK (Team2_Score >= 0),
	Winning_Margin VARCHAR(255),
	Total_Overs_Bowled INT CHECK (Total_Overs_Bowled BETWEEN 0 AND 40),
	Match_Type ENUM('League', 'Qualifier', 'Eliminator', 'Final') NOT NULL,
	Stadium_ID INT,
	FOREIGN KEY (Season_ID) REFERENCES Season (Season_ID) ON DELETE CASCADE,
	FOREIGN KEY (Team1_ID) REFERENCES Team (Team_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Team2_ID) REFERENCES Team (Team_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Umpire1_ID) REFERENCES Umpire (Umpire_ID) ON UPDATE CASCADE,
	FOREIGN KEY (Umpire2_ID) REFERENCES Umpire (Umpire_ID) ON UPDATE CASCADE,
	FOREIGN KEY (Stadium_ID) REFERENCES Stadium (Stadium_ID) ON UPDATE CASCADE
);

CREATE TABLE Inning (
	Innings_ID INT PRIMARY KEY AUTO_INCREMENT,
	Match_ID INT,
	Team_Batting_ID INT,
	Total_Runs INT DEFAULT 0 CHECK (Total_Runs >= 0),
	Total_Wickets INT DEFAULT 0 CHECK (Total_Wickets BETWEEN 0 AND 10),
	Overs_Faced DECIMAL(4,2) CHECK (Overs_Faced >= 0 AND Overs_Faced <= 20),
	Inning_Number ENUM('1st Inning', '2nd Inning') NOT NULL,
	FOREIGN KEY (Match_ID) REFERENCES Matches (Match_ID),
	FOREIGN KEY (Team_Batting_ID) REFERENCES Team (Team_ID)
);

CREATE TABLE Statistics (
	Stat_ID INT PRIMARY KEY AUTO_INCREMENT,
	Player_ID INT,
	Season_ID INT,
	Matches_Played INT DEFAULT 0 CHECK (Matches_Played >= 0),
	Runs_Scored INT DEFAULT 0 CHECK (Runs_Scored >= 0),
	Wickets_Taken INT DEFAULT 0 CHECK (Wickets_Taken >= 0),
	Catches_Taken INT DEFAULT 0 CHECK (Catches_Taken >= 0),
	Fours INT DEFAULT 0 CHECK (Fours >= 0),
	Sixes INT DEFAULT 0 CHECK (Sixes >= 0),
	Strike_Rate DECIMAL(5, 2) DEFAULT 0 CHECK (Strike_Rate >= 0),
	Economy_Rate DECIMAL(3,1) DEFAULT 0 CHECK (Economy_Rate >= 0),
	Bowling_Average DECIMAL(5, 2) DEFAULT 0 CHECK (Bowling_Average >= 0),
	Batting_Average DECIMAL(5, 2) DEFAULT 0 CHECK (Batting_Average >= 0),
	FOREIGN KEY (Player_ID) REFERENCES Player (Player_ID),
	FOREIGN KEY (Season_ID) REFERENCES Season (Season_ID)
);

CREATE TABLE Ball (
	Ball_ID INT PRIMARY KEY AUTO_INCREMENT,
	Inning_ID INT,
	Bowler_ID INT,
	Batsman_ID INT,
	Non_striker_ID INT,
	Run_Scored INT DEFAULT 0 CHECK (Run_Scored >= 0),
	Is_Wicket BOOLEAN DEFAULT FALSE,
	Is_NoBall BOOLEAN DEFAULT FALSE,
	Is_Wide BOOLEAN DEFAULT FALSE,
	Is_LegBye BOOLEAN DEFAULT FALSE,
    Ball_Over INT CHECK (Ball_Over BETWEEN 1 AND 20),
	Ball_Number INT CHECK (Ball_Number BETWEEN 1 AND 6), -- Each over has 6 balls max
	FOREIGN KEY (Inning_ID) REFERENCES Inning (Innings_ID),
	FOREIGN KEY (Bowler_ID) REFERENCES Player (Player_ID),
	FOREIGN KEY (Batsman_ID) REFERENCES Player (Player_ID),
	FOREIGN KEY (Non_striker_ID) REFERENCES Player (Player_ID)
);

CREATE TABLE TeamCaptain (
	TeamCaptain_ID INT PRIMARY KEY AUTO_INCREMENT,
	Team_ID INT,
	Player_ID INT,
	Start_Date DATE,
	End_Date DATE,
	FOREIGN KEY (Team_ID) REFERENCES Team (Team_ID),
	FOREIGN KEY (Player_ID) REFERENCES Player (Player_ID)
);

INSERT INTO Stadium (Stadium_Name, City, Country, Capacity, Pitch_Type, Average_First_Innings_Score, Total_Matches_Hosted)
VALUES 
('Wankhede Stadium', 'Mumbai', 'India', 33108, 'Flat pitch', 165, 250),
('Eden Gardens', 'Kolkata', 'India', 68000, 'Balanced pitch', 160, 300),
('M. Chinnaswamy Stadium', 'Bangalore', 'India', 40000, 'Batting friendly', 175, 200),
('Narendra Modi Stadium', 'Ahmedabad', 'India', 132000, 'Pace-friendly', 170, 150),
('Arun Jaitley Stadium', 'Delhi', 'India', 41820, 'Balanced pitch', 155, 190);

INSERT INTO Coach (First_Name, Last_Name, Nationality, Coach_Role, Years_Of_Experience)
VALUES 
('Ricky', 'Ponting', 'Australia', 'Head Coach', 15),
('Mahela', 'Jayawardene', 'Sri Lanka', 'Batting Coach', 10),
('Shane', 'Bond', 'New Zealand', 'Bowling Coach', 8),
('Rahul', 'Dravid', 'India', 'Head Coach', 12),
('Lasith', 'Malinga', 'Sri Lanka', 'Bowling Coach', 7);

INSERT INTO Team (Team_Name, City, Coach_ID, Team_Founding_Year, Total_Titles_Won, Team_Dress_Colour, Team_Website_Link, Team_Net_Worth, Home_Stadium_ID)
VALUES 
('Mumbai Indians', 'Mumbai', 1, '2008-01-01', 5, 'Blue', 'https://www.mumbaiindians.com', 800000000.00, 1),
('Chennai Super Kings', 'Chennai', 4, '2008-01-01', 4, 'Yellow', 'https://www.chennaisuperkings.com', 750000000.00, 2),
('Royal Challengers Bangalore', 'Bangalore', 2, '2008-01-01', 0, 'Red', 'https://www.royalchallengers.com', 700000000.00, 3),
('Delhi Capitals', 'Delhi', 1, '2008-01-01', 0, 'Blue', 'https://www.delhicapitals.com', 600000000.00, 5),
('Gujarat Titans', 'Ahmedabad', 5, '2021-01-01', 1, 'Navy Blue', 'https://www.gujarattitansipl.com', 650000000.00, 4);

INSERT INTO Player (First_Name, Last_Name, Date_Of_Birth, Nationality, Role, Batting_Style, Bowling_Style, Total_Runs_Scored, Total_Wickets_Taken, Total_Catches_Taken, Total_Matches_Played, Total_Half_Centuries, Total_Centuries, Base_Price, Current_Team_ID, IPL_Debut_Year, International_Career_Start, Total_IPL_Trophies_Won)
VALUES 
('Virat', 'Kohli', '1988-11-05', 'India', 'Batsman', 'Right_handed', NULL, 7000, 0, 100, 230, 40, 7, 17000000, 3, '2008-01-01', '2008-08-18', 0),
('Rohit', 'Sharma', '1987-04-30', 'India', 'Batsman', 'Right_handed', NULL, 6200, 0, 80, 210, 35, 6, 15000000, 1, '2008-01-01', '2007-06-23', 5),
('MS', 'Dhoni', '1981-07-07', 'India', 'Wicketkeeper', 'Right_handed', NULL, 5000, 0, 150, 220, 25, 3, 12000000, 2, '2008-01-01', '2004-12-23', 4),
('Jasprit', 'Bumrah', '1993-12-06', 'India', 'Bowler', 'Right_handed', 'Right_arm Fast', 100, 180, 50, 90, 0, 0, 10000000, 1, '2013-01-01', '2016-01-23', 3),
('Hardik', 'Pandya', '1993-10-11', 'India', 'All-rounder', 'Right_handed', 'Right_arm Fast', 2500, 75, 40, 110, 10, 1, 12000000, 5, '2015-01-01', '2016-01-26', 1);



INSERT INTO Umpire (First_Name, Last_Name, Nationality, Total_Matches, Date_Of_Birth, Umpire_Rating)
VALUES 
('Nitin', 'Menon', 'India', 75, '1983-11-12', 9),
('Aleem', 'Dar', 'Pakistan', 85, '1968-06-06', 10),
('Kumar', 'Dharmasena', 'Sri Lanka', 70, '1971-04-24', 8),
('Sundaram', 'Ravi', 'India', 60, '1966-04-22', 7),
('Chris', 'Gaffaney', 'New Zealand', 50, '1975-11-30', 8);

INSERT INTO Sponsorship (Team_ID, Sponsor_Name, Sponsorship_Type, Contract_Start_Year, Contract_End_Year, Sponsorship_Amount)
VALUES 
(1, 'Samsung', 'Jersey', '2020-01-01', '2024-01-01', 50000000.00),
(2, 'Aircel', 'Jersey', '2018-01-01', '2023-01-01', 30000000.00),
(3, 'Myntra', 'Jersey', '2019-01-01', '2024-01-01', 35000000.00),
(4, 'JSW Group', 'Jersey', '2019-01-01', '2024-01-01', 25000000.00),
(5, 'CRED', 'Jersey', '2022-01-01', '2026-01-01', 40000000.00);

INSERT INTO Contract (Player_ID, Contract_Start_Year, Contract_End_Year, Amount, Team_ID)
VALUES 
(1, '2020-01-01', '2025-01-01', 17000000.00, 3),
(2, '2019-01-01', '2024-01-01', 15000000.00, 1),
(3, '2018-01-01', '2023-01-01', 12000000.00, 2),
(4, '2021-01-01', '2025-01-01', 10000000.00, 1),
(5, '2021-01-01', '2026-01-01', 12000000.00, 5);

INSERT INTO Contract (Player_ID, Contract_Start_Year, Contract_End_Year, Amount, Team_ID)
VALUES 
(3, '2016-01-01', '2018-01-01', 10000000.00, 5);

INSERT INTO Season (Year, Total_Matches_Played, Winning_Team_ID, Runner_Team_ID, Orange_Cap_Winner_ID, Purple_Cap_Winner_ID)
VALUES 
(2023, 74, 5, 1, 1, 4),
(2022, 74, 2, 3, 2, 4),
(2021, 60, 2, 1, 3, 5),
(2020, 60, 1, 2, 1, 5),
(2019, 60, 1, 3, 2, 4);

INSERT INTO Matches (Season_ID, Team1_ID, Team2_ID, Match_Date, Umpire1_ID, Umpire2_ID, Match_Result, Team1_Score, Team2_Score, Winning_Margin, Total_Overs_Bowled, Match_Type, Stadium_ID)
VALUES 
(1, 1, 2, '2023-05-29 20:00:00', 1, 2, 'Mumbai Indians won by 5 wickets', 160, 155, '5 wickets', 40, 'Final', 1),
(2, 2, 3, '2022-05-30 19:30:00', 3, 4, 'Chennai Super Kings won by 7 runs', 170, 163, '7 runs', 40, 'Final', 2),
(3, 1, 5, '2021-05-29 20:00:00', 1, 3, 'Delhi Capitals won by 10 wickets', 140, 139, '10 wickets', 40, 'Qualifier', 5),
(4, 4, 2, '2020-05-29 20:00:00', 4, 2, 'Gujarat Titans won by 6 wickets', 180, 179, '6 wickets', 40, 'Eliminator', 4),
(5, 3, 1, '2019-05-29 20:00:00', 1, 4, 'Mumbai Indians won by 1 run', 160, 159, '1 run', 40, 'Final', 1);

INSERT INTO Inning (Match_ID, Team_Batting_ID, Total_Runs, Total_Wickets, Overs_Faced, Inning_Number)
VALUES 
(1, 2, 155, 7, 20.0, '1st Inning'),
(1, 1, 160, 5, 19.3, '2nd Inning'),
(2, 2, 170, 8, 20.0, '1st Inning'),
(2, 3, 163, 9, 20.0, '2nd Inning'),
(3, 1, 140, 10, 19.5, '1st Inning'),
(3, 5, 141, 0, 14.0, '2nd Inning');

INSERT INTO Statistics (Player_ID, Season_ID, Matches_Played, Runs_Scored, Wickets_Taken, Catches_Taken, Fours, Sixes, Strike_Rate, Economy_Rate, Bowling_Average, Batting_Average)
VALUES 
(1, 1, 14, 550, 0, 15, 60, 25, 140.50, NULL, NULL, 45.83),
(2, 1, 13, 600, 0, 12, 65, 30, 135.20, NULL, NULL, 50.00),
(3, 1, 14, 400, 0, 18, 45, 15, 125.40, NULL, NULL, 35.50),
(4, 1, 12, 120, 20, 8, 10, 5, NULL, 6.80, 18.50, NULL),
(5, 1, 15, 300, 10, 7, 25, 10, 140.00, 7.50, 20.00, 30.00);

INSERT INTO Ball (Inning_ID, Bowler_ID, Batsman_ID, Non_striker_ID, Run_Scored, Is_Wicket, Is_NoBall, Is_Wide, Is_LegBye, Ball_Over,Ball_Number)
VALUES 
(1, 4, 1, 3, 1, FALSE, FALSE, FALSE, FALSE,1, 1),
(1, 4, 2, 3, 0, TRUE, FALSE, FALSE, FALSE, 1, 2),
(2, 5, 3, 2, 6, FALSE, FALSE, FALSE, FALSE, 2, 1),
(2, 5, 1, 4, 1, FALSE, FALSE, FALSE, FALSE, 5, 2),
(2, 4, 3, 2, 0, TRUE, FALSE, FALSE, FALSE, 20, 3);

INSERT INTO TeamCaptain (Team_ID, Player_ID, Start_Date, End_Date)
VALUES 
(1, 2, '2013-01-01', NULL),
(2, 3, '2008-01-01', NULL),
(3, 1, '2013-01-01', NULL),
(5, 5, '2021-01-01', NULL),
(4, 1, '2020-01-01', NULL);


INSERT INTO Player (
    First_Name, Last_Name, Date_Of_Birth, Nationality, Role, Batting_Style, Bowling_Style, 
    Total_Runs_Scored, Total_Wickets_Taken, Total_Catches_Taken, Total_Matches_Played, 
    Total_Half_Centuries, Total_Centuries, Base_Price, Current_Team_ID, IPL_Debut_Year, 
    International_Career_Start, Total_IPL_Trophies_Won) 
VALUES
('Faf', 'du Plessis', '1984-07-13', 'South African', 'Batsman', 'Right_handed', NULL, 3768, 0, 85, 127, 25, 0, 7000000, 3, '2011-04-18', '2011-01-18', 0),
('Glenn', 'Maxwell', '1988-10-14', 'Australian', 'All-rounder', 'Right_handed', 'Right_arm Spin', 2495, 39, 55, 120, 12, 0, 11000000, 3, '2012-04-18', '2012-08-18', 0),
('Mohammed', 'Siraj', '1994-03-13', 'Indian', 'Bowler', 'Right_handed', 'Right_arm Fast', 29, 70, 20, 76, 0, 0, 5000000, 3, '2017-04-18', '2020-01-15', 0),
('Harshal', 'Patel', '1990-11-23', 'Indian', 'Bowler', 'Right_handed', 'Right_arm Fast', 79, 97, 28, 94, 0, 0, 10000000, 3, '2012-05-11', '2021-09-18', 0),
('Wanindu', 'Hasaranga', '1997-07-29', 'Sri Lankan', 'All-rounder', 'Right_handed', 'Right_arm Spin', 153, 26, 5, 14, 0, 0, 10750000, 3, '2021-08-20', '2021-01-15', 0),
('Dinesh', 'Karthik', '1985-06-01', 'Indian', 'Wicketkeeper', 'Right_handed', NULL, 4376, 0, 95, 229, 20, 0, 5500000, 3, '2008-04-18', '2004-09-04', 0),
('Josh', 'Hazlewood', '1991-01-08', 'Australian', 'Bowler', 'Left_handed', 'Right_arm Fast', 27, 38, 5, 27, 0, 0, 7500000, 3, '2021-04-18', '2013-06-11', 0),
('Shahbaz', 'Ahmed', '1994-12-12', 'Indian', 'All-rounder', 'Left_handed', 'Left_arm Spin', 210, 13, 15, 31, 0, 0, 2400000, 3, '2020-10-12', '2020-01-10', 0),
('David', 'Willey', '1990-02-28', 'English', 'All-rounder', 'Left_handed', 'Left_arm Fast', 155, 13, 12, 6, 0, 0, 2000000, 3, '2022-04-18', '2015-05-11', 0),
('Anuj', 'Rawat', '1999-10-17', 'Indian', 'Wicketkeeper', 'Left_handed', NULL,359, 0, 7, 21, 0, 0, 3400000, 3, '2022-04-18', '2022-01-10', 0);







-- Queries

-- Get Player Details by Name
SELECT 
    Player_ID, 
    CONCAT(First_Name, ' ', Last_Name) AS Full_Name, 
    Nationality, 
    Role, 
    Batting_Style, 
    Bowling_Style, 
    Total_Runs_Scored, 
    Total_Wickets_Taken, 
    Total_Catches_Taken, 
    Total_Matches_Played, 
    Total_Half_Centuries, 
    Total_Centuries 
FROM Player
WHERE First_Name = 'Virat' AND Last_Name = 'Kohli';

-- Get the Total Titles Won by Each Team
SELECT 
    Team_Name, 
    Total_Titles_Won 
FROM Team
ORDER BY Total_Titles_Won DESC;

-- Get All Players in a Particular Team
SELECT 
    P.Player_ID, 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Player_Name, 
    P.Role, 
    P.Batting_Style, 
    P.Bowling_Style 
FROM Player P
JOIN Team T ON P.Current_Team_ID = T.Team_ID
WHERE T.Team_name = 'Royal Challengers Bangalore';

-- Get the Coach and Home Stadium of a Team
SELECT 
    T.Team_Name, 
    CONCAT(C.First_Name, ' ', C.Last_Name) AS Coach_Name, 
    S.Stadium_Name AS Home_Stadium, 
    S.City AS Stadium_City, 
    S.Capacity AS Stadium_Capacity 
FROM Team T
JOIN Coach C ON T.Coach_ID = C.Coach_ID
JOIN Stadium S ON T.Home_Stadium_ID = S.Stadium_ID;
-- WHERE T.Team_Name = 'Mumbai Indians';

-- Get Match Details of a Particular Season
SELECT 
    M.Match_ID, 
    T1.Team_Name AS Team_1, 
    T2.Team_Name AS Team_2, 
    M.Match_Date, 
    M.Match_Result, 
    M.Team1_Score, 
    M.Team2_Score 
FROM Matches M
JOIN Team T1 ON M.Team1_ID = T1.Team_ID
JOIN Team T2 ON M.Team2_ID = T2.Team_ID
JOIN Season S ON M.Season_ID = S.Season_ID
WHERE S.Year = 2023;

-- Get the List of Captains for Each Team Over Time
SELECT 
    T.Team_Name, 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Captain_Name, 
    TC.Start_Date, 
    TC.End_Date 
FROM TeamCaptain TC
JOIN Team T ON TC.Team_ID = T.Team_ID
JOIN Player P ON TC.Player_ID = P.Player_ID
ORDER BY TC.Start_Date;

-- List Umpires and Their Ratings
SELECT 
    U.Umpire_ID, 
    CONCAT(U.First_Name, ' ', U.Last_Name) AS Umpire_Name, 
    U.Nationality, 
    U.Umpire_Rating 
FROM Umpire U
ORDER BY U.Umpire_Rating DESC;

-- Get Winning and Runner-up Teams for Each Season
SELECT 
    Se.Year, 
    T1.Team_Name AS Winning_Team, 
    T2.Team_Name AS Runner_Up_Team 
FROM Season Se
JOIN Team T1 ON Se.Winning_Team_ID = T1.Team_ID
JOIN Team T2 ON Se.Runner_Team_ID = T2.Team_ID;

-- Get Total Matches Played by Each Team in a Season
SELECT 
    T.Team_Name, 
    COUNT(M.Match_ID) AS Matches_Played 
FROM Matches M
JOIN Team T ON (M.Team1_ID = T.Team_ID OR M.Team2_ID = T.Team_ID)
JOIN Season S ON M.Season_ID = S.Season_ID
WHERE S.Year = 2022
GROUP BY T.Team_Name;

-- Getting orange cap winner of each season
SELECT
	S.Year,
	CONCAT(P.First_Name, ' ', P.Last_Name) AS Full_Name
FROM Season S
JOIN PLAYER P ON P.Player_ID = S.Orange_Cap_Winner_ID;    

-- Getting purple cap winner of each season
SELECT
	S.Year,
	CONCAT(P.First_Name, ' ', P.Last_Name) AS Full_Name
FROM Season S
JOIN PLAYER P ON P.Player_ID = S.Purple_Cap_Winner_ID;

-- Getting detail of each Ball of a Match
SELECT 
	CONCAT(Ba.Ball_over, '.', Ba.Ball_Number) AS BALL,
    CONCAT(P1.First_Name, ' ', P1.Last_Name) AS Bowler,
    CONCAT(P2.First_Name, ' ', P2.Last_Name) AS Batsman,
    Ba.Run_Scored, 
    Ba.Is_Wicket, 
    Ba.Is_NoBall, 
    Ba.Is_Wide, 
    Ba.Is_LegBye
FROM BALL Ba
JOIN PLAYER P1 ON P1.Player_ID = Ba.Bowler_ID
JOIN PLAYER P2 ON P2.Player_ID = Ba.Batsman_ID
JOIN Inning I ON I.Innings_ID = Ba.Inning_ID
JOIN Matches M ON M.Match_ID = I.Match_ID
WHERE I.Innings_ID = 1 AND M.Match_ID = 1;  

-- get the total runs scored by each team across all matches
SELECT T.Team_Name, SUM(Total_Runs) AS Total_Runs
FROM Team T
JOIN Inning I on I.Team_Batting_ID = T.Team_ID
GROUP BY I.Team_Batting_ID;

-- Count how many matches each umpire has officiated
SELECT Umpire1_ID, COUNT(Match_ID) AS Matches_Officiated
FROM Matches
GROUP BY Umpire1_ID;

-- Total wickets taken by each player across all seasons
SELECT 
	CONCAT(P.First_Name, ' ', P.Last_Name) AS Full_Name,
    SUM(Wickets_Taken) AS Total_Wickets
FROM Statistics S
JOIN PLAYER P ON P.Player_ID = S.Player_ID
GROUP BY S.Player_ID;

-- Find the number of matches each team has played in a season
SELECT Season_ID, Team1_ID, COUNT(Match_ID) AS Matches_Played
FROM Matches
GROUP BY Season_ID, Team1_ID;

-- the average runs scored by each player across all seasons
SELECT 
	CONCAT(P.First_Name, ' ', P.Last_Name) AS Full_Name,
    AVG(Runs_Scored) AS Average_Runs
FROM Statistics S 
JOIN PLAYER P ON P.Player_ID = S.Player_ID
GROUP BY S.Player_ID;

-- Get batting average of all player
SELECT 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Full_Name,
    S.Batting_Average
FROM Statistics S    
JOIN PLAYER P ON P.Player_ID = S.Player_ID; 

-- Total matches hosted by each stadium
SELECT S.Stadium_Name, COUNT(Match_ID) AS Total_Matches
FROM Matches M 
JOIN Stadium S ON S.Stadium_ID = M.Stadium_ID
GROUP BY M.Stadium_ID;
   
-- Get the player with the highest strike rate in a particular season
SELECT Player_ID, Strike_Rate
FROM Statistics
WHERE Season_ID = 1
ORDER BY Strike_Rate DESC
LIMIT 1;

-- GET the teams that have won the IPL seasons with number of seasons won
SELECT Winning_Team_ID, COUNT(Season_ID) AS Championships_Won
FROM Season
WHERE Winning_Team_ID IS NOT NULL
GROUP BY Winning_Team_ID
ORDER BY Championships_Won DESC;

-- Get Players who have scored more than 200 runs and taken more than 10 wickets in their career
SELECT 
	Player_ID, 
    CONCAT(First_Name, ' ', Last_Name) AS Player_Name,
    Total_Runs_Scored, 
    Total_Wickets_Taken
FROM Player
WHERE Total_Runs_Scored > 200 AND Total_Wickets_Taken > 10;

-- Get List the top 3 stadiums with the highest average first innings scores
SELECT Stadium_Name, City, Average_First_Innings_Score
FROM Stadium
ORDER BY Average_First_Innings_Score DESC
LIMIT 3;

-- Get player that have won max. number of Orange Caps
SELECT CONCAT(P.First_Name, ' ', P.Last_Name) AS Player_Name, COUNT(Season_ID) AS Orange_Caps_Won
FROM Season S
JOIN PLAYER P ON P.Player_ID = S.Orange_Cap_Winner_ID
GROUP BY Orange_Cap_Winner_ID
ORDER BY Orange_Caps_Won DESC
LIMIT 1;

-- Find the coach with the highest number of titles won by their team
SELECT Coach.Coach_ID, Coach.First_Name, Coach.Last_Name, COUNT(Team.Team_ID) AS Titles_Won
FROM Coach
JOIN Team ON Coach.Coach_ID = Team.Coach_ID
JOIN Season ON Team.Team_ID = Season.Winning_Team_ID
GROUP BY Coach.Coach_ID
ORDER BY Titles_Won DESC
LIMIT 1;

-- Get all players who have played for more than one team
SELECT 
	CONCAT(P.First_Name, ' ', P.Last_Name) AS Player_Name, 
	COUNT(DISTINCT C.Team_ID) AS Total_Teams_Played_For
FROM Contract C
JOIN PLAYER P ON P.Player_ID = C.Player_ID
GROUP BY C.Player_ID
HAVING Total_Teams_Played_For > 1;

-- Get the List of the players who have never been part of a winning team   
SELECT P.Player_ID, P.First_Name, P.Last_Name
FROM Player P
LEFT JOIN Season S ON P.Current_Team_ID = S.Winning_Team_ID
WHERE S.Winning_Team_ID IS NULL;





















