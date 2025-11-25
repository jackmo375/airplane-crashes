############################################
# Assign Köppen climate zone to crash locations
# Option A: automatic fuzzy geocoding
############################################

library(tidyverse)
library(sf)
library(terra)
library(stringr)
library(tidygeocoder)

df <- read_csv("data/Airplane_Crashes_and_Fatalities_Since_1908.csv")

# -----------------------------------------
# 2. Helper: Clean & parse location strings
# -----------------------------------------
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

df$loc_clean <- map_chr(df$Location, clean_location)

# -----------------------------------------
# 3. Geocode unique clean locations
# -----------------------------------------
df %>% 
  distinct(loc_clean) %>% 
  filter(!is.na(loc_clean)) -> unique_locs

# Geocode using Nominatim (OpenStreetMap)
# Rate limits automatically respected by tidygeocoder
geo <- unique_locs %>% 
  geocode(loc_clean, method = "osm", lat = latitude, long = longitude, 
          limit = 1, full_results = TRUE)

# -----------------------------------------
# 4. Manually assign coordinates for oceans
# -----------------------------------------
ocean_centers <- tribble(
  ~loc_clean,          ~latitude, ~longitude,
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

geo <- geo %>% 
  rows_update(ocean_centers, by = "loc_clean")

# -----------------------------------------
# 5. Load Köppen Classification Raster
# -----------------------------------------
# Use Beck et al. (2018) global Koppen raster (1 km)
# Download once from: https://www.gloh2o.org/koppen/
# Example file name:
koppen_raster <- rast("Koppen_Geiger_Climate_Map.tif")

# -----------------------------------------
# 6. Convert geocoded points to sf and extract climate zone
# -----------------------------------------
geo_sf <- geo %>% 
  drop_na(latitude, longitude) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# Extract climate class
geo$koppen <- terra::extract(koppen_raster, vect(geo_sf))[,2]

# -----------------------------------------
# 7. Merge back onto original crash dataset
# -----------------------------------------
df_final <- df %>% 
  left_join(geo %>% select(loc_clean, koppen), by = "loc_clean")

# -----------------------------------------
# 8. Write output
# -----------------------------------------
write_csv(df_final, "Airplane_Crashes_with_Koppen.csv")