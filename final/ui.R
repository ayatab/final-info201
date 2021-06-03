#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


country_vaccinations <- read.csv("../data/country_vaccinations.csv")
country_by_manufacturer <- read.csv("../data/country_vaccinations_by_manufacturer.csv")
county_statistics <- read.csv("../data/county_statistics.csv")
trump_biden <- read.csv("../data/trump_biden_polls.csv")
trump_clinton <- read.csv("../data/trump_clinton_polls.csv")
vaccine_hesitancy <- read.csv("../data/Vaccine_Hesitancy_County.csv")
vaccine_hesitancy_state <-read.csv("../data/Data_with_state_vaccine")

US_data <- country_vaccinations %>%
    filter(country == "United States") %>%
    filter(date >= as.Date("2021-01-01"))


US_data <- country_vaccinations %>%
    filter(country == "United States") %>%
    filter(date >= as.Date("2021-01-01"))
# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme('united'),

    # Application title
    titlePanel(h1('US COVID-19 Vaccine and Household Incomes', align = 'center', style = 'color: #Ffa07f')),
    
    navbarPage(':)', 
               tabPanel(icon('home'),
                        fluidRow(
                        column(12,
                            tags$img(src = 'https://im-media.voltron.voanews.com/Drupal/01live-166/styles/892x501/s3/2020-12/2020-12-08T180646Z_2053809307_RC26JK9ZHZ6T_RTRMADP_3_HEALTH-CORONAVIRUS-VACCINE-PATCHWORK.JPG?itok=HJMB02uJ', width = "500px", height = "300px", style = "padding: 10px; display: block; margin-left: auto; margin-right: auto; border-radius: 10%")  
                        ),
                        
                        column(12,
                            p("Hello, and welcome to our INFO 201 Final Project.", 
                              style = "color: #Af3a10; font-family: Calibri; font-size: 30px; height: 100px; background-color: #Ffa07f; text-align: center; padding: 30px; border-radius: 20px")
                        ),
                        column(12,
                            p("With the pandemic control progress rising via the vaccines being distributed throughout the United States and in the world,
                              our group wanted to highlight some issues that still persist regarding people's behavior around vaccines, related to household income. 
                              We retrieved our data of the vaccine hesitancy from the CDC and the household income and poverty in the US from the US Census.",
                              style = "color: #Af3a10; font-family: Calibri; font-size: 15px; height: 110px; background-color: #Ffa07f; text-align: center; padding: 17px; border-radius: 20px"))
                            
                        ),
                        column(6,
                            p("We worked on a few elements regarding vaccine rates, hesitancy, and hesitancy by political and economical factors. Our tabs focus on these elements ----> ", 
                              style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 150px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                            
                        ),
                        column(6,
                            tags$ol(
                              tags$li("Vaccine Rates by date, by Mitchell Stapelman"), 
                              tags$li("Map with vaccine hesitancy by state, by Justin Tham"), 
                              tags$li("Graph of vaccine hesitancy compared with political and economical factors, by Lisa Benjamin"),
                              style = "color: #691d03; font-family: Calibri; font-size: 20px; height: 250px; background-color: #Ef6332; text-align: center; padding: 25px; border-radius: 20px"))
                    ),
               
               tabPanel('Vaccine Rates', sidebarLayout(
                   sidebarPanel(
                       selectInput("date", "Choose a date:",
                                   sort(US_data$date)      
                       )
                   ),
                   
                   # Show a plot of the generated distribution
                   mainPanel(
                       plotOutput("distPlot")
                       ##textOutput("message")
                   )
               ),
               ),
               
              
               
              
    

               tabPanel('Hesitancy Map', 
                            
                        sidebarPanel(
                            selectInput("mapFilter", "Display by:", c("Estimated % Hesitant or Unsure", "Estimated % Hesitant", "Estimated % Strongly Hesitant", "% Fully Vaccinated"), selected = "Estimated % Hesitant or Unsure")
                        ),
                        mainPanel(
                            plotOutput("mapPlot")
                        ),
                        
                        
                        ),

               
               tabPanel('Hesitancy Comparisons'),
               
               tabPanel('Conclusion Page',
                        column(6,
                            p("Description of notable insight or pattern discovered in data stuff",
                              style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 150px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                        ),
                        column(6,
                            p("Specific piece of data, table, or chart that demonstrates pattern or insight",
                              style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 150px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                        ),
                        column(6,
                            p("Broader implications of the insight",
                              style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 150px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                        ),
                        column(6,
                            p("Our dataset takes data from the CDC and the US Census that gives unbiased responses. Our dataset with the vaccine hesitancy
                              rates also had data that was split from economical regions and by ethnicity as well, but we did not use that data to bring
                              any bias into our data visualizations. We can see how the specified columns present in the vaccine hesitancy dataset can potentially
                              harm certain ethnic groups if used in the wrong way to target certain groups. We avoided classifying by ethnicity to display any extreme
                              rates or numbers.",
                              style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 400px; background-color: #Ffa07f; text-align: center; padding: 15px; border-radius: 20px"),
                        )
                        
                        
                        
                        
                        )
                        
                        )
    )

    # Sidebar with a slider input for number of bins
    # sidebarLayout(
    #     sidebarPanel(
    #         sliderInput("bins",
    #                     "Number of bins:",
    #                     min = 1,
    #                     max = 50,
    #                     value = 30)
    #     ),
    # 
    #     # Show a plot of the generated distribution
    #     mainPanel(
    #         plotOutput("distPlot")
    #     )
    # )
)
