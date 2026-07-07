COVID-19 Data Exploration Project

# About the Project

This was one of my first bigger SQL projects. I wanted to work with real-world data and practice answering questions using SQL. I used a COVID-19 dataset from Our "World in Data" to explore infection rates, death rates, and how vaccination programmes rolled out across different countries.


# What I Explored

- How infection rates compared to population size in different countries
- Death rates over time, with a closer look at the UK
- Global totals for cases and deaths
- Vaccination progress and which countries had the highest vaccination coverage
- Rolling vaccination numbers using window functions

# Skills I Practised

- Writing more complex queries with multiple tables
- Using window functions to calculate running totals (like rolling vaccinations)
- Using CTEs to keep queries organised
- Building temporary tables
- Creating views that could be used later for dashboards
- Filtering and cleaning data properly before analysis

# Tools Used

- Window Functions
- Common Table Expressions (CTEs)
- Temporary Tables
- Views

# How to Run the Queries

1. Make sure you have the `covid_deaths` and `covid_vaccinations` tables loaded in your database.
2. Run the queries from top to bottom.
3. The views created at the end (`death_percentage` and `infection_rate`) can be queried directly and are useful if you want to connect the data to Power BI or Tableau.


This project was part of my journey learning data analysis from scratch.
