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
    
    map_hesitancy <- left_join(vaccine_hesitancy, county_shapes, by = c("FIPS.Code" = "fips"))
    
    output$mapPlot <- renderPlot({
        
        ggplot(map_hesitancy, aes(x = long, y = lat)) +
            geom_polygon(aes(fill = Percent.Hispanic), color = "black") +
            scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0.5) +
            coord_quickmap()
        
    })
})
