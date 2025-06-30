# 🎬 SQL Project : Online Movie Streaming Analysis

This project analyzes online movie streaming behavior using advanced SQL techniques. The dataset simulates a platform's watch history, user subscriptions, movie metadata, and ratings. We explore patterns in viewer activity, retention, binge-watching, and content performance.

---

## 🗃️ Dataset Overview

Two primary tables:

- **`movies`**: Contains `movie_id`, `title`, `genre`, and `release_year`
- **`streaming_data`**: Stores `user_id`, `movie_id`, `watch_date`, `watch_duration`, and optional `rating`

---

## 🧠 Key Questions Answered (15 Total)

| # | Analysis Focus | SQL Concepts Used |
|--|----------------|------------------|
| 1 | Monthly subscriber growth | `GROUP BY`, `DATE_FORMAT` |
| 2 | Most-watched movies | `JOIN`, `ORDER BY`, `LIMIT` |
| 3 | Average watch time per genre | `AVG`, `GROUP BY` |
| 4 | Detect binge-watchers | `HAVING`, `COUNT(DISTINCT)` |
| 5 | Monthly churn detection | `CTE`, `LEAD()`, `CASE` |
| 6 | Peak streaming hours | `HOUR()`, `ORDER BY` |
| 7 | User retention months | `DISTINCT`, `GROUP BY` |
| 8 | Top genres by rating | `JOIN`, `WHERE`, `AVG()` |
| 9 | Weekly activity consistency | `WEEK()`, subquery |
| 10 | Monthly watch trends | `GROUP BY`, `DATE_FORMAT` |
| 11 | Top viewers by watch hours | `SUM()`, `ORDER BY` |
| 12 | Least popular genres | `ORDER BY ASC`, `LIMIT` |
| 13 | Rating trends over time | `GROUP BY`, `AVG()` |
| 14 | Spikes in new release views | `YEAR()`, `JOIN` |
| 15 | Genre performance view | `VIEW`, `GROUP BY`, `JOIN` |

---

## 📌 Insights & Findings

- **High-engagement months** were clearly visible — April saw a spike in viewing activity.
- **Sci-Fi** and **Historical** genres consistently ranked high in both watch time and ratings.
- User `101` was the most active with frequent binge sessions and high watch hours.
- Peak viewing hours centered around **8–11 PM**.
- **New release impact** was measurable with a clear bump in monthly new content views.
- A dynamic **view** was created to track genre performance by month.

---

## 🛠️ SQL Techniques Practiced

- ✅ Window Functions (`LEAD`, `RANK`)
- ✅ CTEs for pipeline-based logic
- ✅ Views for dashboard-ready metrics
- ✅ Time-based grouping (`DATE_FORMAT`, `WEEK`)
- ✅ Advanced filtering & subqueries

---

## 💾 How to Run

1. Import `streaming_project.sql` in MySQL Workbench.
2. The script creates tables, inserts data, and runs queries.
3. Check output for each query and validate against real-world expectations.

---

## 📁 Files Included

- `streaming_project.sql` – Table creation, data inserts, and all 15 queries
- `README.md` – Project explanation and results

---


## 👤 Author

**Tejas N Gowda**  
📧 tejasngowda1431@gmail.com  
🔗 www.linkedin.com/in/tejas-n-gowda-62b7b4252
