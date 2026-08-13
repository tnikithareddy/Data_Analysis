SELECT * FROM niki.layoffs;
select * from layoff_stagging;


create  table  layoff_stagging like layoffs; 
select * from layoff_stagging;
insert layoff_stagging
select * from layoffs;

-- remove duplicates 

select *,row_number()over() num from layoff_stagging;

select *,row_number()over(partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)row_num
  from layoff_stagging;

with duplictae_cte as(
select *,row_number()over(partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)row_num
  from layoff_stagging
)
select * from duplictae_cte where row_num >1;

select * from layoff_stagging where company='casper';


CREATE TABLE `layoff_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoff_stagging2;
insert into layoff_stagging2
select *,row_number()over(partition by company,location, industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)row_num
from layoff_stagging;
  
  select * from layoff_stagging2
  where row_num>1;
  delete from layoff_stagging2 where row_num>1;

-- standardizing data

select * from layoff_stagging2;


select company,trim(company) from layoff_stagging2;
update layoff_stagging2
set company= trim(company);

select distinct industry from layoff_stagging2
order by 1;
select * from layoff_stagging2
where industry like 'crypt%';
update layoff_stagging2
set industry='Crypto'
where industry like 'Crypto%';

select distinct location from layoff_stagging2
order by 1;

select distinct country from layoff_stagging2
order by 1;
update layoff_stagging2
set country ='United States'
where country like "united states%";
update layoff_stagging2
set country= trim(trailing '.' from country);

select `date`,str_to_date(`date`,'%m/%d/%Y') from layoff_stagging2;
update layoff_stagging2
set `date`=str_to_date(`date`,'%m/%d/%Y');
alter table layoff_stagging2
modify column `date` date;

-- remove blank and null

select  * from layoff_stagging2
where total_laid_off is null and
percentage_laid_off is null;
delete from layoff_stagging2
where total_laid_off is null and
percentage_laid_off is null;


select  * from layoff_stagging2
where industry is null or 
industry ='';
select  * from layoff_stagging2
where company='Airbnb';
select  * from layoff_stagging2
where company='Carvana';
select  * from layoff_stagging2
where company='Juul';

update layoff_stagging2
set industry = null
where industry='';
select  l1.industry ,l2.industry from layoff_stagging2 l1 join 
layoff_stagging2 l2 on l1.company=l2.company 
where (l1.industry is null or l1.industry ='') and l2.industry is not null;

update layoff_stagging2 l1
join layoff_stagging2 l2 on l1.company=l2.company
set l1.industry=l2.industry 
where (l1.industry is null or l1.industry ='') and l2.industry is not null;

alter table layoff_stagging2
drop column row_num;











