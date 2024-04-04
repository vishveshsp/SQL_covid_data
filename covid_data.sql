--

-- SELECT *
-- FROM [portfolio proj]..deaths
-- ORDER By 3,4


-- SELECT *
-- FROM [portfolio proj]..vacs
-- ORDER By 3,4


--likelihood of dying by location.
 SELECT location,date,total_cases,total_deaths,population, (total_deaths/total_cases)*100 AS Percentage_of_deaths
 FROM [portfolio proj]..deaths
 WHERE [location] ='India'
 ORDER By 1,2

 --likelihood of a person contractiong covid, By location 

  SELECT location,date,population,total_cases, (total_cases/population)*100 AS Percentage_cases
 FROM [portfolio proj]..deaths
 WHERE [location] ='India'
 ORDER By 1,2


-- Highest infection rate wrt population
  SELECT location,population,MAX(total_cases) AS Highest_infection_rate, MAX(total_cases/population)*100 AS Percentage_cases
 FROM [portfolio proj]..deaths
 GROUP By Location , population
--  ORDER By 4 DESC
ORDER by 4 DESC

-- highest death rate wrt population 

  SELECT location,population,MAX(total_deaths) AS Highest_death_rate, MAX(total_deaths/population)*100 AS Percent_cases
 FROM [portfolio proj]..deaths
 Where continent is not null
 GROUP By Location , population
ORDER By 4 DESC
--ORDER by 3 DESC


--by continent

  SELECT continent,MAX(total_deaths) AS total_deaths
 FROM [portfolio proj]..deaths
 Where continent is not null
 GROUP By continent
 ORDER by 2 DESC

--by Denomination

  SELECT location,MAX(total_deaths) AS total_deaths
 FROM [portfolio proj]..deaths
 Where continent is null
 GROUP By location
 ORDER by 2 DESC

--Likelihood of dying wrt date
 SELECT date,SUM(new_cases) AS WWnew_cases,SUM(new_deaths) AS WWnew_deaths --(SUM(new_deaths)/SUM(new_cases))*100 AS Death_rate
 FROM [portfolio proj]..deaths
 WHERE continent is not null
 Group BY date
 ORDER By 1,2


--Likelihood of dying Worldwide
 SELECT SUM(new_cases) AS WWnew_cases,SUM(new_deaths) AS WWnew_deaths ,(SUM(new_deaths)/SUM(new_cases))*100 AS Death_rate
 FROM [portfolio proj]..deaths
 WHERE continent is not null

 ORDER By 1,2



-- Vaccinations_administered_till_date wrt location
With PopVSvacc (continent,location,date,population,new_vaccinations,Vaccinations_administered_till_date)
AS(
SELECT dea.continent, dea.[location],dea.[date],dea.[population], vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition BY dea.location order By dea.location,dea.date) AS Vaccinations_administered_till_date
FROM [portfolio proj]..vacs vac JOIN [portfolio proj]..deaths dea ON dea.[location] = vac.[location] AND dea.[date] = vac.[date]
where dea.continent is not null --AND dea.[location]= 'India'
--order by 1,2,3
)

SELECT*, (Vaccinations_administered_till_date/population)*100 As vac_percent
from PopVSvacc
