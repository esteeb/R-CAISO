#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggthemes)
library(reshape2)
library(chron)
library(DT)

# Define functions used by the app

get_used_dates <- function(start.date = input$start.date) {
    start.day <- lubridate::day(start.date)
    start.month <- lubridate::month(start.date, label = FALSE)
    year <- 2018
    all_years <- c(2018:2020)
    
    for (year in all_years) {
        first.day <- as.Date(
            paste(year, start.month, start.day, sep = "-")
        )
        used.dates.yr <- seq(first.day, by = "day", length.out = 7)
        used.dates <- c(used.dates, used.dates.yr)
    }
    used.dates
}

week_avgs <- function(data = NULL, start.date = input$start.date) {
    start.day <- lubridate::day(start.date)
    start.month <- lubridate::month(start.date, label = FALSE)
    year <- 2018
    all_years <- c(2018:2020)
    avg_df <- NULL
    
    for (year in all_years) {
        first.day <- as.Date(
            paste(year, start.month, start.day, sep = "-")
        )
        used.dates.yr <- seq(first.day, by = "day", length.out = 7)
        dates.df <- data %>%
            filter(Date %in% used.dates.yr)
        
        # Remove first two columns to allow apply avgs function to work
        dates.df <- dates.df[,3:ncol(dates.df)]
        
        new_avgs <- apply(dates.df, MARGIN = 2, FUN = mean)
        
        avg_df <- rbind(avg_df, new_avgs)
        
        
    }
    
    avg_df <- as.data.frame(avg_df)
    avg_df <- cbind(all_years, avg_df)
    avg_df$all_years <- as.factor(avg_df$all_years)
    colnames(avg_df)[1] <- c("Year")
    
    tidy_avg_df <- melt(avg_df, id.vars = "Year")
    
    tidy_avg_df
    
}

rel_data <- readRDS("shiny_datasets/rel_data.RDS")
ramps <- readRDS("shiny_datasets/ramps.RDS")

used.dates <- NULL


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    
    # Application title
    titlePanel("CAISO and COVID-19 shutdowns"),
    
    # Navbar
    navbarPage("App Title",
               tabPanel("App",
                        # Sidebar with a slider input for number of bins 
                        sidebarLayout(
                            sidebarPanel(
                                dateInput(inputId = "start.date", label = "Pick date", value = "2020-04-13", min = "2020-04-13", max = "2020-07-10",
                                          format = "yyyy-mm-dd", startview = "month", weekstart = 1, language = "en", width = 200, autoclose = FALSE,
                                          datesdisabled = NULL, daysofweekdisabled = NULL)
                            ),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                                plotOutput("distPlot"),
                                tableOutput("table")
                                
                            )
                        )       
                        
                        
                        ),
               tabPanel("Analysis"),
               tabPanel("Documentation",
                        textOutput("documentation")
                        ),
               tabPanel("About")
    ),
    

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    
    output$distPlot <- renderPlot({
        # Do some basic loading and stuff
        tidy_avg_df <- week_avgs(data = rel_data, start.date = input$start.date)
        
        # draw the histogram with the specified number of bins
        avg_plot <- ggplot(tidy_avg_df, aes(x = as.numeric(variable), y = value, color = Year)) + 
            geom_point() + 
            scale_color_fivethirtyeight() + 
            theme_fivethirtyeight()
        avg_plot
    })
    
    output$table <- renderTable({
        used.dates <- get_used_dates(start.date = input$start.date)
        ramps <- ramps %>%
            select(Date, Max.Time, Max)%>%
            filter(Date %in% used.dates)%>%
            mutate(year = lubridate::year(Date))%>%
            group_by(year)%>%
            summarise(mean.max.ramp = mean(Max),
                      mean.time = mean(times(Max.Time)),
                      .groups = "keep")
        ramps$year <- as.factor(ramps$year)
        ramps$mean.time <- as.character(ramps$mean.time)
        colnames(ramps) <- c("Year", "Avg Max Ramp", "Avg Time of Max Ramp")
        ramps <- as.data.frame(ramps)
    })
    
    output$documentation <- renderText({"This is a fairly simple application. Simply select a given date and it will render a plot of the 7-day average net demand
        on the California grid, for each of three years, starting on that date. NOTE: The application should also render some stats below the plot, 
        but that is not actually working right now due to some issues on the server side."})
}

# Run the application 
shinyApp(ui = ui, server = server)