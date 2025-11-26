library(tidyverse)
library(cowplot)


readRDS('./data/processed/data_imputed.RDS') %>%
  mutate(time = minutes_from_midnight*24/2/pi) -> data_imputed

df <- data_imputed %>% 
  mutate(angle_bin = cut(minutes_from_midnight * 180 / pi, breaks = seq(0, 360, by = 20)))

df %>%
  filter(!is.na(angle_bin)) %>%
  ggplot(aes(angle_bin)) +
    geom_bar(fill = "skyblue") +
    coord_polar() +
    theme_minimal() +
    theme(
      axis.text  = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank())

ggsave('./results/main_circ_hist.png')



df %>%
  filter(!is.na(angle_bin)) %>%
  filter(season == 'autumn' & koppen == 'tropical') %>%
  ggplot(aes(angle_bin)) +
    geom_bar(fill = "skyblue") +
    coord_polar() +
    theme_minimal() +
    theme(
      axis.text  = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank())

ggsave('./results/autumn_tropic.png')

df %>%
  filter(!is.na(angle_bin)) %>%
  filter(season == 'autumn' & koppen == 'arid') %>%
  ggplot(aes(angle_bin)) +
    geom_bar(fill = "skyblue") +
    coord_polar() +
    theme_minimal() +
    theme(
      axis.text  = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank())

ggsave('./results/autumn_arid.png')

df %>%
  filter(!is.na(angle_bin)) %>%
  filter(season == 'spring' & koppen == 'arid') %>%
  ggplot(aes(angle_bin)) +
    geom_bar(fill = "skyblue") +
    coord_polar() +
    theme_minimal() +
    theme(
      axis.text  = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank())

ggsave('./results/spring_arid.png')

df %>%
  filter(!is.na(angle_bin)) %>%
  filter(season == 'spring' & koppen == 'arid') %>%
  ggplot(aes(angle_bin)) +
    geom_bar(fill = "skyblue") +
    theme_minimal()

data_clean %>% ggplot(aes(x=hour(time) + minute(time)/60)) + geom_histogram()




data_imputed %>% filter(time <= 24) %>% ggplot(aes(x=time)) + geom_histogram(bins=12) + theme_cowplot()
ggsave('./results/main_time_hist.png')

data_imputed %>% filter(time <= 24) %>% ggplot(aes(x=time)) + geom_histogram(bins=12) + coord_polar() + theme_cowplot()
ggsave('./results/main_time_hist_circ.png')

data_imputed %>% filter(time <= 24 & season == 'autumn' & koppen == 'arid') %>% ggplot(aes(x=time)) + geom_histogram(bins=12) + coord_polar()
ggsave('./results/time_hist_autumn_arid_circ.png')

data_imputed %>% filter(time <= 24 & season == 'autumn' & koppen == 'tropical') %>% ggplot(aes(x=time)) + geom_histogram(bins=12) + coord_polar()
ggsave('./results/time_hist_autumn_tropical_circ.png')
