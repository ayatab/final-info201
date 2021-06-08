
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

country_vaccinations <- read.csv("data/country_vaccinations.csv")
country_by_manufacturer <- read.csv("data/country_vaccinations_by_manufacturer.csv")
county_statistics <- read.csv("data/county_statistics.csv")
trump_biden <- read.csv("data/trump_biden_polls.csv")
trump_clinton <- read.csv("data/trump_clinton_polls.csv")
vaccine_hesitancy <- read.csv("data/Vaccine_Hesitancy_County.csv")
vaccine_hesitancy_state <-read.csv("data/Data_with_state_vaccine.csv")

vaccine_hesitancy_state <- vaccine_hesitancy_state %>% 
    mutate(incomepercapita_2018 = as.numeric(str_replace(incomepercapita_2018, ",", "")))

Comparison_data <- country_vaccinations %>%
    filter(country == "United States" | country == "Canada") %>%
    filter(date >= as.Date("2021-01-01")) %>%
    filter(!is.na(people_vaccinated_per_hundred))

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
    
    ## To filter by date in UI
    filterByDate_US <- reactive({
        Comparison_data %>%
            filter(date %in% input$date) %>%
            group_by(date) 
    })
    
    output$distPlot <- renderPlot({
        ## Labels for plot
        ggplot(filterByDate_US()) +             
            geom_histogram(stat = "identity", mapping = aes(x = iso_code, y = people_vaccinated_per_hundred, fill = iso_code)) +
            labs(title = "Vaccination Rates (Canada vs. U.S)", x = input$date, y = "# Vaccinated (per 100)")
    })
    
    
    output$scatter_plot <- renderPlot({
        if (input$select == "% Voted Trump (2020)") {
            ggplot(vaccine_hesitancy_state) +
                geom_point(mapping = aes(
                    x = vaccinehesitancy,
                    y = trumpvote_2020, col = "orange")) +
            labs(x = "Vaccine Hesitancy (% population)", y = "Voted for Trump in 2020 (% population)") + 
                theme(legend.position = "none")
        } else if (input$select == "Poverty Rate (2019)") {
            ggplot(vaccine_hesitancy_state) +
                geom_point(mapping = aes(
                    x = vaccinehesitancy,
                    y = povertyrate_2019, col = "orange")) +
            labs(x = "Vaccine Hesitancy (% population)", y = "Poverty Rate (% population)") + 
                theme(legend.position = "none")
        } else if (input$select == "Income per Capita (2018)") {
            ggplot(vaccine_hesitancy_state) +
                geom_point(mapping = aes(
                    x = vaccinehesitancy,
                    y = incomepercapita_2018, col = "orange")) +
            labs(x = "Vaccine Hesitancy (% population)", y = "Income per Capita in 2018 (USD)") + 
                theme(legend.position = "none")
        } else if (input$select == "Unemployment Rate (Apr2021)") {
            ggplot(vaccine_hesitancy_state) +
                geom_point(mapping = aes(
                    x = vaccinehesitancy,
                    y = unemployment_Apr2021, col = "orange")) +
                labs(x = "Vaccine Hesitancy (% population)", y = "Unenployement rate as of April 2021 (% population)") + 
                theme(legend.position = "none")
        } else if (input$select == "% Voted Trump (2016)") {
            ggplot(vaccine_hesitancy_state) +
                geom_point(mapping = aes(
                    x = vaccinehesitancy,
                    y = trumpvote_2016, col = "orange")) +
                labs(x = "Vaccine Hesitancy (% population)", y = "Voted for Trump in 2016 (% population)") + 
                theme(legend.position = "none")
        }
    })
})













