# Load dataset into new global

# Libraries
library(tidyverse)
library(zoo)
library(lubridate)
library(fpp2)
library(ggplot2)
library(lattice)

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

