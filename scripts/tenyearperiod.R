library(tidyverse)
library(cowplot)

readRDS('./data/processed/data_clean.RDS') -> data_clean

data_clean %>% mutate(years_since_start = time_length(data_clean$date - origin, unit = "years")) %>% arrange(years_since_start) -> data_clean

nrow(data_clean) -> n
end <- max(data_clean$years_since_start)

max_interval_count <- 0
largest_interval <- NA
for (i in seq_len(n)) {
	interval_start = data_clean$years_since_start[i]
	interval_end = interval_start + 10

	if (interval_end > end) {
		break
	}

	vec_bool <- data_clean$years_since_start >= interval_start & data_clean$years_since_start <= interval_end
	if (max_interval_count < sum(vec_bool)) {
		max_interval_count = sum(vec_bool)
		largest_interval <- i
	}
}

print(max_interval_count)
print(largest_interval)
print(data_clean$date[largest_interval])
print(data_clean$date[largest_interval] + years(10))

data_clean %>% ggplot(aes(x=date)) + 
	geom_histogram() + 
	geom_vline(xintercept = data_clean$date[largest_interval], color = "red", linetype = "dashed", linewidth = 1) +
	geom_vline(xintercept = data_clean$date[largest_interval] + years(10), color = "red", linetype = "dashed", linewidth = 1) +
	theme_cowplot()



######################################

max_interval_count <- 0
largest_interval <- NA
for (i in seq_len(n)) {
	interval_start = data_clean$years_since_start[i]
	interval_end = interval_start + 10

	if (interval_end > end) {
		break
	}

	vec_bool <- data_clean$years_since_start >= interval_start & data_clean$years_since_start <= interval_end
	sum(data_clean$fatalities[vec_bool], na.rm=TRUE) -> interval_fatalities_count
	if (max_interval_count < interval_fatalities_count) {
		max_interval_count = interval_fatalities_count
		largest_interval <- i
	}
}

print(max_interval_count)
print(largest_interval)
print(data_clean$date[largest_interval])
print(data_clean$date[largest_interval] + years(10))

data_clean %>% ggplot(aes(x=date, y=aboard)) + 
	geom_point() + 
	geom_vline(xintercept = data_clean$date[largest_interval], color = "red", linetype = "dashed", linewidth = 1) +
	geom_vline(xintercept = data_clean$date[largest_interval] + years(10), color = "red", linetype = "dashed", linewidth = 1) +
	theme_cowplot()

####################################################


data_raw$Summary %>% tolower() -> summaries
str_detect(summaries, "thunder|lightning") -> data_raw$thunder_lightning

#####################################################

data_clean %>% filter(fatalities >= 500)