library(tidyverse)
library(cowplot)
library(bpnreg)

readRDS('./data/processed/data_imputed.RDS') -> data_imputed

fit <- bpnr(pred.I = minutes_from_midnight ~ year + koppen + season, data = data_imputed, seed = 101)

fit_base <- bpnr(minutes_from_midnight ~ 1, data = data_imputed, seed = 101)

 # The inclusion of predictors in your bpnreg model has improved the model fit significantly compared to a model with no predictors (the baseline), providing strong evidence that your model is better at explaining the data

fit$circ.coef.cat

fit$circ.coef.cat %>% as.data.frame %>% rownames_to_column(var = "X")  %>% as_tibble() -> fit_cat

fit_cat %>% 
	ggplot(aes(x=mean, y=X, xmin=mean-2*sd, xmax=mean+2*sd)) + 
		geom_pointrange() + 
		geom_vline(xintercept=0) +
		theme_cowplot() +
  theme(axis.title.y = element_blank())

ggsave('./results/forest.png')
