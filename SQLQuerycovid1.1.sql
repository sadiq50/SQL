select * from dbanalysisProjects.dbo.coviddeaths
order by 3,4


--select * 
--from dbanalysisProjects.dbo.covidvacinated
--order by 3,4

--data to be used

select location, date, new_cases, total_deaths, population
from dbanalysisProjects.dbo.coviddeaths
order by 1,2

--loking at newcasses vs population

select location, date, new_cases, population, (new_cases/population)*100 as positivepercentage
from dbanalysisProjects.dbo.coviddeaths
where location like '%island%'
order by 1,2

--looking at countries with highest new infection rate compared to population
select location, population, max(new_cases) as higestinfectioncount, max((new_cases/population))*100 as percentagepopulation
from dbanalysisProjects.dbo.coviddeaths
group by location, population
order by percentagepopulation desc

--sowing countries with hghest death count per population
select location, max(total_deaths) as Totaldeathcount
from dbanalysisProjects.dbo.coviddeaths
group by location
order by Totaldeathcount desc

--group by continent

select continent, max(total_deaths) as Totaldeathcount
from dbanalysisProjects.dbo.coviddeaths
group by continent 
order by Totaldeathcount desc

---Global numbers 

select continent, date, sum(new_cases) as Totalnew_casecount, sum(cast(new_deaths as int)) as Totaldeathcount
from dbanalysisProjects.dbo.coviddeaths
group by continent, date
order by 1,2 

--JOINS
select *
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date

---looking at total population vs new cases

select dea.continent, dea.location, dea.date, dea.population, vac.new_cases,
sum(cast(vac.new_cases as int)) over (partition by dea.location) 
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date
order by 2,3

---- same look using convert and int 
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases,
sum(convert(int, vac.new_cases)) over (partition by dea.location) 
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date
order by 2,3

---using order by location and date

select dea.continent, dea.location, dea.date, dea.population, vac.new_cases,
sum(convert(int, vac.new_cases)) over (partition by dea.location order by  dea.date) 
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date
order by 2,3


---use CTE (commn table expresion)
with popvsnewcases (continent, location, date, population, new_cases, rollingnewcases)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases,
sum(convert(int, vac.new_cases)) over (partition by dea.location order by  dea.date) rollingnewcases 
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date
--order by 2,3 
)
select*, (rollingnewcases/population)*100
from popvsnewcases

---Temp table

drop table if exists #percentpopulationofnewcases
create Table #percentpopulationofnewcases
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_cases numeric,
rollingnewcases numeric
)

insert into #percentpopulationofnewcases
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases,
sum(convert(int, vac.new_cases)) over (partition by dea.location order by  dea.date)as rollingnewcases
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date
--order by 2,3 
select*,(rollingnewcases/population)*100
from #percentpopulationofnewcases

---creating view for later visualization
--drop view  percentpopulationofnewcases

create view percentpopulationofnewcases as
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases,
sum(convert(int, vac.new_cases)) over (partition by dea.location order by  dea.date)as rollingnewcases
From dbanalysisProjects.dbo.coviddeaths dea
Join dbanalysisProjects.dbo.covidvacinated vac
on dea.location = vac.location
and dea.date =vac.date
--order by 2,3


---coudnt view from db but found it in master 
select top (1000)[continent]
[location],[date],[population],[new_cases],[rollingnewcases]
from[master].[dbo].[percentpopulationofnewcases] 


select * from percentpopulationofnewcases







