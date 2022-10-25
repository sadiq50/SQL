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

