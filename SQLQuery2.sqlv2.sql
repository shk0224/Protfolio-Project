Select * 
From ProtfolioProject..CovidDeath
order by 3,4

--Select * 
--From ProtfolioProject..CovidVaccination
--order by 3,4

Select Location, date,total_cases, new_cases,total_deaths,population
From ProtfolioProject..CovidDeath
order by 1,2

--Looking at total caese and total death

select location, date,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From ProtfolioProject.. CovidDeath
where location like '%states%'
order by 1,2

--Looking at the total cases vs population:
--shows what percent of population got covid

select location, date,population, total_cases,(total_cases/population)*100 as Percentofpopulationinfected
From ProtfolioProject.. CovidDeath
--where location like '%states%'
order by 1,2

--Looking at the countries at highest infection rate compare to the population
select location,population,MAX(total_cases)as highest_infection_count,MAX((total_cases/population))*100 as Percentofpopulationinfected
From ProtfolioProject.. CovidDeath
--where location like '%states%'
group by Location,population
order by Percentofpopulationinfected desc


--showing country highest death count per population

select location ,max(cast(Total_deaths as int)) as totaldeathcount
From ProtfolioProject.. CovidDeath
--where location like '%states%'
where continent is not null
group by location
order by totaldeathcount desc

--Lets break things by continent
-- showing continent with the highest death count per popualation

select continent, max(cast(total_deaths as int)) as totaldeathcount
From ProtfolioProject.. CovidDeath
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc

--Global numbers

select sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 
as DeathPercentage
From ProtfolioProject.. CovidDeath
--where location like '%states%'
where continent is not null
order by 1,2

--looking the total population vs vaccination
select dea.continent, dea.location, dea.date,vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations)) OVER
(Partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
From ProtfolioProject.. CovidDeath dea
Join ProtfolioProject..CovidVaccination vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by 2,3

--USE CTE
With PopvsVac (Continent,Location,Date,Population,New_vaccinations, RollingPeopleVaccinated) as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations)) OVER
(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
From ProtfolioProject.. CovidDeath dea
Join ProtfolioProject..CovidVaccination vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	--order by 2,3
)
select *,(Rollingpeoplevaccinated/population)*100
From PopvsVac

--Temp table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Data datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations)) OVER
(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
From ProtfolioProject.. CovidDeath dea
Join ProtfolioProject..CovidVaccination vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	--order by 2,3

select *,(Rollingpeoplevaccinated/population)*100
From #PercentPopulationVaccinated

--Creating view to store data for later visualization
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(convert(int, vac.new_vaccinations)) OVER
(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
From ProtfolioProject.. CovidDeath dea
Join ProtfolioProject..CovidVaccination vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select * from PercentPopulationVaccinated

























































