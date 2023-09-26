-- 1) content table
SELECT * FROM social_buzz.content;

-- Since SQL Server cannot specify column names with spaces, I need to remove them.

alter table `social_buzz`.`content`
change column `Content ID` `Content_ID` text null default null ,
change column `User ID` `User_ID` text null default null 

-- Change column name'Type' as there are column with similar names in other tables but with different items

alter table content
rename column Type to Types;

-- Removing irrelevant columns

alter table content
drop column MyUnknownColumn;

-- Removing rows with missing info

delete from content where Content_ID = '' or Types = '' or URL = '' or User_ID = '' or Category= '';

-- checking for duplicates

 select distinct(Types)
 from content;
 
 select distinct(Category)
 from content
group by Category;


-- 2) reactions table

-- while importing this file, datatype of datetime column has been changed from text to datetime

select * from reactions

-- Since SQL Server cannot specify column names with spaces and reads the column name 'Datetime' as a function, I need to remove them.

alter table `social_buzz`.`reactions` 
change column `Content ID` `Content_ID` text null default null ,
change column `User ID` `User_ID` text null default null ,
change column `Datetime` `Date_time` datetime null default null ;

-- Removing irrelevant columns

alter table reactions
drop column MyUnknownColumn;

-- Removing rows with missing info

delete from reactions where User_ID = '' or type = '' or Content_ID = '' or Date_time = '';

-- to check for duplicates

select distinct(Type)
from reactions
order by Type;

select Content_ID, User_ID, Type, Date_time, count(*)
from reactions
group by Content_ID, User_ID, Type, Date_time
having count(*) >1;


-- 3) reactiontypes table

select * from social_buzz.reactiontypes;

-- removing irrelevant column

alter table reactiontypes
drop column MyUnknownColumn;

-- checking duplicates

select distinct(Type)
from reactiontypes
order by Type;

select Type, Sentiment, Score, count(*)
from reactiontypes
group by Type, Sentiment, Score
having count(*) >1;

-- checking valid scores

 select Score
 from reactiontypes
 where Score <0;
 
 
 -- top 5 Categories

select distinct(c.category), sum(t.Score) as Scores
from content as c
join reactions as r on r.Content_ID= c.Content_ID
join reactiontypes as t on t.Type= r.Type
group by category
order by Scores desc
limit 5;


-- merge all tables into one single clean table

create table cleaned_table
select t1.Content_ID, t1.User_ID, t1.Types, t1.Category, t1.URL, t2.Type, t2.Date_time, t3.Sentiment, t3.Score
from content as t1
join reactions as t2 on t2.Content_ID = t1.Content_ID
join reactiontypes as t3 on t3.Type = t2.Type

 