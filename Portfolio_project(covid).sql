
--data exploration
select "location" , "date" ,total_cases ,new_cases ,total_deaths , population 
from CovidDeath
order by 1,2

--deathPercent for Kazakhstan
select "location" , "date",total_cases,total_deaths , (total_deaths/total_cases)*100 as DeathPercent 
from CovidDeath
where "location" like '%Kaz%' and continent is not null
order by 1,2

--infectionPercent for Kazakhstan
select "location" , "date",total_cases,population , (total_cases/population)*100 as InfectionPercent 
from CovidDeath
where "location" like '%Kaz%' and continent is not null
order by 1,2

--location InfectionPercent
select "location", population,DATEPART(YYYY,"date") as "Year", max(total_cases) as MaxInfectionCount ,Max(total_cases/population)*100 as MaxInfectionPercent 
from CovidDeath
where continent is not null
group by "location", population,DATEPART(YYYY,"date")
order by 5 desc

--Location deaths_count 
select "location",DATEPART(YYYY,"date") as "Year", population, max(cast(total_deaths as int)) as DeathsCount ,Max(total_deaths/population)*100 as DeathsPercent 
from CovidDeath
where continent is not null
group by "location", population,DATEPART(YYYY,"date")
order by 4 desc,5 desc 

--Continent deaths_count
select location, max(cast(total_deaths as int)) as DeathsCount 
from CovidDeath
where continent is null
group by location
order by 2 desc


--rolling PercentVaccinations value
select *, (SumNewVaccinations/population)*100 as PercentVac
from(
select cd.continent,
		cd.location,
		cd.date,
		cd.population,
		new_vaccinations,
		sum(convert(decimal,cv.new_vaccinations)) over (partition by cd.location order by cd.date,cd.location) as SumNewVaccinations
from CovidDeath cd join CovidVaccinations cv on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
) t
order by 2,3
