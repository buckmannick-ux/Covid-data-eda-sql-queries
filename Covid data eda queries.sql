SELECT*
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2;


-- Total cases vs population
-- This is the percentage of population that contracted Covid in UK

SELECT location, date, total_cases, population, (total_cases/ population)* 100 AS cases_percentage
FROM covid_deaths
WHERE location = 'United Kingdom'
ORDER BY 1,2;

-- Countries with highest infection rates over population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases/ population)* 100 AS population_infected_percentage
FROM covid_deaths
GROUP BY location, population
ORDER BY population_infected_percentage DESC;

-- Countries with the highest death count over population
SELECT location, population, MAX(total_deaths) AS highest_death_count, MAX(total_deaths/ population)* 100 AS deaths_over_population
FROM covid_deaths
WHERE continent IS NOT NULL
AND continent <> ''
GROUP BY location, population
ORDER BY highest_death_count DESC;

-- Continents ordered from the highest number of death count to the lowest
SELECT continent, MAX(total_deaths) AS highest_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
AND continent <> ''
GROUP BY continent
ORDER BY highest_death_count DESC;

-- Total cases vs total deaths
-- This shows how likely it was to die from covid in U.K.

SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)* 100 AS death_percentage
FROM covid_deaths
WHERE location = 'United Kingdom'
ORDER BY 1,2;

-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
AND continent<> ''
ORDER BY 1,2;
-- Total populations vs vaccinations 

WITH population_vaccinations (location, date, population, vaccinations, rolling_vaccinations) 
AS(
	SELECT d.location, d.date, d.population ,v.new_vaccinations, SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_vaccinations
	FROM covid_deaths d
	JOIN  covid_vaccinations v
		ON d.location = v.location
		AND d.date = v.date
		WHERE d.continent IS NOT NULL 
		AND d.continent <>''
	ORDER BY 1,2,3
    )
    SELECT *, rolling_vaccinations/ population *100 AS rolling_vaccination_percentage
    FROM population_vaccinations;
    
    WITH ranked_countries (location, population, tot_vaccinations) 
AS(
	SELECT d.location, d.population ,MAX(v.new_vaccinations) AS  tot_vaccinations
	FROM covid_deaths d
	JOIN  covid_vaccinations v
		ON d.location = v.location
		AND d.date = v.date
		WHERE d.continent IS NOT NULL 
		AND d.continent <>''
        GROUP BY d.location, d.population
	ORDER BY 1,2,3
    )
    SELECT *, tot_vaccinations/ population *100 AS vaccination_percentage
    FROM ranked_countries;
    
-- Countries ranked by number of vaccinations
    
  WITH countries_vacc_rank AS( 
   SELECT continent,location, MAX(total_vaccinations) AS total_vaccinations
    FROM covid_vaccinations
    GROUP BY continent,location
   )
   SELECT location, total_vaccinations, RANK() OVER(ORDER BY total_vaccinations DESC) AS vacc_rank
   FROM countries_vacc_rank
   WHERE continent IS NOT NULL
   AND continent <> ''
   ORDER BY vacc_rank;
   
   -- TEMP TABLE
   DROP TABLE IF EXISTS vaccinated_population;
   CREATE TABLE vaccinated_population
   (
   continent VARCHAR(255),
   location VARCHAR(255),
   date DATE,
   population BIGINT,
   new_vaccinations NUMERIC,
   rolling_vaccinations NUMERIC
   );
   
   INSERT INTO vaccinated_population
   SELECT d.continent, d.location, d.date, d.population ,v.new_vaccinations, SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_vaccinations
	FROM covid_deaths d
	JOIN  covid_vaccinations v
		ON d.location = v.location
		AND d.date = v.date
		WHERE d.continent IS NOT NULL 
		AND d.continent <>'';
	
    SELECT *, (rolling_vaccinations/ population *100) AS vaccination_percentage
    FROM vaccinated_population;
   
-- Creation of view (useful for creation of visualisations)
    
    CREATE VIEW death_percentage AS
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths * 100.0 / NULLIF(total_cases,0)),2) AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
AND continent <>'';
    
CREATE VIEW infection_rate AS
SELECT
    location,
    population,
    MAX(total_cases) AS case_count,
    MAX(total_cases * 100.0 / population) AS infection_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
AND continent <>''
GROUP BY location, population;
