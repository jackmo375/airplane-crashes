library(tidyverse)
library(cowplot)

readRDS('./data/processed/data_imputed.RDS') -> data_imputed

start_year <- min(data_imputed$year)
end_year <- max(data_imputed$year)
n <- nrow(data_imputed)

data_imputed %>% mutate(years_since_start = year - start_year) -> data_imputed

max_interval_count <- 0
largest_interval <- NA
for (i in seq_len(n)) {
	interval_start = data_imputed$years_since_start[i]
	interval_end = interval_start + 10

	if (interval_end > end_year) {
		break
	}

	vec_bool <- data_imputed$years_since_start >= interval_start & data_imputed$years_since_start <= interval_end
	if (max_interval_count < sum(vec_bool)) {
		max_interval_count = sum(vec_bool)
		largest_interval <- i
	}
}

print(max_interval_count)
print(largest_interval)
print(data_imputed$year[largest_interval])
print(data_imputed$year[largest_interval] + 10)

data_imputed %>% 
	ggplot(aes(x=year)) + 
		geom_histogram() + 
		geom_vline(xintercept = data_imputed$year[largest_interval], color = "red", linetype = "dashed", linewidth = 1) +
		geom_vline(xintercept = data_imputed$year[largest_interval] + 10, color = "red", linetype = "dashed", linewidth = 1) +
		theme_cowplot()
ggsave('./results/most_crashes.png')

#######################################

max_interval_count <- 0
largest_interval <- NA
for (i in seq_len(n)) {
	interval_start = data_imputed$years_since_start[i]
	interval_end = interval_start + 10

	if (interval_end > end_year) {
		break
	}

	vec_bool <- data_imputed$years_since_start >= interval_start & data_imputed$years_since_start <= interval_end
	sum(exp(data_imputed$fatalities[vec_bool])-1, na.rm=TRUE) -> interval_fatalities_count
	if (max_interval_count < interval_fatalities_count) {
		max_interval_count = interval_fatalities_count
		largest_interval <- i
	}
}

print(max_interval_count)
print(largest_interval)
print(data_imputed$year[largest_interval])
print(data_imputed$year[largest_interval] + 10)

data_imputed %>%
	mutate(fatalities = as.integer(exp(fatalities)-1)) %>%
	ggplot(aes(x=year, y=fatalities)) + 
		geom_point() + 
		geom_vline(xintercept = data_imputed$year[largest_interval], color = "red", linetype = "dashed", linewidth = 1) +
		geom_vline(xintercept = data_imputed$year[largest_interval] + 10, color = "red", linetype = "dashed", linewidth = 1) +
		theme_cowplot()

ggsave('./results/most_fatalities.png')



#####################################

data_imputed %>% filter(thunder_lightning == TRUE) -> data_imputed_thunder

max_interval_count <- 0
largest_interval <- NA
for (i in seq_len(n)) {
	interval_start = data_imputed_thunder$years_since_start[i]
	interval_end = interval_start + 10

	if (interval_end > end_year) {
		break
	}

	vec_bool <- data_imputed_thunder$years_since_start >= interval_start & data_imputed_thunder$years_since_start <= interval_end
	if (max_interval_count < sum(vec_bool)) {
		max_interval_count = sum(vec_bool)
		largest_interval <- i
	}
}

print(max_interval_count)
print(largest_interval)
print(data_imputed_thunder$year[largest_interval])
print(data_imputed_thunder$year[largest_interval] + 10)

data_imputed_thunder %>% 
	ggplot(aes(x=year)) + 
		geom_histogram() + 
		geom_vline(xintercept = data_imputed_thunder$year[largest_interval], color = "red", linetype = "dashed", linewidth = 1) +
		geom_vline(xintercept = data_imputed_thunder$year[largest_interval] + 10, color = "red", linetype = "dashed", linewidth = 1) +
		theme_cowplot()

ggsave('./results/most_storms.png')



#############################################

data_clean %>% filter(fatalities >= 500)