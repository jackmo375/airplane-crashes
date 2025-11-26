# need to do consistency checks BEFORE imputation

library(tidyverse)

readRDS('./data/processed/data_clean.RDS') -> data_clean
readRDS('./data/processed/data_transformed.RDS') -> data_transformed
readRDS('./data/processed/data_imputed.RDS') -> data_imputed

read.csv('./data/raw/Airplane_Crashes_and_Fatalities_Since_1908.csv') %>% as_tibble -> data_raw

sample(1:5268, 1) -> x
data_transformed[x,] %>% glimpse
data_raw[x,] %>% glimpse
data_raw[x,]$Summary