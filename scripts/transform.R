#!/usr/bin/env Rscript

library(tidyverse)
library(sf)
library(terra)
library(stringr)
library(tidygeocoder)

main <- function() {

  readRDS('./data/processed/data_clean.RDS') -> data_clean

  data_clean$location_clean <- map_chr(data_clean$location, clean_location)

  data_clean %>%
    estimate_coordinates_from_location_description() %>%
    add_koppen_groups() %>%
    distinct(location_clean, .keep_all=TRUE) -> location_coordinates

  data_clean %>% 
    left_join(location_coordinates, by = "location_clean") %>%
    add_seasons() %>%
    mutate(
      minutes_from_midnight = (hour(time) * 60 + minute(time))*2*pi/1440,
      thunder_lightning = str_detect(tolower(summary), "thunder|lightning"),
      year = as.integer(year(date)),
      aboard = log(aboard+1),
      fatalities = log(fatalities+1),
      koppen = as.factor(koppen),
      season = as.factor(season),
      thunder_lightning = as.factor(thunder_lightning)) %>%
    select(
      minutes_from_midnight,
      year,
      aboard,
      fatalities,
      koppen,
      season,
      thunder_lightning) -> data_transformed

  data_transformed %>% saveRDS('./data/processed/data_transformed.RDS')
}




clean_location <- function(loc) {
  if (is.na(loc) || str_trim(loc) == "") return(NA_character_)
  
  loc <- str_remove_all(loc, "\\(.*?\\)")  # remove parentheses
  loc <- str_replace_all(loc, "[^A-Za-z0-9 ,./-]", " ")
  loc <- str_squish(loc)
  
  # Replace known directional patterns
  loc <- str_replace(loc, "^[0-9]+\\s*(mi|miles|km).*? (of|NE|NW|SE|SW) ", "")
  loc <- str_replace(loc, "^Near ", "")
  loc <- str_replace(loc, "^near ", "")
  loc <- str_replace(loc, "^Over ", "")
  loc <- str_replace(loc, "^over ", "")
  loc <- str_replace(loc, "^Off ", "")
  
  # Special handling for major oceans
  oceans <- c("Atlantic Ocean", "Pacific Ocean", "Indian Ocean",
              "Southern Ocean", "Arctic Ocean", "North Sea",
              "Baltic Sea", "Mediterranean Sea",
              "Caribbean Sea", "Gulf of Mexico")
  
  for (o in oceans) {
    if (str_detect(str_to_lower(loc), str_to_lower(o))) {
      return(o)
    }
  }
  
  return(loc)
}

get_season <- function(month, hemisphere) {
  if (is.na(hemisphere)) return(NA)
  if (hemisphere == "north") {
    if (month %in% c(12, 1, 2)) return("winter")
    if (month %in% c(3, 4, 5))  return("spring")
    if (month %in% c(6, 7, 8))  return("summer")
    if (month %in% c(9, 10, 11))return("autumn")
  } else {
    # southern hemisphere seasons are reversed
    if (month %in% c(12, 1, 2)) return("summer")
    if (month %in% c(3, 4, 5))  return("autumn")
    if (month %in% c(6, 7, 8))  return("winter")
    if (month %in% c(9, 10, 11))return("spring")
  }
}

estimate_coordinates_from_location_description <- function(data_clean) {
  # data_clean %>% 
  #   distinct(location_clean) %>% 
  #   filter(!is.na(location_clean)) %>%
  #   slice(4001:5000) -> unique_locs
  # unique_locs %>% 
  #   geocode(location_clean, method = "osm", lat = latitude, long = longitude, limit = 1, full_results = TRUE) %>% 
  #   saveRDS('./data/processed/geo_5.RDS')

  readRDS('./data/processed/geo_1.RDS') -> geo_1
  readRDS('./data/processed/geo_2.RDS') -> geo_2
  readRDS('./data/processed/geo_3.RDS') -> geo_3
  readRDS('./data/processed/geo_4.RDS') -> geo_4
  readRDS('./data/processed/geo_5.RDS') -> geo_5

  bind_rows(geo_1, geo_2, geo_3, geo_4, geo_5) -> geo

  ocean_centers <- tribble(
    ~location_clean,          ~latitude, ~longitude,
    "Atlantic Ocean",      0,        -30,
    "Pacific Ocean",       -10,      -140,
    "Indian Ocean",        -20,       90,
    "Southern Ocean",     -60,        0,
    "Arctic Ocean",        75,         0,
    "North Sea",           56,         3,
    "Baltic Sea",          57,        20,
    "Mediterranean Sea",   35,        18,
    "Caribbean Sea",       15,       -75,
    "Gulf of Mexico",      25,       -90
  )

  # geo <- geo %>% 
  #   rows_update(ocean_centers, by = "location_clean")

  bind_rows(select(geo, location_clean, latitude, longitude), ocean_centers) -> geo

  geo %>% drop_na(latitude, longitude) -> geo

  return(geo)
}

add_koppen_groups <- function(coordinates) {
  koppen_raster <- rast('./data/reference/Beck_KG_V1_future_0p5.tif')

  coordinates %>% st_as_sf(coords = c("longitude", "latitude"), crs = 4326) -> geo_sf
  coordinates$koppen_detailed <- terra::extract(koppen_raster, vect(geo_sf))[,2]

  coordinates$koppen_detailed %>% case_match(
  c(1:3) ~ "tropical",
  c(4:7) ~ "arid",
  c(8:16) ~ "temperate",
  c(17:28) ~ "cold",
  c(29:30) ~ "polar") -> coordinates$koppen

  coordinates %>%
    select(-koppen_detailed) %>%
    return()
}

add_seasons <- function(input_data) {
  input_data$hemisphere <- ifelse(input_data$latitude >= 0, "north", "south")
  month(input_data$date) -> input_data$month
  input_data$season <- mapply(get_season, input_data$month, input_data$hemisphere)

  return(input_data)
}



main()