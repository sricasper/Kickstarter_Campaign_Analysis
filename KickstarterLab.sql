/*--------------------------------------------------*/
-- Author: Sri Casper
-- Date: 2023.03.01
-- Description: KickstarterLab
/*--------------------------------------------------*/

-- Config SQL mode
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
-- 1902
SELECT COUNT(goal)
FROM campaign 
WHERE goal < 1000;

SELECT COUNT(goal)
FROM campaign 
WHERE goal <= 1000;

-- 3) Exceed funding goal
SELECT name, goal, pledged
FROM campaign
WHERE pledged > goal
ORDER BY pledged DESC;

-- Goal under 1000 are unrealistic

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

-- 5.2)***Use conditional query,
-- store the converted value in the temporary table
-- use INSERT INTO to compare the values
SELECT name, goal, pledged, currency_id
FROM campaign
WHERE pledged > goal 
AND currency_id = 1
ORDER BY pledged*1.2 DESC
LIMIT 10;

-- 6)
SELECT name, pledged, backers, outcome
FROM campaign
WHERE outcome = 'successful' AND country_id = 2
ORDER BY ROUND((pledged/backers),2) DESC;