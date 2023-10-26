/*--------------------------------------------------*/
-- Author: Sri Casper
-- Date: 2023.03.02
-- Description: KickstarterLab
/*--------------------------------------------------*/

/* 
Cleanning data
*/
-- Open the table
SELECT * 
FROM campaign;

-- Standardize date format
ALTER TABLE campaign MODIFY launched DATE;
ALTER TABLE campaign MODIFY deadline DATE;

-- Look for any duplicate value in each table and only keep one
-- Some duplicate names were found. 
-- However, there are different projects according to their other values.
-- In conclusion, this means no duplicate value was founded.
SELECT name
	sub_category_id,
    country_id,
    currency_id,
    launched,
    deadline,
    goal,
    pledged,
    backers,
    outcome,
COUNT(*) as 'count'
FROM campaign
GROUP BY name,
	sub_category_id,
    country_id,
    currency_id,
    launched,
    deadline,
    goal,
    pledged,
    backers,
    outcome
HAVING COUNT(*) > 1;

SELECT name, COUNT(name)
FROM category
GROUP BY name
HAVING COUNT(name) > 1;

SELECT name, COUNT(name)
FROM country
GROUP BY name
HAVING COUNT(name) > 1;

SELECT name, COUNT(name)
FROM currency
GROUP BY name
HAVING COUNT(name) > 1;

SELECT name, COUNT(name)
FROM sub_category
GROUP BY name
HAVING COUNT(name) > 1;

SELECT name, COUNT(name)
FROM campaign
GROUP BY name
HAVING COUNT(name) > 1;

-- Check the amount of campaign
-- 15000 campaigns
select count(name)
from campaign;

/*--------------------------------------------------*/

/*
Part 1: Conduct a preliminary analysis
*/
-- 1) Are the goals for dollars raised significantly different
-- between campaigns that are successful and unsuccessful?

-- The amount of 'successful' campaigns
-- 5319 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful';

-- The amount of 'successful' campaigns
-- with the goal less than $5,000
-- 3241 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'AND goal <= 5000;

-- The amount of 'successful' campaigns
-- with the goal less than $10,000
-- 4224 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'AND goal <= 10000;

-- The amount of 'successful' campaigns
-- with the goal less than $15,000
-- 4586 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'AND goal <= 15000;

-- The amount of 'successful' campaigns
-- with the goal less than $20,000
-- 4800 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'AND goal <= 20000;

-- The amount of 'successful' campaigns
-- with the goal less than $25,000
-- 4943 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'AND goal <= 25000;

-- The amount of 'successful' campaigns
-- with the goal less than $30,000
-- 5042 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'AND goal <= 30000;

-- Goal of each successful campaign
SELECT goal AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'successful'
ORDER BY goal ASC;

-- The average of 'successful' campaigns
-- $9743.03
SELECT ROUND(AVG(goal),2) as AvgSuccessfulGoal
from campaign
where outcome = 'successful';

-- The amount of 'failed' campaigns
-- 7850 campaigns
SELECT COUNT(*) AS UnsuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed';

-- The amount of 'successful' campaigns
-- with the goal less than $5,000
-- 3451 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'AND goal <= 5000;

-- The amount of 'successful' campaigns
-- with the goal less than $10,000
-- 4821 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'AND goal <= 10000;

-- The amount of 'successful' campaigns
-- with the goal less than $15,000
-- 5445 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'AND goal <= 15000;

-- The amount of 'successful' campaigns
-- with the goal less than $20,000
-- 5958 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'AND goal <= 20000;

-- The amount of 'successful' campaigns
-- with the goal less than $25,000
-- 6296 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'AND goal <= 25000;

-- The amount of 'successful' campaigns
-- with the goal less than $30,000
-- 6531 campaigns
SELECT COUNT(*) AS SuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'AND goal <= 30000;

-- Goal of each unsuccessful campaign
SELECT goal AS UnsuccessfulCampaign
FROM campaign 
WHERE outcome = 'failed'
ORDER BY goal ASC;

-- The average of 'failed' campaigns
-- $97520.03
SELECT ROUND(AVG(goal),2) as AvgUnsuccessfulGoal
from campaign
where outcome = 'failed';

-- The amount of 'successful' campaign which its pledged is more than its goal
-- 5169 campaigns
SELECT COUNT(*)
from campaign
where outcome = 'successful' AND pledged > goal;

/*--------------------------------------------------*/

-- 2) What are the top/bottom 3 categories with the most backers?
-- The top 3 categories by backers
-- 7, 13, 5
-- Games, Technology, Design
SELECT category.id, category.name, SUM(backers) AS backers 
FROM campaign
JOIN sub_category ON campaign.sub_category_id = sub_category.id
JOIN category ON sub_category.category_id = category.id 
GROUP BY category.id
ORDER BY backers DESC
LIMIT 3;

-- The bottom 3 categories by backers
-- 14, 15, 6
-- Dance, Journalism, Crafts
SELECT category.id, category.name, SUM(backers) AS backers 
FROM campaign
JOIN sub_category ON campaign.sub_category_id = sub_category.id
JOIN category ON sub_category.category_id = category.id 
GROUP BY category.id
ORDER BY backers ASC
LIMIT 3;

-- What are the top/bottom 3 subcategories by backers?
-- The top 3 subcategories by backers
-- 14, 8, 44
-- Tabletop Games, Product Design, Video Games
SELECT sub_category_id, SUM(backers) AS backers 
FROM campaign 
GROUP BY sub_category_id 
ORDER BY backers DESC 
LIMIT 3;

SELECT *
FROM sub_category
WHERE id = 14 OR id = 8 OR id = 44;

-- The bottom 3 subcategories by backers
-- 149, 131, 65
-- Glass, Photo, Latin
SELECT sub_category_id, SUM(backers) AS backers 
FROM campaign 
GROUP BY sub_category_id 
ORDER BY backers ASC 
LIMIT 3;

SELECT *
FROM sub_category
WHERE id = 149 OR id = 131 OR id = 65;

/*--------------------------------------------------*/

-- 3) What are the top/bottom 3 categories that have raised the most money?
-- The top 3 categories
-- 7, 13, 5
-- Games, Technology, Design
SELECT category.id, category.name, SUM(backers) AS MostPledged 
FROM campaign
JOIN sub_category ON campaign.sub_category_id = sub_category.id
JOIN category ON sub_category.category_id = category.id 
GROUP BY category.id
ORDER BY MostPledged DESC
LIMIT 3;

-- The bottom 3 categories
-- 15, 14, 6
-- Journalism, Dance, Crafts
SELECT category.id, category.name, SUM(pledged) AS LeastPledged 
FROM campaign
JOIN sub_category ON campaign.sub_category_id = sub_category.id
JOIN category ON sub_category.category_id = category.id 
GROUP BY category.id
ORDER BY LeastPledged ASC
LIMIT 3;

-- What are the top/bottom 3 subcatgories that have raised the most money?
-- The top 3 subcategories
-- 8, 14, 44
-- Product Design, Tabletop Games, Video Games
SELECT sub_category_id, SUM(pledged) AS MostPledged
FROM campaign 
GROUP BY sub_category_id 
ORDER BY MostPledged DESC 
LIMIT 3;

SELECT *
FROM sub_category
WHERE id = 8 OR id = 14 OR id = 44;

-- The bottom 3 subcategories
-- 149, 142, 65
-- Glass, Crochet, Latin
SELECT sub_category_id, SUM(pledged) AS LeastPledged 
FROM campaign 
GROUP BY sub_category_id 
ORDER BY LeastPledged ASC 
LIMIT 3;

SELECT *
FROM sub_category
WHERE id = 149 OR id = 142 OR id = 65;

/*--------------------------------------------------*/

-- 4) What was the amount the most successful board game campany raised?
-- $1546269.5
-- How many backers did they have?
-- 8396 backers
SELECT *
FROM campaign
WHERE name LIKE('%board game%') AND outcome = 'successful'
ORDER BY pledged DESC;

-- How many successful board game company?
-- 22 companies
SELECT COUNT(*)
FROM campaign
WHERE name LIKE('%board game%') AND outcome = 'successful';

-- How many board game company?
-- 44 companies
SELECT COUNT(*)
FROM campaign
WHERE name LIKE('%board game%');

-- Duration of each successful board game campaign
SELECT pledged, DATEDIFF(deadline,launched) AS Duration
FROM campaign
WHERE name LIKE('%board game%') AND outcome = 'successful'
ORDER BY pledged DESC;

-- How many successful board game campaign have more pledged than goal?
-- 22 companies
SELECT COUNT(*)
FROM campaign
WHERE name LIKE('%board game%') AND outcome = 'successful' and pledged > goal;

/*--------------------------------------------------*/

-- 5) Rank the top three countries with the most successful campaigns 
-- in terms of dollars (total amount pledged), and in terms of the number of campaigns backed.
-- 2, 1, 3
-- US, GB, CA
SELECT country_id, count(*), ROUND(SUM(pledged),2), SUM(backers)
FROM campaign
WHERE outcome = 'successful'
GROUP BY country_id
ORDER BY ROUND(SUM(pledged),2) DESC
LIMIT 3;

SELECT *
FROM country
WHERE id = 2 OR id = 1 OR id = 3;

/*--------------------------------------------------*/

-- 6) Do longer, or shorter campaigns tend to raise more money? Why?
SELECT pledged, DATEDIFF(deadline,launched) AS Duration
FROM campaign
ORDER BY Duration ASC;