CREATE TABLE applestore_description_combined AS
SELECT * FROM applestore_description1
UNION ALL
SELECT * FROM applestore_description2
UNION ALL
SELECT * FROM applestore_description3
UNION ALL

SELECT * FROM applestore_description4
 /*
Identify the Stake holders
What app categories are most important
What price should  Set
How Can I maximise user ratings
Exploratory Data Analysis (EDA)to understand the structure of data and ofter reveals issues
in dataset that need to be addressed before further analysis.
These issues might include missing or inconsistent data errors or outliers.

*/
-- Check the number of unique apps in both Applestores
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined
-- Check for any missing values in any fields
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR price_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM Aapplestore_description_combined
WHERE app_desc IS NULL 

-- Find the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- Get an overview of the apps ratings
SELECT min(uswr_rating) AS MinRating,
max(user_rating) AS MaxRating,
avg(user_rating) AS AvgRating
FROM AppleStore

-- Get the distribution of app prices
SELECT (price/2)*2 AS PriceBinStart,
((price/2)*2)+2 AS PriceBinEnd,

COUNT(*) AS NumApps
FROM AppleStore
GROUP BY PriceBinStart
ORDER BY PriceBinStart
/*
DATA ANALYSIS
*/
-- Determine whether the paid apps have more ratings than free apps
SELECT CASE
	  WHEN price>0 THEN 'Paid'
	  ELSE 'Free'
	END AS App_Type,
	avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type
-- Check if apps with more supported languages have higher ratings
SELECT CASE
	WHEN lang_num<10 THEN '<10 languages'
	WHEN lang_num BETWEEN 10 AND 30 THEN  '10-30 languages'
	ELSE '>30 languages'
	END AS language_bucket,
	avg(user_rating) AS Avg_Rating
	FROM AppleStore
	GROUP BY language_bucket
	ORDER BY Avg_Rating DESC

-- Check genre with low ratings

SELECT prime_genre,
avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10

-- Check if there is correlation between the length of the app description and user rating
SELECT CASE
	   WHEN length(b.app_desc) < 500 THEN 'Short'
	   WHEN length(b.app_desc) BETWEEN  500 AND 1000 THEN 'Medium'
	   ELSE 'long'
	END AS description_length_bucket,
	avg(a.user_rating) AS average_rating
FROM AppleStore AS A
JOIN
    appleStore_description_combined AS b
ON
  a.id=b.id
GROUP BY description_length_bucket
ORDER BY average_rating DESC


--  Check the top-rated apps for each genre
SELECT prime_genre,
	track_name,
	user_rating,
	RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
	FROM 
	appleStore
	) AS a
WHERE
a.rank = 1
/* It was analysed that good quality app with little bit price have more rating then Free app with less quality apps*/
