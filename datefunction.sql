select SYSDATETIME() --2020-10-03 18:03:29.2299525
select GETUTCDATE() --2020-10-03 15:03:51.167

select GETDATE() get_date,SYSDATETIME() systemdate

select CONVERT(char(20),SYSDATETIMEOFFSET(),113)
--03 Oct 2020 18:08:29
select CONVERT(char(20),SYSDATETIMEOFFSET(),113)

select CURRENT_TIMESTAMP as current_date_time

select CONVERT(date,SYSUTCDATETIME()) utc_date

SELECT DATENAME (YEAR,GETDATE())
     SELECT DATENAME (quarter,GETDATE()) --
     SELECT DATENAME (MONTH,GETDATE()) --
     SELECT DATENAME (dayofyear,GETDATE()) --
     SELECT DATENAME (DAY,GETDATE()) --
     SELECT DATENAME (week,GETDATE()) --
     SELECT DATENAME (weekday,GETDATE()) --
     SELECT DATENAME (hour,GETDATE()) --
     select datepart(ISO_WEEK,GETDATE())

	 --dateadd, datediff
	 --DATEADD
SELECT '2007-01-01 00:00:00', DATEADD(YEAR,10,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(quarter,100,'2007-01-01 00:00:00.000') -- yüz çeyrek ekle
SELECT '2007-01-01 00:00:00', DATEADD(MONTH,100,'2007-01-01 00:00:00.000') -- yüz ay ekle
SELECT '2007-01-01 00:00:00', DATEADD(dayofyear,100,'2007-01-01 00:00:00.000') -- 100 gün ekle
SELECT '2007-01-01 00:00:00', DATEADD(DAY,100,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(week,100,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(weekday,100,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(hour,100,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(minute,100,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(second ,100,'2007-01-01 00:00:00.000')
SELECT '2007-01-01 00:00:00', DATEADD(millisecond,100,'2007-01-01 00:00:00.000')

--datediff
select datediff(day,'1 feb 2016','15 jul 2020') --28
select datediff(day,'2007-01-01','2015-01-01')

--datediff
	SELECT DATEDIFF(DAY,'15 jul  2016','1 feb  2020')
    SELECT DATEDIFF(DAY,'1 feb  2008','1 mar 2008') --29must be a leap year!
--Formatting Dates
SELECT DATENAME(dw,GETDATE()) --To get the full Weekday name
SELECT LEFT(DATENAME(dw,GETDATE()),3) --abbreviated Weekday name (MON, TUE, WED etc)
SELECT DATEPART(dw,GETDATE())+(((@@Datefirst+3)%7)-4) --ISO-8601 Weekday number
SELECT RIGHT('00' + CAST(DAY(GETDATE()) AS VARCHAR),2)--Day of month -- leading zeros
SELECT CAST(DAY(GETDATE()) AS VARCHAR) --Day of the month without leading space
SELECT DATEPART(dy,GETDATE()) --day of the year


select DATEADD(hour,2,GETDATE())
select DATEADD(month,1,GETDATE())

--firts sunday next month homework







