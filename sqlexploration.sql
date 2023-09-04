-- I create schema (database) and create a database and I call it 'paul'.
-- Next, I import the CSV files to this database as tables.
-- Answering questions with SQL to conduct exploratory data analysis.

Use [paul];
select* from [accident]
select* from [vehicle1]


--Question 1: How many accident have occured in urban areas versus rural areas?
SELECT 
   [Area],
   Count(AccidentIndex) AS 'Total Accident'
From
   [accident]
Group by
   [Area];


-- Question 2: Which day of the week has the highest number of accident?
SELECT 
   [Day],
   Count(AccidentIndex) AS 'Total Accident'
From
   [accident]
Group by
   [Day];


--Question 3: What is the average age of vehicles involved in accident based on their type?
SELECT 
   [VehicleType],
   Count(AccidentIndex) AS 'Total Accident',
   avg(AgeVehicle) AS 'Average Year'
From
   [vehicle1]
Where 
   [AgeVehicle]is not null
Group by
   [VehicleType]
Order by
   'Total Accident'Desc;


--Question 4: Can we identify any trends in accidents based on the age of vehicle involved?
SELECT
   AgeGroup,
   COUNT([AccidentIndex]) AS 'Total Accident',
   AVG([AgeVehicle]) AS 'Average year'
From(
   select
     [AccidentIndex],
     [AgeVehicle],
     CASE
         WHEN[AgeVehicle]Between 0 and 5 Then 'New'
	     WHEN [AgeVehicle] Between 6 and 10 Then 'Regular'
	     ELSE 'Old'
     End as 'AgeGroup'
   From[vehicle1]
)  AS SubQuery
Group by
   [AgeGroup]
;


-- Question 5: Are there any specific weather conditions that contribute to severe accident?
Declare @Severity varchar(100)
SET @Severity = 'Slight'

SELECT 
   [WeatherConditions],
   Count(Severity) AS 'Total Accident'
From
   [accident]
--Where
   --[Severity] = @Severity
Group by
   [WeatherConditions]
Order by
   'Total Accident'Desc
;


-- Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
Select
   LeftHand,
   COUNT(AccidentIndex) AS 'Total Accident'
From
   vehicle1
Group by
   LeftHand
Having
   LeftHand is not null
;


-- Question 7: Are there any relationships between journey purpose and the severity of accident?
Select
   vehicle1.JourneyPurpose,
   COUNT(accident.Severity) AS 'Total Accident',
   CASE 
      When COUNT(accident.Severity) Between 0 and 1000 then 'Low'
	  When COUNT(accident.Severity) Between 1001 and 3000 then 'Moderate'
	  Else 'High'
   End As 'level'
From
   accident
Join
   vehicle1
   on vehicle1.AccidentIndex = accident.AccidentIndex
Group by
   vehicle1.JourneyPurpose
Order by
   'Total Accident' DESC
;


-- Question 8: Calculate the average age of vehicles involved in accidents, considering Day light and point of impact.
Select
   accident.LightConditions,
   vehicle1.PointImpact,
   AVG(vehicle1.Agevehicle) as 'Average Year'
From
   accident
Join
   vehicle1
   on vehicle1.AccidentIndex = accident.AccidentIndex
Group by
   accident.LightConditions,
   vehicle1.PointImpact
   ;
