# Ejercicio - Habilidades Técnicas

En el presente documento detallo los pasos realizados para la resolución del ejercicio propuesto. Se utilizó RStudio para la resolución con librerias de sqllite y ggplot2

## Extracción de datos

Utilice dos bases de datos dentros del repositorio de github brindados. Life expectancy y owid_energy

```bash
life_expectancy <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-12-05/life_expectancy.csv')

owid_energy <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-06/owid-energy.csv')

```

## Trasformacion de datos
Con la finalidad de analizar si la produccion de gas per capita contiene alguna relacion con la expectativa de vida, se relacionaron las dos tabla teniendo en cuenta localidad y año. 

```sql
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
```
Analicé el 2020 y retire los datos nulos

```sql
data_2020 <- sqldf("SELECT*FROM dataset
                   WHERE Year=2020 AND gas_prod_per_capita IS NOT NULL
                   ")
```
## Gráficos

Realicé un scatter plot para ver la relación de Life Expectancy vs Gas Prod (2020)
```r
library(ggplot2)
ggplot(data_2020, aes(x = data_2020$LifeExpectancy, y = data_2020$gas_prod_per_capita)) +
  geom_point() +
  labs(title = "Life Expectancy vs Gas Prod (2020)",
       x = "Life Expectancy",
       y = "gas prod")
```
Luego realicé un top10 para analizar population con gas prod del 2020 

```sql
Data_top10 <- sqldf("SELECT *
FROM data_2020
ORDER BY population DESC
LIMIT 10
")
```
Con el top10 realice un grafico de barras y puntos con la finalidad de visualizar la relación.

```r
library(ggplot2)

ggplot(Data_top10, aes(x = reorder(Entity, -population), y = population)) +
  geom_bar(stat = "identity", fill = "blue") +
  geom_point(aes(y = gas_prod_per_capita * 100000), color = "red") +
  labs(title = "Población vs. Producción de Gas por Cápita en 2020",
       x = "Entidad",
       y = "Población y Producción de Gas (1M)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```
## Autor
Emmanuel Álvarez
