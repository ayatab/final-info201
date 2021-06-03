#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

country_vaccinations <- read.csv("../data/country_vaccinations.csv")
country_by_manufacturer <- read.csv("../data/country_vaccinations_by_manufacturer.csv")
county_statistics <- read.csv("../data/county_statistics.csv")
trump_biden <- read.csv("../data/trump_biden_polls.csv")
trump_clinton <- read.csv("../data/trump_clinton_polls.csv")
vaccine_hesitancy <- read.csv("../data/Vaccine_Hesitancy_County.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })

})
