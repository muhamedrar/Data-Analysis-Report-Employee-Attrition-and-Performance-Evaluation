 -- DEFINE AND LOAD TABLES

CREATE TABLE PerformanceRating (
	PerformanceID VARCHAR(25) PRIMARY KEY ,
	EmployeeID varchar(25) REFERENCES employee(EmployeeID),
	ReviewDate date , 
	EnvironmentSatisfaction SMALLINT REFERENCES SatisfiedLevel(SatisfactionID) ,
	JobSatisfaction SMALLINT REFERENCES SatisfiedLevel(SatisfactionID) ,
	RelationshipSatisfaction SMALLINT REFERENCES SatisfiedLevel(SatisfactionID) ,
	TrainingOpportunitiesWithinYear SMALLINT ,
	TrainingOpportunitiesTaken SMALLINT ,
	WorkLifeBalance SMALLINT REFERENCES RatingLevel(RatingID) ,
	SelfRating SMALLINT REFERENCES RatingLevel(RatingID) ,
	ManagerRating SMALLINT REFERENCES RatingLevel(RatingID) 
);

COPY PerformanceRating
FROM 'F:\Desktop\self_study\data analysis\datasets\HR Analysis\PerformanceRating.csv'
with (format CSV , HEADER); 


---------------------------------------


CREATE TABLE EducationLevel (
	EducationLevelID SMALLINT  primary key ,
	EducationLevel varchar(25)
);

COPY EducationLevel
FROM 'F:\Desktop\self_study\data analysis\datasets\HR Analysis\EducationLevel.csv'
with (format CSV , HEADER);

----------------------------------------

CREATE TABLE employee(
	EmployeeID varchar(25) primary key ,
	firstName varchar(25) ,
	lastName varchar(25) ,
	gender varchar(50) not null ,
	age smallint ,
	businessTravel varchar(50) ,
	department varchar(50) ,
	distanceFromHome integer ,
	state  varchar(2) ,
	Ethnicity varchar(50) ,
	Education smallint,
	EducationField varchar(50) ,
	JobRole varchar(50) ,	
	MaritalStatus varchar(50) ,
	Salary integer ,
	StockOptionLevel smallint ,
	OverTime varchar(3) ,
	HireDate date ,
	Attrition varchar(3) ,
	YearsAtCompany smallint ,
	YearsInMostRecentRole smallint ,
	YearsSinceLastPromotion smallint ,
	YearsWithCurrManager smallint ,
	foreign key (Education)  references EducationLevel(EducationLevelID)
);

COPY employee
FROM 'F:\Desktop\self_study\data analysis\datasets\HR Analysis\Employee.csv'
with (format CSV , HEADER);

--------------------------------------

CREATE TABLE SatisfiedLevel(
	SatisfactionID SMALLINT PRIMARY KEY ,
	SatisfactionLevel varchar(25)

);

COPY SatisfiedLevel
FROM 'F:\Desktop\self_study\data analysis\datasets\HR Analysis\SatisfiedLevel.csv'
with (format CSV , HEADER);

--------------------------------------
CREATE TABLE RatingLevel(
	RatingID SMALLINT PRIMARY KEY ,
	RatingLevel varchar(50)
);


COPY RatingLevel
FROM 'F:\Desktop\self_study\data analysis\datasets\HR Analysis\RatingLevel.csv'
with (format CSV , HEADER);
---------------------------------------


------- inspecting tables      
select * from employee limit 3;      
select * from EducationLevel limit 3;
select * from PerformanceRating limit 3;
select * from SatisfiedLevel limit 3;
select * from RatingLevel limit 3;


      

-----

------------check for duplicates

select * , count(*) 
from employee
group by 
	EmployeeID   ,
	firstName  ,
	lastName  ,
	gender   ,
	age  ,
	businessTravel  ,
	department ,
	distanceFromHome  ,
	state   ,
	Ethnicity  ,
	Education ,
	EducationField  ,
	JobRole ,	
	MaritalStatus  ,
	Salary  ,
	StockOptionLevel  ,
	OverTime  ,
	HireDate  ,
	Attrition  ,
	YearsAtCompany  ,
	YearsInMostRecentRole  ,
	YearsSinceLastPromotion  ,
	YearsWithCurrManager  
having count(*) > 1 ; 


select  * ,count(*)
from PerformanceRating
group by 
	PerformanceID  ,
	EmployeeID ,
	ReviewDate  , 
	EnvironmentSatisfaction  ,
	JobSatisfaction  ,
	RelationshipSatisfaction ,
	TrainingOpportunitiesWithinYear  ,
	TrainingOpportunitiesTaken  ,
	WorkLifeBalance  ,
	SelfRating ,
	ManagerRating 
having count(*) >1 ;
----------------------------------
-------checling for null values
SELECT * FROM employee WHERE NOT (employee IS NOT NULL);

SELECT * FROM PerformanceRating WHERE NOT (PerformanceRating IS NOT NULL);





------- -----------------------------------Attrition Analysis-----------------------------------------

select count(attrition)
from employee
where attrition = 'Yes';

create or replace view ex_employee as (
	select *
	from employee
	where attrition = 'Yes'
);



with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes')
select gender  , concat((count(*)::integer *100/(select * from ex_employee_count) )::text , '%' ) as ex_employee_rate
from ex_employee
group by gender 
order by count(*) desc;


---lets check their ages
select min(age) , max(age) from employee; -- so the ages between 18-48




with ex_employee_count as(
	select count(attrition)
	from employee)
select case 
			WHEN age BETWEEN 18 AND 29 THEN '18-29'
        	WHEN age BETWEEN 30 AND 39 THEN '30-39'
        	WHEN age BETWEEN 40 AND 51 THEN '40-51'
		end as Age_ranges ,
	concat((count(*)::integer *100/(select * from ex_employee_count) )::text , '%' ) as ex_employee_rate
from employee
group by Age_ranges 
order by count(*) desc;
-----64% rate age between 18-19 of all employees , 19% for range 30-39 and 15% for range 40-51


with ex_employee_count as(
	select count(attrition)
	from ex_employee)
select 
		case 
			WHEN age BETWEEN 18 AND 29 THEN '18-29'
        	WHEN age BETWEEN 30 AND 39 THEN '30-39'
        	WHEN age BETWEEN 40 AND 51 THEN '40-51'
		end as Age_ranges ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
group by Age_ranges
order by  count(*) desc;----- 82% rate age between 18-19 of ex_employee (very high ratio) ,
							-- 11% for range 18-29 and 6% for (40-51)



-----------------gender-----------------------
select gender   , count(*) as ex_employee_count
from ex_employee
group by gender 
order by count(*) desc; -----  the gender not a good factor ,Males and Females ratio are so close in 


with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' 
)
select MaritalStatus , concat((count(*)::integer *100/(select * from ex_employee_count) )::text , '%' ) as ex_employee_rate 
from ex_employee 

group by MaritalStatus 
order by count(*) desc; --The Single people acheived high rate with 54% 





------------ -----------------------------------
with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' 
)
select jobrole ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
group by jobrole 
order by count(*) desc; ---The most noticeable rates for ex_employee roles is (Data Scientist with 26% ,
																				-- Sales Executive  with 24% ,
																				-- Software Engineer with 19% ,
																				-- Sales Representative with 13% )


with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes')
select department ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
group by department 
order by count(*) desc; --- The Technology and Sales dapartments acheived high rates with 56% , 38%






----- checking the overtime in each department (Technology , Sales)
with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' 
)
select  department, overtime ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
where overtime = 'Yes'
group by overtime ,department
order by count(*) desc;



with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' and department = 'Sales'
)
select  department, overtime ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
where department = 'Sales'
group by overtime ,department
order by count(*) desc;-------- the employees with overtime are a little higher 



-------checking The state in which the employee resides with higher ex_employee_rate

with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' )
select state ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
group by state 
order by count(*) desc; ----- California(CA) is much higher with rate 63%


 


----------
with ex_employee_count as(
	select count(attrition)
	from ex_employee
	where age between 18 and 29
	)
select state , 
		case 
			WHEN age BETWEEN 18 AND 29 THEN '18-29'
        	WHEN age BETWEEN 30 AND 39 THEN '30-39'
        	WHEN age BETWEEN 40 AND 48 THEN '40-48'
		end as Age_ranges ,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
where age between 18 and 29
group by state ,Age_ranges
order by  count(*) desc;----- for age range between(18-19) which represents 82% of the ex_employee
										--there is 63% of them from California(CA)
										-- 25% from New York (NY) and 11% for Illinois (IL)


----------------------------businesstravel-------------------------



with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' 
)
select businesstravel , jobrole,
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 
where jobrole = 'Data Scientist'
group by businesstravel ,jobrole
order by count(*) desc ;
--for all the data set there is 70% some travel , 18% and 10% for Frequent Traveller and No Travel ,
--- but for ex_employees there are some differences:
---- some travel 65%, 29% and 5% for Frequent Traveller and No Travel
---so ex_employees increased by 11% or Frequent Travelling 

-------------------------------------------------------------------------------------

with ex_employee_count as(
	select count(*)
	from ex_employee
	)
select stockoptionlevel , 
		concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )   as ex_employee_rate 
from ex_employee 	
group by stockoptionlevel 
order by count(*) desc ;
--64% from ex_employee with stockoptionlevel (0)


----------------------------distancefromhome--------------------

select min(distancefromhome) , max(distancefromhome) from ex_employee;

with ex_employee_count as(
	select count(attrition)
	from employee
	where attrition = 'Yes' 
)
select case 
			WHEN distancefromhome BETWEEN 1 AND 19 THEN '1-19'
        	WHEN distancefromhome BETWEEN 20 AND 35 THEN '20-35'
        	WHEN distancefromhome BETWEEN 36 AND 45 THEN '36-45'
		end as distancefromhome_ranges ,
	concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )
from ex_employee
group by distancefromhome_ranges 
order by count(*) desc ;
-- the ratios is a little higher that the ratios for all data set 



----------------------------------overtime-----------------------
with ex_employee_count as(
	select count(attrition)
	from ex_employee
	 
)
select overtime,
	concat( (count(*)::integer *100/(select * from ex_employee_count) )::text , '%' )
from ex_employee
group by overtime
order by count(*) desc ; --- for the dataset the ratios for emoloyees with overtime and not are 71% , 29%
								-- and for ex_employee 53% and 46% which means that ex_employee with no overtime are likely to leave



----------------------------------------------------------Performance & Satisfaction Correlation------------------------------------

select EnvironmentSatisfaction  ,
	JobSatisfaction  ,
	RelationshipSatisfaction ,
	WorkLifeBalance  ,
	SelfRating ,
	ManagerRating 
from performancerating;


--Are self-ratings aligned with manager ratings?

SELECT 
 round(AVG(selfRating),2) AS selfRating, 
 round (AVG(ManagerRating),2 )AS AvgManagerRating , 
 corr(selfRating,ManagerRating) as the_correlation 
FROM performancerating;
-- Average Self-Rating (3.98) vs. Average Manager Rating (3.47):
-- The average self-rating is higher than the average manager rating. This could suggest that employees tend to rate themselves more favorably than their managers do.
-- Correlation (0.854):
-- The correlation coefficient is quite high at 0.854, indicating a strong positive correlation between self-ratings and manager ratings.
-- This means that when employees rate themselves highly, managers also tend to rate them relatively high, and vice versa. However, the gap between the actual rating values suggests a consistent difference in perception.





--How do job satisfaction and environment satisfaction correlate with performance ratings?

select * from satisfiedlevel;
select distinct ratinglevel from ratinglevel;




SELECT 
 round(AVG(EnvironmentSatisfaction),2) AS avg_EnvironmentSatisfaction, 
 round (AVG(JobSatisfaction),2 )AS avg_JobSatisfaction ,
 round (AVG(RelationshipSatisfaction),2 )AS avg_RelationshipSatisfaction ,	
 round (AVG(ManagerRating),2 )AS avg_ManagerRating	
FROM performancerating;	




with avg_overall_emp_Satisfaction as(
	select round(AVG((JobSatisfaction+RelationshipSatisfaction+EnvironmentSatisfaction)/3),2)AS avg_overall_emp_Satisfaction     
	FROM performancerating
)
SELECT 
 (select * from avg_overall_emp_Satisfaction) ,	
 round(AVG(ManagerRating),2 )AS avg_ManagerRating	,
 corr((select * from avg_overall_emp_Satisfaction),ManagerRating) as the_correlation 
FROM performancerating;	
-- When combining job satisfaction, environment satisfaction, and relationship satisfaction 
-- into an overall satisfaction score (3.24), the correlation with manager ratings is nearly zero (-0.008). 
-- This indicates almost no linear relationship between overall employee satisfaction and manager ratings.



---How do training opportunities impact employee performance?
--TrainingOpportunitiesWithinYear
select    
		TrainingOpportunitiesTaken , count(*)  
from performancerating 
group by TrainingOpportunitiesTaken
order by count(*) desc; 


select corr(TrainingOpportunitiesTaken , ManagerRating)
from performancerating;
---- no corr


select distinct extract(year from reviewdate) as year
from performancerating order by  extract(year from reviewdate) desc; -- so the performancerating review was in 
-- 2024 2023 2022 2021 2020 2019 2018 2017 2016 2015 2014 2013


alter table performancerating 
add column review_year int ;

UPDATE performancerating
SET review_year = EXTRACT(YEAR FROM reviewdate);

--check performancerating through years

select review_year , ManagerRating,count(ManagerRating)
from employee join performancerating
on employee.employeeid = performancerating.employeeid
group by review_year ,ManagerRating
order by review_year,ManagerRating; 


select review_year , sum(managerrating)/count(*) as performance_score 
from employee join performancerating
on employee.employeeid = performancerating.employeeid
group by review_year 
order by review_year;  
-- it seems that the overall performance is the same for employees in each year


  




