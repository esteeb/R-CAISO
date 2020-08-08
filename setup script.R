# Load dataset into new global

# Libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(reshape2)

# Read 
eighteen_data <- read_in_data(eighteen_rel_dates)
nineteen_data <- read_in_data(nineteen_rel_dates)
twenty_data <- read_in_data(twenty_rel_dates)

# Rbind
data <- rbind(eighteen_data, nineteen_data, twenty_data)

# Drop last column
data <- data[,1:290]


# Filter
rel_data <- data %>%
  filter(Type == "Net demand")

ramps <- ramp_by_time(rel_data)
ramps_safe <- ramps


saveRDS(rel_data, file = "C:/Users/erikm/OneDrive/Documents/R Projects/R-CAISO/CAISO-shiny/shiny_datasets/rel_date.RDS")

saveRDS(ramps, file = "C:/Users/erikm/OneDrive/Documents/R Projects/R-CAISO/CAISO-shiny/shiny_datasets/ramps.RDS")


tidy_avg_df <- week_avgs(data = rel_data, start.date = "2020-07-01")
