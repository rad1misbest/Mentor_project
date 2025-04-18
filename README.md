# 📊 Mentor Project — SQL Data Analysis

## 📌 Project Overview

**Project Title**: SQL Mentor_project  

This project analyses right and wrong answers from users on the discord. Users tried to write sql queries and when they answered correctly they got plus points. If they got it wrong, they got negative points.

---

## 🗂️ Project Structure

### 1. Database Setup

- **Table Creation**: The project starts with a `user_submissions` table to store the quiz submission data. The table includes:
  - `id`
  - `user_id`
  - `question_id`
  - `submitted_at` (timestamp)
  - `username`
  - `points`

---

### TASKS

---

### 1. List All Distinct Users and Their Stats

```sql
SELECT  username,COUNT(id) AS Total_submission, SUM(points) AS points_earned FROM user_submissions
GROUP BY username
ORDER BY 3 DESC;
```

### 2. Calculate the Daily Average Points for Each User


```sql
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
```


### 3. Find the Top 3 Users with the Most Correct Submissions for Each Day


```sql
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
```


### 4. Which Users Earned the Most Points from Correct Answers?


```sql
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
```

### 5. Find the Top 10 Performers for Each Week


```sql
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
 ;
```

## SQL Concepts Used 
- Aggregation (SUM(), COUNT(), AVG()) 
- Date/time functions (EXTRACT(), TO_CHAR())
- CTEs (Common Table Expressions) 
- Conditional expressions (CASE WHEN)
- Window functions (ROW_NUMBER()) 
##

 ## How to Use 
 1. Run the SQL script Mentor_Project.sql in your PostgreSQL environment.
 2.  Explore or extend the queries to fit your analysis needs. 
 ---


















