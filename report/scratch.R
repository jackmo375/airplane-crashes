library(tidyverse)
library(cowplot)

data_clean %>% ggplot(aes(x=aboard, y=fatalities)) + geom_point()