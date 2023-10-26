/*--------------------------------------------------*/
-- Author: Sri Casper
-- Date: 2023.03.01
-- Description: KickstarterLab
/*--------------------------------------------------*/

SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';

-- Set as a default schema
USE kickstarter;

-- 1)
-- Highest funding goal
SELECT name,
	   goal
FROM campaign
ORDER BY goal DESC
LIMIT 20;

-- Lowest funding goal
SELECT name,
	   goal
FROM campaign
ORDER BY goal ASC
LIMIT 20;

-- 2)
-- 2.1) Number of campaigns with a goal less than $1000
-- 1902
SELECT COUNT(*) AS NumberOfGoalLessThan1000
FROM campaign 
WHERE goal < 1000;

-- 2.2) Number of campaigns with a goal greater than or equal to $1000
SELECT COUNT(*)
FROM campaign 
WHERE goal >= 1000;

-- 2.3)Filter out the possibly incorrect rows
-- Goal under 1000 are unrealistic.
SELECT *
FROM campaign
WHERE goal >= 1000
LIMIT 50; -- Not part of solution, but added to prevent large output

/*
-- 3) Exceed funding goal
SELECT name, goal, pledged
FROM campaign
WHERE pledged > goal
ORDER BY pledged DESC;
*/

-- 3.1) Most successful campaigns by difference
SELECT 
    name,
    goal,
    pledged,
    pledged - goal AS success_difference,
    pledged / goal AS success_ratio
FROM
    campaign
ORDER BY success_difference DESC
LIMIT 10;

-- 3.2) Most successful campaigns by ratio
SELECT 
    name,
    goal,
    pledged,
    pledged - goal AS success_difference,
    pledged / goal AS success_ratio
FROM
    campaign
ORDER BY success_ratio DESC
LIMIT 10;

-- 4.1)
-- 115
SELECT COUNT(*)
FROM campaign
WHERE pledged >= goal 
AND NOT(outcome = 'successful');

-- 4.2)
-- 1
SELECT COUNT(*)
FROM campaign
WHERE pledged >= goal 
AND outcome = 'failed';

-- 5)
-- 1, 2
-- GBP, USD
SELECT name, goal, pledged, currency_id
FROM campaign
WHERE pledged > goal
ORDER BY pledged DESC
LIMIT 10;

SELECT name
FROM currency
WHERE id = 1 OR id = 2;

-- 5.3)***Use conditional query,
-- store the converted value in the temporary table
-- use INSERT INTO to compare the values

-- Convert SuccessDiff to USD
SELECT name, 
	   (pledged - goal) AS SuccessDiff,
       currency_id
FROM campaign
WHERE (pledged - goal) > 0
	AND currency_id = 1
ORDER BY SuccessDiff * 1.2 DESC
LIMIT 10;

-- How to put these values back to the table and compare them to the one with USD?
-- If you convert them all to USD does this change the order?
-- Manually
SELECT name,
	   1.29 * (pledged - goal) AS SuccessDiff
FROM campaign
WHERE name = 'Earin - The Worlds Smallest Wireless Earbuds';

-- Using CASE WHEN
SELECT name,
	   goal,
       pledged,
       pledged - goal AS SuccessDiff,
       currency_id,
CASE WHEN currency_id = 1 THEN 1.29 * (pledged - goal)
	 ELSE (pledged - goal)
END AS DiffInUSD
FROM campaign
ORDER BY SuccessDiff DESC
LIMIT 10;

-- 6) Lets try to find successful campaigns in Canada which were backed by investors with big money! 
-- In other words, which campaign has the largest pledges per backer? 
-- Make sure to filter out any null values from your query results.
SELECT name, ROUND((pledged/backers),2) AS AvgPledged
FROM campaign
WHERE ROUND((pledged/backers),2) IS NOT NULL
AND outcome = 'successful' 
AND country_id = 2
ORDER BY AvgPledged DESC
LIMIT 5;