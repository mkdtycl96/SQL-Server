--HOMEWROK:stripping out unwanted extra spaces from a column would have
SELECT CASE WHEN 'A' <> 'a' collate Latin1_General_CI_AI
            THEN 'Different' ELSE 'Same' END
SELECT CASE WHEN 'A' <> 'a' collate Latin1_General_Cs_AI
            THEN 'Different' ELSE 'Same' END
-- LEN
SELECT LEN('Who            ')          -- 3   LEN makes rstrip
SELECT LEN('                 Who')     -- 20
-- REPLACE
SELECT REPLACE('This string has trailing spaces', 'S', '/')
SELECT REPLACE('                 Who', ' ', '')
SELECT LEN(REPLACE('                 Who', ' ', ''))
-- PATINDEX
SELECT PATINDEX('%ern%', 'SQL Pattern Index') AS position
/*
This example finds the position of the first occurence of the pattern
2018 in values of the product_name column in the production.products
*/
SELECT *
FROM production.products
SELECT product_name, PATINDEX('%2018%', product_name)
FROM production.products
WHERE product_name like '%2018%'
ORDER BY product_name
/*
The STUFF() functiion deletes a part of a string and then inserts a substring
into the string, beginning at a specified position.
STUFF (input_string, start_position, length, replace_with_substring)
*/
SELECT STUFF('SQL Tutorial', 2, 3, 'SQL Server')

SELECT  REPLACE(
              REPLACE(
                  REPLACE(
                'this         has            too                          many                               spaces',
           CHAR(32), CHAR(32) + CHAR(160)),
        CHAR(160) + CHAR(32), ''),
     CHAR(160), '')
	 
select replicate('z',13)
declare @cardnumber varchar(20) = '12345654889956'
select stuff(@cardnumber,1,len(@cardnumber)-4,replicate('X',len(@cardnumber)-4))

--How to mask a credit card number. It reveals only the last four character
declare @cardnumber varchar(20)='4882584254460197'
select stuff(@cardnumber,1,len(@cardnumber)-4,REPLICATE('X',len(@cardnumber)-4))
[credit card number]

SELECT RIGHT('HELLO WORLD', 3);
SELECT LEFT('HELLO WORLD', 3);
SELECT CHARINDEX('-','Hello- World') pos

--SUBSTRING()
--SUBSTRING() extracts a substring with a specified length starting from a location in an input string.
--SUBSTRING(input_string, start, length);
SELECT SUBSTRING('SQL Server SUBSTRING', 12, Len('SQL Server SUBSTRING')) result;

-- how to extract domain names from email
select email,SUBSTRING(email,CHARINDEX('@',email)+1,len(email))
from sales.customers

SELECT
    email,
    SUBSTRING(
        email,
        CHARINDEX('@', email)+1,
        LEN(email)-CHARINDEX('@', email)
    ) domain
FROM
    sales.customers
ORDER BY
    email;

-- homework -- how to count the number of emails per domain , you can use following
select distinct SUBSTRING(email,CHARINDEX('@',email)+1,len(email))
from sales.customers

select [email], SUBSTRING([email],CHARINDEX('@',[email])+1,LEN([email])-CHARINDEX('@',[email])) as [domain_name], COUNT(email)
from [sales].[customers]
group by [domain_name]

-------------------------------------
--REVERSE
SELECT REVERSE('evil ot sah eh') --palindrom
SELECT REPLACE(REVERSE(
    'evil ot sah eh|hcihw ni|pmaws a ylno sa|nam a fo skniht|mreg a tub|
    nem ot elbanoitcejbo|yrev era smreg'),'|','
    ')
SELECT RIGHT(URL, CHARINDEX('/',REVERSE(URL) +'/')-1)
    FROM
     (
     SELECT
     [URL]='http://www.simple-talk.com/content/article.aspx?article=495'
)f


-- over partition by
CREATE TABLE PERSON
(FIRSTNAME VARCHAR(50)
,GENDER VARCHAR(1)
,BIRTHDATE SMALLDATETIME
,HEIGHT SMALLINT
,[WEIGHT] SMALLINT);
INSERT INTO PERSON VALUES('ROSEMARY','F','2000-05-08',35,123);
INSERT INTO PERSON VALUES('LAUREN','F','2000-06-10',54,876);
INSERT INTO PERSON VALUES('ALBERT','M','2000-08-02',45,150);
INSERT INTO PERSON VALUES('BUDDY','M','1998-10-02',45,189);
INSERT INTO PERSON VALUES('FARQUAR','M','1998-11-05',76,198);
INSERT INTO PERSON VALUES('TOMMY','M','1998-12-11',78,167);
INSERT INTO PERSON VALUES('SIMON','M','1999-01-03',87,256);


select * from PERSON

select gender,count(*) gender_count
into peson_count_by_gender
from PERSON
group by  gender

 select * from peson_count_by_gender

 --need to merge this data against person data
 select p.* , pg.gender_count
 from dbo.PERSON p
 inner join dbo.peson_count_by_gender pg
 on pg.GENDER = p.GENDER

 -- windows function
 select p.*,count(*) over (partition by p.GENDER) gender_count
 from dbo.PERSON p
 --calculate running totals of weight by gender
 -- cumulative gender group
 --Calculate running totals of weight by gender
/*
GENDER FIRSTNAME	WEIGHT WT_RUN
F		ROSEMARY	123		123
F		LAUREN		876		999
-------------------------------
M		ALBERT		150		150
M		TOMMY		167		317
M		BUDDY		189		506
M		FARQUAR		198		704
M		SIMON		256		960
*/
select p.GENDER,p.FIRSTNAME,p.[WEIGHT],
  sum(p.[WEIGHT]) over (partition by p.GENDER ORDER BY p.WEIGHT ) WEÝGHT_RUN
from dbo.PERSON p
order by p.GENDER, p.WEIGHT

select p.GENDER,p.FIRSTNAME,p.[WEIGHT],
  sum(p.[WEIGHT]) over (partition by p.GENDER) WEÝGHT_RUN
from dbo.PERSON p
-- BÝRTHDAY
SELECT p.*, count(*) over(partition by p.GENDER,year([BIRTHDATE])) gender_counts_by_birthday
from PERSON p
--order by p.GENDER,p.[WEIGHT]
/*
 How does PARTITION BY Clause work?
-Also called Query Partition Clause
-Similar to the GROUP BY Clause
-Breaks up data into chunks (or partitions)
-Separated by partition boundary
-Function performed within partitions
-Re-initialized when crossing partition boundary
Syntax function(…) OVER (PARTITION BY col1,col2,…)
Functions such as COUNT(), SUM(), MIN(), MAX(), etc.
New functions ROW_NUMBER(), RATIO_TO_REPORT()
*/
--creata a column containing gender birthdate year
select p.[FIRSTNAME],[GENDER],year([BIRTHDATE]) [BIRTHDATE],[HEIGHT],[WEIGHT]
,count(*) over(PARTITION BY p.gender, year([BIRTHDATE])) [gender count by birthdate]
from [dbo].[PERSON] p
--ozet
/*
-PARTITION BY Clause breaks rows into chunks
-Allows for within-chunk computations
-No reduction in data! 7 in, 7 out
*/
 
 SELECT p.*,
 row_number() over (order by p.[FIRSTNAME]) AS [row_number]
 from PERSON p

  SELECT p.*,
 row_number() over (partition by gender order by p.[FIRSTNAME]) AS [row_number]
 from PERSON p

  SELECT p.*,
 row_number() over (partition by gender order by p.[BIRTHDATE]) AS [row_number]
 from PERSON p



 ------------------------------------

 select p.FIRSTNAME,p.[WEIGHT],
 lead(p.[WEIGHT],1,-1) over (order by [weight]) [lead 1 wight],
 lag(p.[WEIGHT],2,-1) over (order by [weight]) [lag 2 wight]
 from [dbo].[PERSON] p
 order by p.[WEIGHT]

 --- RANK()

 select p.FIRSTNAME,p.GENDER,p.HEIGHT,
 rank() over(partition by p.gender order by p.HEIGHT) [height rank]
 , dense_rank() over (partition by p.gender order by p.HEIGHT) [height dense rank]
 from [dbo].[PERSON] p
 order by p.GENDER,p.HEIGHT

 -- FIRST_VALE LAST_VALUE

 SELECT p.FIRSTNAME, p.GENDER, p.WEIGHT,
 first_value(p.FIRSTNAME) OVER (partition by p.GENDER ORDER BY p.WEIGHT) AS 'LÝGHTEST',
 first_value(p.FIRSTNAME) OVER (partition by p.GENDER ORDER BY p.WEIGHT DESC) AS 'HEAVVÝEST'
 FROM dbo.PERSON p
 ORDER BY P.GENDER,P.WEIGHT

 --- ROWS BETWEEN UNBOUNDED PRECEDING SND CURRENT ROW
 -- PATÝTÝON YAPTIÐIM SETTEKÝ EN AÐIRI GETÝR

 --Retrieve the name of the heaviest and lightest male and female child
SELECT A.FIRSTNAME,A.GENDER,A.WEIGHT,
       FIRST_VALUE(A.FIRSTNAME) OVER (PARTITION BY A.GENDER
                                      ORDER BY A.WEIGHT
                                      ROWS BETWEEN UNBOUNDED PRECEDING
                                               AND UNBOUNDED FOLLOWING)  LT_CHILD,
		--give me all rows before current row and after current row with current row
       LAST_VALUE(A.FIRSTNAME) OVER (PARTITION BY A.GENDER
                                     ORDER BY A.WEIGHT
                                     ROWS BETWEEN UNBOUNDED PRECEDING
                                              AND UNBOUNDED FOLLOWING) HV_CHILD
 FROM PERSON A
 ORDER BY A.GENDER,A.[WEIGHT]

 -------------------------------------------------
 select p.FIRSTNAME,p.GENDER,p.WEIGHT,
 AVG(p.WEIGHT) OVER (partition by p.GENDER ORDER BY p.[WEIGHT] 
 rows between 1 preceding and 2 following) [avg_weight 3]
FROM dbo.PERSON p
order by p.GENDER ,p.WEIGHT

select(123+876)/2
select(150+167+189)/2 -- female patition una dahail olamaz sýfýrlandý

--- NTILE() - SPLÝTS ROWS ÝNTO A SPECÝFÝED OF BUCKETS
-- CUME_DIST

SELECT A.FIRSTNAME,A.HEIGHT,
NTILE(4) OVER (partition by ORDER BY A.HEIGHT) AS GRP4_HT
FROM  PERSON A
ORDER BY A.HEIGHT


SELECT A.FIRSTNAME,A.HEIGHT,A.GENDER,
NTILE(7) OVER (partition by A.GENDER ORDER BY A.HEIGHT) AS GRP4_HT
FROM  PERSON A
ORDER BY A.HEIGHT,A.GENDER

-- CUME_DIST
-- COMPUTE THE CUMULATIVE

SELECT A.FIRSTNAME,A.HEIGHT,A.GENDER,
CUME_DIST()  OVER (partition by A.GENDER ORDER BY A.HEIGHT) AS GRP4_HT
FROM  PERSON A
ORDER BY A.GENDER

SELECT A.FIRSTNAME,A.HEIGHT,A.GENDER,
 CUME_DIST()   OVER ( ORDER BY A.HEIGHT) AS CUME_DIST_HEIGHT
FROM  PERSON A
ORDER BY A.HEIGHT,A.GENDER

-- PERCENT_RANK
 SELECT p.FIRSTNAME, p.HEIGHT,
   RANK() over (order by p.HEIGHT) [RANK HEIGHT],
   PERCENT_RANK() over (order by p.HEIGHT) [percent_rnk_height]

 FROM dbo.PERSON p
 order by p.HEIGHT

 -- PERCENTILE_DISC
 --WITHIN GROUP ( ORDER BY) OVER()

 select p.FIRSTNAME,p.HEIGHT,
 CUME_DIST() over (order by p.HEIGHT) [cume dist height],
 PERCENTILE_DISC(.45) WITHIN GROUP (order by p.HEIGHT ) over () [percent dist 50],
  PERCENTILE_DISC(.72) WITHIN GROUP (order by p.HEIGHT ) over () [percent dist 72]

 from [dbo].PERSON p

 order by p.HEIGHT

 --PERCENTILE_CONT

 select p.FIRSTNAME,p.HEIGHT,
 PERCENTILE_CONT(0.5) within group (order by p.HEIGHT) over() [percnt dist 50],
 PERCENTILE_CONT(0.72) within group (order by p.HEIGHT) over() [percent dist 70]

 from PERSON p

 order by 