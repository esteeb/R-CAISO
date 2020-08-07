

grouped_selected <- ramps%>%
  select(Date, Type, Max, Max.Time)%>%
  mutate(
    year = year(Date),
    month = month(Date),
    day = day(Date),
    day.of.week = weekdays(Date),
    .before = 1
  )%>%
  group_by(day.of.week)

group_by_year_month <- function(data = NULL) {
  grouped_selected <- data%>%
    select(Date, Type, Max, Max.Time)%>%
    mutate(
      year = year(Date),
      month = month(Date),
      day = day(Date),
      day.of.week = weekdays(Date),
      .before = 1
    )
  
  
  
}