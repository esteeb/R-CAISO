# Ramp function 

ramp_by_time <- function(data = NULL) {
  #Setup variables and save column names for later
  all_ramps <- NULL
  save_colnames <- colnames(data)
  n_rows <- as.numeric(count(data))
  my_col <- 1
  my_row <- 1
  # Strip first two columns, keep in sep var to cbind later
  var_cols <- data[,1:2]
  data <- data[,3:290]
  
  #Runs one loop per day
  for (my_row in 1:n_rows) {
    all_ramp_day <- NULL
    
    # Runs one loop per 5-minute interval, determines total 3-hour ramp rate from given start time, scaled to hourly
    for (my_col in 1:252) {
      ramp_rate <- ((data[my_row,(my_col+36)] - data[my_row,my_col]))/3
      dat[[my_col]] <- ramp_rate
    }
    df_dat <- as.data.frame(dat)
    
    # Determines the actual value of the maximum, saves in new column
    df_dat$Max <- max(df_dat[1,])
    
    # Add back first two columns
    df_dat <- cbind(var_cols[my_row,],df_dat)
    
    # Fix column names
    colnames(df_dat) <- c(save_colnames[1:254],"Max")
    
    # Get which column has max value, so we can track times later
    max_ramp_time <- colnames(df_dat)[(apply(df_dat[3:254], 1, which.max))+2]
    df_dat$Max.Time <- max_ramp_time
    
    all_ramps <- rbind(all_ramps, df_dat)
   # print(my_row)
    all_ramps
  }
  all_ramps
  
}


#'
#'
#'
#' @return A dataframe with the 7-day average net demand for each year (2018, 2019, 2020), starting on the input date.
#'
#'

week_avgs <- function(data = NULL, start.date = as.Date("2020-05-01")) {
  start.day <- lubridate::day(start.date)
  start.month <- lubridate::month(start.date, label = FALSE)
  year <- 2018
  all_years <- c(2018:2020)
  avg_df <- NULL
  
  for (year in all_years) {
    first.day <- as.Date(
      paste(year, start.month, start.day, sep = "-")
    )
    used.dates <- seq(first.day, by = "day", length.out = 7)
    dates.df <- data %>%
      filter(Date %in% used.dates)
    
    # Remove first two columns to allow apply avgs function to work
    dates.df <- dates.df[,3:ncol(dates.df)]
    
    new_avgs <- apply(dates.df, MARGIN = 2, FUN = mean)
    
    avg_df <- rbind(avg_df, new_avgs)
    
      
  }
  
  avg_df <- as.data.frame(avg_df)
  avg_df <- cbind(all_years, avg_df)
  avg_df$all_years <- as.factor(avg_df$all_years)
  colname(avg_df)[1] <- c("Year")

  tidy_avg_df <- melt(avg_df, id.vars = "Year")
  
  tidy_avg_df
  
}

  