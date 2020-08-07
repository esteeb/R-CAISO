#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

data <- readRDS("shiny_datasets/initial_data.RDS")

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("CAISO and COVID-19 shutdowns"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            dateInput(inputId = "start.date", label = "Pick date", value = "2020-04-13", min = "2020-04-13", max = "2020-07-10",
                      format = "mm-dd", startview = "month", weekstart = 1, language = "en", width = 200, autoclose = FALSE,
                      datesdisabled = NULL, daysofweekdisabled = NULL)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$distPlot <- renderPlot({
        # Do some basic loading and stuff
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)