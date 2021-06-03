#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## Load libraries
library(shiny)

country_vaccinations <- read.csv("../data/country_vaccinations.csv")
country_by_manufacturer <- read.csv("../data/country_vaccinations_by_manufacturer.csv")
county_statistics <- read.csv("../data/county_statistics.csv")
trump_biden <- read.csv("../data/trump_biden_polls.csv")
trump_clinton <- read.csv("../data/trump_clinton_polls.csv")
vaccine_hesitancy <- read.csv("../data/Vaccine_Hesitancy_County.csv")
vaccine_hesitancy_state <-read.csv("../data/Data_with_state_vaccine")

US_data <- country_vaccinations %>%
    filter(country == "United States", na.rm = TRUE) %>%
    filter(date >= as.Date("2021-01-01")) %>%
    filter(!is.na(people_vaccinated))
    

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    ## To filter by date in UI
    filterByDate <- reactive({
        US_data %>%
            filter(date %in% input$date) %>%
            group_by(date) 
    })
    
    ## filtered by type(rates)
    
            
    
    
    
    
    
    
    output$distPlot <- renderPlot({
        
        ## Labels for plot
        ggplot(filterByDate()) +             
            geom_bar(stat = "identity", mapping = aes(x = date, y = people_vaccinated / 100000), fill = "#00ffff") +
            labs(title = "National Vaccination Rates", x = input$date, y = "# Vaccinated") 
    })
    
    ## Rendering output message for plot information
    ##output$message <- renderText({
    ##    output_msg <- paste("In", input$states, ", there were", filterByTime_AM()$AM_count[1], "UFO sightings in the AM hours as compared to ",
    ##                        filterByTime_PM()$PM_count[1], "in the PM hours.")
    ##})

})


