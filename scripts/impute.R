library(tidyverse)
library(missForest)

readRDS('./data/processed/data_transformed.RDS') %>% as.data.frame -> data_transformed_df

missForest(data_transformed_df) -> imputation_result

imputation_result$ximp %>% as_tibble() %>% saveRDS('./data/processed/data_imputed.RDS')
