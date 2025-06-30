create database project_2;
use project_2;
CREATE TABLE movies (
  movie_id INT PRIMARY KEY,
  movie_title VARCHAR(100),
  genre VARCHAR(50),
  release_year INT
);
CREATE TABLE streaming_data (
  stream_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  movie_id INT,
  subscription_date DATE,
  watch_date DATE,
  watch_time TIME,
  watch_duration INT, -- in minutes
  rating DECIMAL(3,1) -- optional rating out of 10
);

INSERT INTO movies (movie_id, movie_title, genre, release_year) VALUES
(1, 'Inception', 'Sci-Fi', 2010),
(2, 'The Office', 'Comedy', 2005),
(3, 'Breaking Bad', 'Drama', 2008),
(4, 'Stranger Things', 'Sci-Fi', 2016),
(5, 'Friends', 'Comedy', 1994),
(6, 'Parasite', 'Thriller', 2019),
(7, 'The Crown', 'Historical', 2016),
(8, 'Money Heist', 'Action', 2017),
(9, 'Dark', 'Sci-Fi', 2017),
(10, 'The Witcher', 'Fantasy', 2020),
(11, 'Oppenheimer', 'Historical', 2024);

INSERT INTO streaming_data (user_id, movie_id, subscription_date, watch_date, watch_time, watch_duration, rating) VALUES
(101, 1, '2024-01-05', '2024-01-06', '20:30:00', 120, 9.0),
(102, 2, '2024-01-10', '2024-01-11', '21:00:00', 90, 8.5),
(103, 3, '2024-01-15', '2024-01-15', '19:00:00', 60, 9.2),
(101, 4, '2024-01-05', '2024-02-05', '22:00:00', 80, 8.7),
(104, 5, '2024-02-01', '2024-02-01', '18:00:00', 100, 7.5),
(105, 6, '2024-02-10', '2024-02-11', '23:30:00', 132, 9.5),
(102, 1, '2024-01-10', '2024-03-01', '20:00:00', 110, 9.1),
(106, 7, '2024-03-01', '2024-03-01', '17:45:00', 85, 8.8),
(107, 8, '2024-03-03', '2024-03-03', '21:15:00', 70, 8.0),
(108, 9, '2024-03-05', '2024-03-06', '22:30:00', 90, 9.0),
(109, 10, '2024-03-07', '2024-04-01', '19:30:00', 110, 8.9),
(110, 2, '2024-03-10', '2024-04-01', '20:15:00', 60, 7.0),
(111, 3, '2024-04-02', '2024-04-03', '21:00:00', 45, 9.4),
(112, 6, '2024-04-05', '2024-04-05', '18:15:00', 120, 9.2),
(113, 4, '2024-04-07', '2024-04-08', '17:00:00', 80, 8.5),
(114, 9, '2024-04-09', '2024-04-10', '16:30:00', 75, 9.1),
(115, 5, '2024-04-11', '2024-04-12', '15:00:00', 60, 7.8),
(101, 10, '2024-01-05', '2024-04-15', '20:00:00', 130, 9.0),
(101, 2, '2024-01-05', '2024-04-16', '21:30:00', 95, 8.2),
(101, 3, '2024-01-05', '2024-04-16', '22:30:00', 85, 8.9),
(101, 4, '2024-01-05', '2024-04-16', '23:30:00', 70, 9.3),
(101, 5, '2024-01-05', '2024-04-16', '18:00:00', 60, 7.5),
(101, 6, '2024-01-05', '2024-04-16', '19:00:00', 120, 9.4),
(101, 7, '2024-01-05', '2024-04-16', '20:00:00', 100, 8.7),
(116, 11, '2024-04-20', '2024-04-21', '21:00:00', 150, 9.3);

-- Q1. Monthly subscriber growth
SELECT 
  DATE_FORMAT(subscription_date, '%Y-%m-01') AS month,
  COUNT(DISTINCT user_id) AS new_subscribers
FROM streaming_data
GROUP BY DATE_FORMAT(subscription_date, '%Y-%m-01')
ORDER BY month;

-- Q2. Top 5 most-watched movies by views
SELECT m.movie_title, COUNT(*) AS views
FROM streaming_data s
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.movie_title
ORDER BY views DESC
LIMIT 5;

-- Q3. Average watch time per genre
SELECT m.genre, ROUND(AVG(s.watch_duration), 2) AS avg_watch_time
FROM streaming_data s
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.genre;

-- Q4. Identify binge-watchers (watched >5 titles in a day)
SELECT user_id, watch_date, COUNT(DISTINCT movie_id) AS titles_watched
FROM streaming_data
GROUP BY user_id, watch_date
HAVING titles_watched > 5;

-- Q5. Monthly churn rate (users inactive in next month)
WITH active_users AS (
  SELECT user_id, DATE_FORMAT(subscription_date, '%Y-%m-01') AS month
  FROM streaming_data
  GROUP BY user_id, DATE_FORMAT(subscription_date, '%Y-%m-01')
),
user_activity AS (
  SELECT 
    a.user_id,
    a.month,
    LEAD(a.month) OVER (PARTITION BY a.user_id ORDER BY a.month) AS next_month
  FROM active_users a
)
SELECT 
  month,
  COUNT(*) AS total_users,
  SUM(CASE WHEN next_month IS NULL THEN 1 ELSE 0 END) AS churned
FROM user_activity
GROUP BY month;

-- Q6. Peak streaming hours
SELECT HOUR(watch_time) AS hour,
       COUNT(*) AS view_count
FROM streaming_data
GROUP BY HOUR(watch_time)
ORDER BY view_count DESC;

-- Q7. User retention: how many months did users stay active?
SELECT user_id, COUNT(DISTINCT DATE_FORMAT(watch_date, '%Y-%m')) AS active_months
FROM streaming_data
GROUP BY user_id
ORDER BY active_months DESC;

-- Q8. Top genres by average user rating
SELECT m.genre, ROUND(AVG(s.rating), 2) AS avg_rating
FROM streaming_data s
JOIN movies m ON s.movie_id = m.movie_id
WHERE s.rating IS NOT NULL
GROUP BY m.genre
ORDER BY avg_rating DESC;

-- Q9. Users with consistent weekly activity (watched every week)
SELECT user_id
FROM (
  SELECT user_id, WEEK(watch_date) AS week_no, COUNT(*) AS activity
  FROM streaming_data
  GROUP BY user_id, WEEK(watch_date)
) weekly_activity
GROUP BY user_id
HAVING COUNT(*) >= 3;

-- Q10. Movie watch trends over time
SELECT 
  DATE_FORMAT(watch_date, '%Y-%m-01') AS month,
  COUNT(*) AS total_views
FROM streaming_data
GROUP BY DATE_FORMAT(watch_date, '%Y-%m-01');

-- Q11. Top users by total watch hours
SELECT user_id, ROUND(SUM(watch_duration)/60, 2) AS total_hours
FROM streaming_data
GROUP BY user_id
ORDER BY total_hours DESC
LIMIT 10;

-- Q12. Least popular genres
SELECT m.genre, COUNT(*) AS views
FROM streaming_data s
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY views ASC
LIMIT 5;

-- Q13. Movie rating trends (monthly avg)
SELECT 
  DATE_FORMAT(watch_date, '%Y-%m') AS month,
  ROUND(AVG(rating), 2) AS avg_rating
FROM streaming_data
WHERE rating IS NOT NULL
GROUP BY DATE_FORMAT(watch_date, '%Y-%m')
ORDER BY month;

-- Q14. Detect spikes in new releases watched
SELECT 
  DATE_FORMAT(watch_date, '%Y-%m') AS month,
  COUNT(*) AS new_releases_watched
FROM streaming_data s
JOIN movies m ON s.movie_id = m.movie_id
WHERE m.release_year = YEAR(watch_date)
GROUP BY DATE_FORMAT(watch_date, '%Y-%m');

-- Q15. View: Monthly performance of each genre
CREATE OR REPLACE VIEW genre_monthly_performance AS
SELECT 
  DATE_FORMAT(watch_date, '%Y-%m-01') AS month,
  m.genre,
  COUNT(*) AS total_views,
  ROUND(AVG(s.watch_duration), 2) AS avg_duration
FROM streaming_data s
JOIN movies m ON s.movie_id = m.movie_id
GROUP BY DATE_FORMAT(watch_date, '%Y-%m-01'), m.genre;

-- Query the view
SELECT * FROM genre_monthly_performance ORDER BY month, genre;

