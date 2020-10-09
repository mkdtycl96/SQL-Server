-- SQL string functions
-- char,nchar,varchar,nvarchar
-- text,ntext
select datalength(N'This one is a unicode string')
select datalength('This one is not a unicode string')

select nchar(0x20Ac) [sign],'Euro' currency
select nchar(0xA3) [sign],'pound sign' currency
--charindex
select CHARINDEX('/','SQL Server/abcd')

select CHARINDEX('SQL SERVER','SQL Server/abcd' collate Latin1_General_CS_AS) POS

SELECT 
   CHARINDEX('is','This is a my sister',5) start_at_fifth,
   CHARINDEX('is','This is a my sister',10) start_at_tenth

   -- homework:
   --write a simple t-sql routine which splits delimited string into a table
   --usage: give your routine a name
   -- abc(string,delimiter) ==> This-is-a-my-sister
   string_ ('is','This is a my sister',10)

   -- sql concat
   select
   'John' + ' ' + 'Doe' as fullname;

   --SQL Server CONCAT()
SELECT
    'John' + '' + 'Doe' AS full_name;
	--Using CONCAT() function with NULL
SELECT
    CONCAT(
        CHAR(13),
        CONCAT(first_name,' ',last_name),
        CHAR(13),
        phone,
        CHAR(13),
        CONCAT(city,' ',state),
        CHAR(13),
        zip_code
    ) customer_address
FROM
    sales.customers
ORDER BY
    first_name,
    last_name;
--Tomorrow String ve Windows Functions




  select STRING_SPLIT( 'selam nasýlsýn iyimisin', '-' )  


