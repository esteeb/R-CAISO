## Determine date range for reading in
twenty_rel_dates <- seq(as.Date("2020/01/01"), by = "day", length.out = 191)
nineteen_rel_dates <- seq(as.Date("2019/01/01"), by = "day", length.out = 190)
eighteen_rel_dates <- seq(as.Date("2018/04/12"), by = "day", length.out = 89)
  
## Report name to be read in
report_name <- "netdemand"

read_in_data <- function(rel_dates = NULL, report = report_name) {
  # Format dates and get how long the range is
  imported_data <- NULL
  char_dates <- as.character(rel_dates)
  format_date <- gsub("-", "", char_dates)
  length_range <- length(format_date)
  all_colnames <- c("Date", 
                    "Type", 
                    format(seq.POSIXt(as.POSIXct(Sys.Date()), as.POSIXct(Sys.Date()+1), by = "5 min"), "%H%M", tz = "GMT")
  )
  for (i in 1:length_range) {
    working_new_col <- rep(rel_dates[i], 3)
    working_df <- read.csv(
      paste0(
        "CAISO Data/CAISO-",
        report_name,
        "-",
        format_date[i],
        ".csv"
      ),
      header = TRUE,
      colClasses = c("factor", rep("numeric",289))
    )
    format_working <- cbind(working_new_col, working_df)
    colnames(format_working) <- all_colnames
    imported_data <- rbind(imported_data, format_working)
    imported_data
  }
  imported_data
}



