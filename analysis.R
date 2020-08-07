# Read in data for 3 years - use April 10, 2018 to July 10 2018, Jan 1 2019/2020 to July 10 2019/2020



report_name = "netdemand"

twenty_data <- read_in_data(rel_dates = twenty_rel_dates)
nineteen_data <- read_in_data(rel_dates = nineteen_rel_dates)
eighteen_data <- read_in_data(rel_dates = eighteen_rel_dates)

# Combine all data, drop last column to save some pain later
full_set <- rbind(twenty_data, nineteen_data, eighteen_data)
full_set <- full_set[,1:290]

rel_full_set <- full_set %>%
  filter(Type == "Net demand")

#' @param all_ma if FALSE, calculates only moving averages after 1200, if TRUE, calculates all mas all day. Reflects the fact that peak net demand ramp is never before noon

