library(tidyverse)

readRDS('./data/processed/data_clean.RDS') -> data_clean
readRDS('./data/processed/data_transformed.RDS') -> data_transformed
readRDS('./data/processed/data_imputed.RDS') -> data_imputed

read.csv('./data/raw/Airplane_Crashes_and_Fatalities_Since_1908.csv') %>% as_tibble -> data_raw

data_raw %>% filter(Fatalities > 550) %>% glimpse

$ Date         <chr> "03/27/1977"
$ Time         <chr> "17:07"
$ Location     <chr> "Tenerife, Canary Islands"
$ Operator     <chr> "Pan American World Airways / KLM"
$ Flight..     <chr> "1736/4805"
$ Route        <chr> "Tenerife - Las Palmas / Tenerife - Las Palmas"
$ Type         <chr> "Boeing B-747-121 / Boeing B-747-206B"
$ Registration <chr> "N736PA/PH-BUF"
$ cn.In        <chr> "19643/11 / 20400/157"
$ Aboard       <int> 644
$ Fatalities   <int> 583
$ Ground       <int> 0
$ Summary      <chr> "Both aircraft were diverted to Tenerife because of a bom…


The Tenerife airoport disaster