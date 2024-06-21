select *
from layoffs;

-- steps involved in this project
-- 0. make a copy of the raw data and make changes on that dont take the original raw data in account
-- 1. removing of duplicates if any
-- 2.standardize the  data
-- 3. null values or the blank values
-- 4. remove any columns


-- creating a new table[SCHEMA ONLY IN THIS LOC] for a data opeartions
create table layoffs_stagging
like layoffs;


-- copy the data from the layoffs table as it is to make a copy and use as ..
insert layoffs_stagging
select * from
layoffs;


-- creating a new column by the window function as row number
-- and partionning it by all the arguments avaliable
-- as any row number is > 1 than there is a duplicate data avaliable here
select * ,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
from layoffs_stagging;



-- creating a cte as to fetch the data in a proper manner 
-- for viweing whether the row_num is >1 or not
with duplicate_cte as
(
	select * ,
	row_number() over(partition by company,location,industry
    ,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
	from layoffs_stagging
)
select *  -- here we cannot delete the cte where row_num >2 as deletion in cte is not applicable in mysql
from duplicate_cte
where row_num>1;


-- actually checking whether duplicate is there or not
select * from layoffs_stagging
where company='&open';

-- as deleting in cte is not applicable 
-- so we create another table and copying the output values of the above cte
CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- insert the values into the tables 
-- by taking that cte statements into account
-- here we get a table already having a row_num for every unique record.
insert into layoffs_stagging2
select * ,
row_number() over(partition by company,location,industry
,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_stagging
;


select * 
from layoffs_stagging2; -- a table with unique row number for unique data

-- deleting that duplicate row data where row_num>1
delete 
from layoffs_stagging2
where row_num>1;

-- here after that opearations layoffs_stagging2 table contains all unique values in his tables
select * from layoffs_stagging2;


-- STANDARDIZING DATA

-- as the company col is having some white space in the starting
-- that is why trim is used to remove that white space
update layoffs_stagging2
set company=trim(company);

select distinct industry
from layoffs_stagging2
order by 1;

-- here we see that same "cyptro" is misttypen to "cyptrocurrency" or "cyptro currency"
-- this all belong to the same indusrry type that is cyptrocurrency 
-- therefore they should be rename

select *
from layoffs_stagging2
where  industry like 'crypto%';

update
layoffs_stagging2 set industry='Crypto'
where industry like "Crypto%";

-- industry field  is ok for now
-- now we will look for the others features also
-- here we will start with the country
select *
from layoffs_stagging2
where country = 'united states';

-- so here we can see that united states have the same name with two  values 
-- [united states] and [united states.]
--  it has to  be changed to be a correct value without the full stop
update layoffs_stagging2
set country='United states'
where country like 'United%states%';

select distinct country
from layoffs_stagging2
order by 1;

select distinct country,trim(country)
from layoffs_stagging2
order by 1;

update layoffs_stagging2 
set country = trim( trailing '.' from country)
where country like 'United States%';






-- changing all the data type format to a single date type format
UPDATE layoffs_stagging2
SET `date` = CASE 
    WHEN `date` LIKE '%-%-%' THEN STR_TO_DATE(`date`, '%m-%d-%Y')
    ELSE STR_TO_DATE(`date`, '%m/%d/%Y')
END;

alter table layoffs_stagging2
modify column `date` DATE;


-- DEALING WITH NULL AND BLANK VALUES
select *
from layoffs_stagging2
where total_laid_off is null and percentage_laid_off is null;

-- but the case scenario is occruing that for a same company there
-- are 2 rows one with industry as null another is conatinaing some values
-- on those rows we will fillup the same industry value to another values
select *
from layoffs_stagging2
where industry is null   -- this companies are having some null values
or industry=''; 

select * from layoffs_stagging2
where company='Airbnb';       -- here we can see that company=airbnb having 2 rows  one with null industry other 
-- as industry is not null so in this case company
--  so here we will fill the same value to both the places



-- here we will write a query to find whether the above scenario is happening with other companies or not.
select t1.company,t1.industry,t2.industry
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company=t2.company
    and t1.location=t2.location
where (t1.industry is null or t1.industry='')
and t2.industry is not null;
-- after running this query we find out that 3 companies are having the same problem
-- industry is blank in some row and industry not blank is some for the same comapany


-- first changing the ' ' values to null values
update layoffs_stagging2
set industry=null
where industry='';

-- solving the problem of null values in the col of industry
update layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null)
and t2.industry is not null;

-- there is only one company with industry is null
select *
from layoffs_stagging2
where industry is null   
or industry=''; 



-- checking whether there is any record with both
-- total layoff and percentage layoff as both as null
select *
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;



-- as this data set is for the layoffs occurred across different companies
-- in the different industry sectors
-- so as both the values(total layoff and percentage layoff) are null 
-- so we dont need that particular as they did not gave us any information about the layoffs
-- that is why we need to delete those data rows
delete
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;


-- viewing the clean data
select * from layoffs_stagging2;

-- removing the column row_num which we add for our refernce
alter table layoffs_stagging2
drop column row_num;


-- THAT'S IT WE ARE DONE WE THE DATA CLEANING PROCESS