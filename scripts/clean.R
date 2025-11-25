library(tidyverse)
library(lubridate)

read.csv('data/raw/Airplane_Crashes_and_Fatalities_Since_1908.csv') %>% 
	as_tibble() -> data_raw


data_raw %>%
	mutate_if(is.character, ~na_if(., '')) %>%
	mutate(
		date = mdy(Date),
		time = hm(Time),
		location = Location,
		aboard = Aboard,
		fatalities = Fatalities,
		summary = Summary) %>% 
	select(
		date,
		time,
		location,
		aboard,
		fatalities,
		summary) -> data_clean

data_clean %>% saveRDS('./data/processed/data_clean.RDS')
