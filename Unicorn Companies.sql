create database unicorn_companies;
use unicorn_companies;

/* 
Investing in stocks has the potential to provide an average annual return of around 10%, as indicated by the S&P 500 index.
However, it's important to recognize that this seemingly attractive figure is somewhat offset by the impact of inflation. 
In reality, investors may actually experience a decrease in purchasing power of approximately 2% to 3% each year when considering the effects of inflation. 
So, while the average return may appear promising, it's essential to account for inflation's erosion of real returns. */
 
 /* You are tasked with helping an investment firm by conducting an analysis of high-growth company trends. 
 The goal is to identify industries with the highest valuations and determine the rate at which new high-value companies are emerging. 
 This information will provide the firm with valuable insights into current industry trends and guide their portfolio structuring for future investments.

To facilitate this analysis, you have been granted access to the unique unicorns database, 
which includes comprehensive tables for extracting the required data and conducting a thorough assessment of the evolving landscape of high-growth companies and industries. */

select * 
from companies
limit 5;

select * 
from dates 
limit 5;

select *
from funding 
limit 5;

select * 
from industries 
limit 5;


/*  3 best-performing industries based on the number of new unicorns created over three years (2019, 2020, and 2021) combined. */ 

SELECT i.industry, COUNT(i.company_id) AS count_new_unicorns
FROM industries i
JOIN dates d ON i.company_id = d.company_id
WHERE EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
GROUP BY i.industry
ORDER BY count_new_unicorns DESC
LIMIT 3;

/*  Number of unicorns and the average valuation, grouped by year and industry. */

SELECT i.industry, EXTRACT(YEAR FROM d.date_joined) AS year, COUNT(i.company_id) AS num_unicorns, AVG(f.valuation) AS average_valuation
FROM industries i
JOIN dates d ON i.company_id = d.company_id
JOIN funding f ON d.company_id = f.company_id
GROUP BY i.industry, year
ORDER BY average_valuation desc
limit 5;

/* Create 2 CTEs for 2 two tables above and run */

WITH top_industries AS (
	SELECT 
    	i.industry, 
        COUNT(i.company_id) AS num_companies
    FROM industries AS i
    JOIN dates AS d
        ON i.company_id = d.company_id
    WHERE EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY industry
    ORDER BY num_companies DESC
    LIMIT 3
),

yearly_ranks AS 
(
    SELECT 
    	COUNT(i.company_id) AS num_unicorns,
        i.industry,
        EXTRACT(YEAR FROM d.date_joined) AS year,
        AVG(f.valuation) AS average_valuation
    FROM industries AS i
    JOIN dates AS d
        ON i.company_id = d.company_id
    JOIN funding AS f
        ON d.company_id = f.company_id
    GROUP BY industry, year
)

SELECT 
	industry,
    year,
    num_unicorns,
    ROUND(AVG(average_valuation / 1000000000), 2) AS average_valuation_billions
FROM yearly_ranks
WHERE year in (2019, 2020, 2021)
	AND industry in (SELECT industry FROM top_industries)
GROUP BY industry, year, num_unicorns
ORDER BY industry, year DESC;

