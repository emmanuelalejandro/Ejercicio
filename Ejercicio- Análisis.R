
life_expectancy <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-12-05/life_expectancy.csv')
life_expectancy_different_ages <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-12-05/life_expectancy_different_ages.csv')
life_expectancy_female_male <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-12-05/life_expectancy_female_male.csv')

owid_energy <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-06/owid-energy.csv')

library(sqldf)
dataset <- sqldf("SELECT
    le.Entity,
    le.Code,
    le.Year,
    le.LifeExpectancy,
    oe.population,
    oe.gas_prod_per_capita
FROM
    life_expectancy le
JOIN
    owid_energy oe ON le.Code = oe.iso_code AND le.Year = oe.year;
      ")
data_2020 <- sqldf("SELECT*FROM dataset
                   WHERE Year=2020 AND gas_prod_per_capita IS NOT NULL
                   ")

library(ggplot2)
ggplot(data_2020, aes(x = data_2020$LifeExpectancy, y = data_2020$gas_prod_per_capita)) +
  geom_point() +
  labs(title = "Life Expectancy vs Gas Prod (2020)",
       x = "Life Expectancy",
       y = "gas prod")

Data_top10 <- sqldf("SELECT *
FROM data_2020
ORDER BY population DESC
LIMIT 10
")

library(ggplot2)

ggplot(Data_top10, aes(x = reorder(Entity, -population), y = population)) +
  geom_bar(stat = "identity", fill = "blue") +
  geom_point(aes(y = gas_prod_per_capita * 100000), color = "red") +
  labs(title = "Población vs. Producción de Gas por Cápita en 2020",
       x = "Entidad",
       y = "Población y Producción de Gas (1M)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





       