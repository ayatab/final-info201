#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(maps)
library(tidyverse)

country_vaccinations <- read.csv("../data/country_vaccinations.csv")
country_by_manufacturer <- read.csv("../data/country_vaccinations_by_manufacturer.csv")
county_statistics <- read.csv("../data/county_statistics.csv")
trump_biden <- read.csv("../data/trump_biden_polls.csv")
trump_clinton <- read.csv("../data/trump_clinton_polls.csv")
vaccine_hesitancy <- read.csv("../data/Vaccine_Hesitancy_County.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    ## load the county shapefile and join on county fips
    county_shapes <- map_data("county") %>%
        # load county boundary data (package "maps")
        unite(polyname, region, subregion, sep = ",") %>%
        # put the polygon name in the same form as in county.fips
        left_join(county.fips, by = "polyname")
    # merge with fips data
    
    # combine county shapes with vaccine hesitancy data
    map_hesitancy <- left_join(vaccine_hesitancy, county_shapes, by = c("FIPS.Code" = "fips"))
    
    output$mapPlot <- renderPlot({
        
        if (input$mapFilter == "Estimated % Hesitant") {
            # Map displayed if user selects Estimated % Hesitant and appropriate labels/scale
            ggplot(map_hesitancy, aes(x = long, y = lat)) +
                geom_polygon(aes(group = group, fill = Estimated.hesitant), color = "black") +
                scale_fill_gradient(low = "white", high = "red", breaks = c(0,0.5) ,limits=c(0, 0.5), labs(scale = "% of Population")) +
                labs(title = "Estimated % Hesitant") +
                coord_quickmap()
        } else if (input$mapFilter == "Estimated % Strongly Hesitant") {
            # Map displayed if user selects Estimated % Strongly Hesitant and appropriate labels/scale
            ggplot(map_hesitancy, aes(x = long, y = lat)) +
                geom_polygon(aes(group = group, fill = Estimated.strongly.hesitant), color = "black") +
                scale_fill_gradient(low = "white", high = "red", breaks = c(0,0.5) ,limits=c(0, 0.5), labs(scale = "% of Population")) +
                labs(title = "Estimated % Strongly Hesitant") +
                coord_quickmap()
        } else if (input$mapFilter == "Estimated % Hesitant or Unsure") {
            # Map displayed if user selects Estimated % Hesitant or Unsure and appropriate labels/scale
            ggplot(map_hesitancy, aes(x = long, y = lat)) +
                geom_polygon(aes(group = group, fill = Estimated.hesitant.or.unsure), color = "black") +
                scale_fill_gradient(low = "white", high = "red", breaks = c(0,0.5) ,limits=c(0, 0.5), labs(scale = "% of Population")) +
                labs(title = "Estimated % Hesitant or Unsure") +
                coord_quickmap()
        } else if (input$mapFilter == "% Fully Vaccinated") {
            # Map displayed if user selects % Fully Vaccinated and appropriate labels/scale
            ggplot(map_hesitancy, aes(x = long, y = lat)) +
                geom_polygon(aes(group = group, fill = Percent.adults.fully.vaccinated.against.COVID.19), color = "black") +
                scale_fill_gradient(low = "white", high = "blue", breaks = c(0,0.5,1) ,limits=c(0, 1), labs(scale = "% of Population")) +
                labs(title = "Estimated % Fully Vaccinated") +
                coord_quickmap()
        }
    })
})
