/*
8 October 19:00 - 22:00 h

Windows Functions Continued

Windows Functions for Today

Name			Description
-----------     --------------------------------------------------------------------------------------------------------
ROW_NUMBER	:	Assign a unique sequential integer to rows within a partition of a result set, the first row starts from 1.
LAG			:	Provide access to a row at a given physical offset that comes before the current row.
LEAD		:	Provide access to a row at a given physical offset that follows the current row.	:
RANK		:	Assign a rank value to each row within a partition of a result set
DENSE_RANK	:	Assign a rank value to each row within a partition of a result, with no gaps in rank values.
PERCENT_RANK:	Calculate the percent rank of a value in a set of values.
FIRST_VALUE	:	Get the value of the first row in an ordered partition of a result set.
LAST_VALUE	:	Get the value of the last row in an ordered partition of a result set.
---------------------------------------------------------------------------------------------------------------------------


select * from [dbo].[PERSON]
FIRSTNAME	GENDER	BIRTHDATE			HEIGHT	WEIGHT
ROSEMARY	F		2000-05-08 00:00:00	35		123
LAUREN		F		2000-06-10 00:00:00	54		876 
------------------------------------------------------- partition boundry
ALBERT		M		2000-08-02 00:00:00	45		150 
BUDDY		M		1998-10-02 00:00:00	45		189<=== lag
FARQUAR		M		1998-11-05 00:00:00	76		198<=== current row
TOMMY		M		1998-12-11 00:00:00	78		167<=== lead
SIMON		M		1999-01-03 00:00:00	87		256

What is the ORDER BY Clause?
-Imposes ordering on incoming data
-Required by some windows functions like (ROW_NUMBER(), LEAD(), LAG(),…)
-Does not make sense on others (COUNT(), MIN(), …)

Syntax
	function(…) OVER ( … ORDER BY col3,col4, … )

Functions
-ROW_NUMBER()	– increasing integral value
-LEAD()/LAG()	– peek forward and look back
-FIRST_VALUE()/LAST_VALUE()/NTH_VALUE() – access first, last or nth row's data 
--------------------------------------------------------
ROW_NUMBER()  Function
-Creates an increasing integral value, starting at 1
-Subsequent rows get next higher value
-Can use with PARTITION BY
-Resets to 1 when crossing partition boundary
-Takes no parameter!
Syntax
	ROW_NUMBER() OVER ( … ORDER BY var1,var2, … )
*/

--Create a column containing row numbers ordered by ascending name

select  p.*,
 row_number() over (order by p.[FIRSTNAME]) as [row number]
from PERSON p

--Create a column containing row numbers within gender.
select  p.*,
 row_number() over ( partition by gender order by p.[FIRSTNAME]) as [row number]
from PERSON p

select  p.*,
 row_number() over ( partition by gender order by p.[BIRTHDATE]) as [row number]
from PERSON p

----------------------------------
/* 
LEAD()/LAG() Functions
-LEAD() – peek forward a number of rows
-LAG() – look back a number of rows
-Have access to that row's data
-Based off of current row
========================================
GENDER FIRSTNAME	WEIGHT
F		ROSEMARY	123
F		LAUREN		876
M		ALBERT		150<==== LAG 1 row
M		TOMMY		167<==== Current row
M		BUDDY		189<==== LEAD 1 row
M		FARQUAR		198<==== LEAD 2 rows
M		SIMON		256
======================================
Syntax
-LEAD(column-name,nbr-rows-to-lead,def-value) OVER (…)
-LAG(column-name,nbr-rows-to-lag,def-value) OVER (…)
-ORDER BY Clause required
-PARTITION BY Clause not required
-def-value returned if nbr-rows-to-lead or nbr-rows-to-lag:
	-crosses partition boundary
	-goes off top of table
	-goes off bottom of table
-column-name does not have to appear in the ORDER BY Clause
-------------------------------------------------------------
Create two additional columns using the weight:
	-the next heaviest weight
	-the 2 previous lightest weight
*/

select p.FIRSTNAME,p.[WEIGHT],
		lead(p.[WEIGHT],1,-1) over (order by [weight]) [lead 1 weight],
		lag(p.[WEIGHT],2,-1)  over (order by [weight]) [lag 2  weight]
from [dbo].[PERSON] p
order by p.[WEIGHT]

/* 
RANK()/DENSE_RANK()  Functions
Provide ranks based on ORDER BY column
that runners finish a race ranked as 1, 2, 3,…
Tied for first?
RANK() returns 1, 1, 3, 4,…
DENSE_RANK() returns 1, 1, 2, 3,…

Syntax
RANK() OVER ( … ORDER BY … )
DENSE_RANK() OVER ( … ORDER BY … )
No arguments/parameterd required
	ORDER BY Clause required
	PARTITION BY Clause not required
*/
--Create ranks using ascending height within gender
select p.FIRSTNAME,p.GENDER,p.HEIGHT
	   ,rank()       over (PARTITION BY p.gender order by p.HEIGHT )	[height rank]
	   ,dense_rank() over (PARTITION BY p.gender order by p.HEIGHT )	[height dense rank]
from [dbo].[PERSON] p
order by p.GENDER,p.HEIGHT

/* 
FIRST_VALUE()/LAST_VALUE() Functions
Retrieves the first or last value within a column
- Takes a column name as the sole parameter
- Partition by can be used but not mandotory
Syntax
FIRST_VALUE(column-name) OVER ( … ORDER BY … )
LAST_VALUE(column-name)  OVER ( … ORDER BY … )
*/

-- Find names of the heaviest/lightest male/female child
SELECT P.FIRSTNAME,P.GENDER,P.[WEIGHT]
      , FIRST_VALUE(P.FIRSTNAME) OVER (PARTITION BY P.GENDER ORDER BY P.[WEIGHT] ) [lightest person]
      , LAST_VALUE(p.FIRSTNAME)  OVER (PARTITION BY P.GENDER ORDER BY P.[WEIGHT] ) [heaviest person]  
	  FROM [dbo].[PERSON] P
ORDER BY  P.GENDER,p.[WEIGHT]
--------------1.ders sonu -----------------------------

/*
FIRSTNAME	 GENDER	WEIGHT	[Lightest_Child]  [Heaviest_Child]
ROSEMARY		F	123		  ROSEMARY			LAUREN
LAUREN			F	876		  ROSEMARY			LAUREN
--------------------------------------------------------------
ALBERT			M	150		  ALBERT			SIMON
TOMMY			M	167		  ALBERT			SIMON
BUDDY			M	189		  ALBERT			SIMON
FARQUAR			M	198		  ALBERT			SIMON
SIMON			M	256		  ALBERT			SIMON
---------------------------------------------------------------*/

The [Heaviest_Child] column is incorrect. 


-------2. ders--------------------------
SELECT p.FIRSTNAME, p.GENDER, p.WEIGHT,
FIRST_VALUE(p.FIRSTNAME) OVER (PARTITION BY p.GENDER ORDER BY p.WEIGHT) AS 'Lightest',
FIRST_VALUE(p.FIRSTNAME) OVER (PARTITION BY p.GENDER ORDER BY p.WEIGHT DESC) AS 'Heaviest'
FROM PERSON AS p
--------------------------------------
/*
Window Functions allow us to access data very different from the normal sequential way!
PARTITION BY chunks up data
LEAD()/LAG() allow access to a particular row before or after current row
FIRST_VALUE()/LAST_VALUE() allow access to first/last row

The Window Clause allows even more fine-grained access!
- No WINDOW keyword! Use ROWS or RANGE instead.
- If no Window Clause specified, default is current row on back.

Syntax:
ROWS BETWEEN UNBOUNDED   PRECEDING
			 AND CURRENT ROW

Retrieve the name of the heaviest and lightest male and female child

*/
SELECT A.FIRSTNAME,A.GENDER,A.WEIGHT,
       FIRST_VALUE(A.FIRSTNAME) OVER (PARTITION BY A.GENDER 
                                      ORDER BY A.WEIGHT
                                      ROWS BETWEEN UNBOUNDED PRECEDING
                                               AND CURRENT ROW) --all values before and current row
                                                            AS LT_CHILD,
       LAST_VALUE(A.FIRSTNAME) OVER (PARTITION BY A.GENDER 
                                     ORDER BY A.WEIGHT
                                     ROWS BETWEEN UNBOUNDED PRECEDING--all values before and current row
                                              AND CURRENT ROW) AS HV_CHILD
 FROM PERSON A
 ORDER BY A.GENDER,A.WEIGHT
--------------------------------------------------------------------
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
 ORDER BY A.GENDER,A.WEIGHT

 -----------------------------------------------------------
 /* Example 
Compute the average weight using current, previous and
next rows.Use the ROWS Window Clause.
a<-previous row
b<--current row
c<--next row
*/

select p.FIRSTNAME,p.GENDER,p.[WEIGHT]
       ,avg(p.[WEIGHT] ) over (partition  by p.gender order by p.[weight]
			                    rows between 1 preceding and 2 following) [avg weight 3]
from [dbo].[PERSON] p
order by p.GENDER,p.WEIGHT

--select cast((167+189+256+198)/4 as float)
/*
FIRSTNAME                                          GENDER WEIGHT avg weight 3
-------------------------------------------------- ------ ------ ------------
ROSEMARY                                           F      123    499
LAUREN                                             F      876    499
----------------------------------------------------------------------------------
ALBERT                                             M      150    168<== 1 preceding
TOMMY                                              M      167    176<== current row
BUDDY                                              M      189    202<== 2 following
FARQUAR                                            M      198    214<== 2 following
SIMON                                              M      256    227
*/
----------------------------------------------------------------------------------------

/*
NTILE() – splits rows into a specified number of buckets
-CUME_DIST & PERCENT_RANK() – given a value, returns percentile
-PERCENTILE_DISC() & PERCENTILE_CONT() – given a percentile, returns value
-Some can be used in an aggregate sense as well!

NTILE(3)

 
Single parameter indicates number of desired buckets
-Returns an integer representing group inclusion of each row
-Groups are computed based (approx.) on the CEIL(#rows/#groups):
-NTILE(4) for 7 row table
-7/4 =1.75 ==>2 (each bucket contains 2 rows, except for last bucket)
-Results ==> 1,1,2,2,3,3,4
-Attempts to fill each bucket with the same number of rows
*/

SELECT A.FIRSTNAME,A.HEIGHT,
       NTILE(4) OVER (ORDER BY A.HEIGHT) AS GRP4_HT
 FROM PERSON A
 ORDER BY A.HEIGHT
 ------------------------------------------------
 SELECT A.FIRSTNAME,A.GENDER,A.HEIGHT,
       NTILE(7) OVER (PARTITION BY A.GENDER 
                      ORDER BY A.HEIGHT) AS GRP4_HT
 FROM PERSON A
 ORDER BY A.GENDER,A.HEIGHT

 -----------------------
 
/* 
What is the CUME_DIST() function?
CUME_DIST() is the number of rows with values less than or equal to that row's
value divided by the total number of rows
Approximate formula: row_number/total_rows
Ranges from : 0 to 1
Repeated column values receive the same CUME_DIST() value
*/
--compute the cumulative distribution on the height. 
/*
FIRSTNAME	HEIGHT	CUMDIST_HEIGHT
-----------------------------------
ROSEMARY	35		0,142857142857143 <==1/7 
ALBERT		45		0,428571428571429 <==3/7 
BUDDY		45		0,428571428571429 <==3/7
LAUREN		54		0,571428571428571 <==4/7
FARQUAR		76		0,714285714285714 <==5/7
TOMMY		78		0,857142857142857 <==6/7
SIMON		87		1				   <==7/7		 
---------------ders 2 son-----------------------
*/

----------------ders 3-----------------------
--compute the cumulative distribution on the height. 

select p.FIRSTNAME,p.HEIGHT,
	    CUME_DIST() over (order by p.HEIGHT) [cume dist height]

from [dbo].[PERSON] p
order by p.HEIGHT

/* What is the PERCENT_RANK() function?
 PERCENT_RANK() computes the rank, using RANK() 
 on the column, subtracts 1
and then divides by the number of rows minus 1
Returns the cumulative distribution value from 0 to 1
 Exact formula: (rank -1) / (total_rows -1)
 Repeated column values receive the same PERCENT_RANK() value

*/

--Compute the percent rank on the height
select p.FIRSTNAME,p.HEIGHT,
       rank() over (order by p.height) [rank height],
	   PERCENT_RANK() over (order by p.height) [prcnt rnk height]
from [dbo].[PERSON] p
order by p.HEIGHT

-- formula: (rank -1) / (total_rows -1) 
--------------------------------------------
/*
What is the PERCENTILE_DISC() function?
Inverse of CUME_DIST()
Compares desired percentile to CUME_DIST() value. Returns column value
associated with CUME_DIST() equal to or higher than desired percentile.
Values returned always from table

Syntax:
PERCENTILE_DISC(percentile)
WITHIN GROUP (ORDER BY col1,col2,…) OVER ( … )
*/
-- Compute the height associated with the percentiles .50 and .72 ?
select p.FIRSTNAME,p.HEIGHT,
		CUME_DIST() over (order by p.height) [cume dist height],
		PERCENTILE_DISC(.50) WITHIN GROUP (order by p.height) over () [percnt dist 20],
		PERCENTILE_DISC(.72) WITHIN GROUP (order by p.height) over () [percnt dist 72]
from [dbo].[PERSON] p
order by p.HEIGHT

------------------------------------------------------------
/*  
What is the PERCENTILE_CONT() function?
-Similar to PERCENTILE_DISC() except performs linear interpolation
-Values returned are not necessarily from table
-Determines row based on 1+percentile*(totalrows-1)
-First row determined by FLOOR(1+percentile*(totalrows-1))
-Second row determined by CEIL(1+percentile*(totalrows-1))

 Syntax:
PERCENTILE_CONT(percentile)
WITHIN GROUP (ORDER BY col1,col2,…) OVER ( … )

Calculates a percentile based on a continuous distribution of the column value in SQL Server. 
The result is interpolated and might not be equal to any of the specific values in the column

*/
-- Compute the height associated with the percentiles .50 and .72.
select  p.FIRSTNAME,p.HEIGHT,
        PERCENTILE_CONT(0.50)  within group (partition by order by p.height) over () [percnt dist 50],
		PERCENTILE_CONT (0.72) within group (partition  by order by p.height) over () [percnt dist 70]
from [dbo].[PERSON] p

order by p.HEIGHT

---ranks the count of sales for each month in a given year. 
use [AdventureWorks2017]

SELECT MONTH(SOH.OrderDate) AS OrderMonth,
       COUNT(*) AS OrderCount,
       PERCENTILE_CONT(0.5) 
           WITHIN GROUP(ORDER BY COUNT(*)) OVER () AS Median,
       PERCENTILE_DISC(0.5) 
           WITHIN GROUP(ORDER BY COUNT(*)) OVER () AS NotTheMedian
FROM [Sales].[SalesOrderHeader] AS SOH
WHERE SOH.OrderDate >= '2011-06-12'
      AND SOH.OrderDate < '2014-05-31' --2011-06-12 2014-05-31 
GROUP BY MONTH(SOH.OrderDate);
--------------------------------------------------------------------------
SELECT DISTINCT
      p.[FIRSTNAME],p.[HEIGHT], p.[WEIGHT]
    ,[height - 75th perc cont] = PERCENTILE_CONT(0.75)
                                        WITHIN GROUP(ORDER BY p.[WEIGHT])
                                        OVER(PARTITION BY p.[HEIGHT])
    ,[height- 75th perc disc] = PERCENTILE_DISC(0.75)
                                        WITHIN GROUP(ORDER BY p.[WEIGHT])
                                        OVER(PARTITION BY p.[HEIGHT])
FROM [dbo].[PERSON] p
--------------------------------------------------------------------------