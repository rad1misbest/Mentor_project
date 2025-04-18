-- Creating database
-- Creating table
DROP TABLE IF EXISTS user_submissions

CREATE TABLE user_submissions(
	id SERIAL PRIMARY KEY,
	user_id BIGINT,
	question_id INT,
	submitted_at TIMESTAMP WITH TIME ZONE,
	username VARCHAR(50),
	points INT
);

--Q1. List All Distinct Users and Their Stats

SELECT  username,COUNT(id) AS Total_submission, SUM(points) AS points_earned FROM user_submissions
GROUP BY username
ORDER BY 3 DESC;
--Q2. Calculate the Daily Average Points for Each User

SELECT username, AVG(points) AS total_points FROM

(SELECT 
  username,
  submitted_at,
  points,
  EXTRACT(DAY FROM submitted_at) AS day
FROM 
  user_submissions
  ) AS T1
 GROUP BY username,points
 ORDER BY 2  DESC
 --Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
WITH daily_submissions
AS
 (SELECT username,
 TO_CHAR(submitted_at,'DD-MM') AS daily,
 SUM(CASE 
 WHEN points > 0 THEN 1 ELSE 0
 END ) as correct_answer
 FROM user_submissions
 GROUP BY 1,2
),
users_rank
as
 (SELECT daily,username, correct_answer,
 DENSE_RANK() OVER(PARTITION BY daily ORDER BY correct_answer DESC) AS rank
 FROM daily_submissions
)
SELECT daily, username, correct_answer FROM users_rank
WHERE rank <= 3;
 
 --Q4. Which Users Earned the Most Points from Correct Answers?
 
 SELECT username,
 SUM(CASE 
 WHEN points > 0 THEN 1 ELSE 0
 END ) as correct_answer,
 SUM(CASE 
 WHEN points < 0 THEN 1 ELSE 0
 END ) as wrong_answer,
 SUM(points) AS total_points,
 SUM(CASE 
 WHEN points > 0 THEN points ELSE 0
 END ) as correct_answer_points_earned
 FROM user_submissions
 GROUP BY 1
 ORDER BY 2 DESC
 ;

--Q5. Find the Top 10 Performers for Each Week
SELECT * 
FROM
( SELECT 
EXTRACT(WEEK FROM submitted_at) as week_number,
username,
 SUM(points) AS total_points_earned,
 DENSE_RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) AS rank
 FROM user_submissions
 GROUP BY 1,2
 )
 WHERE rank <= 10












 

  