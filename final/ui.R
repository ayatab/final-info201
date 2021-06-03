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

US_data <- country_vaccinations %>%
    filter(country == "United States", na.rm = TRUE) %>%
    filter(date >= as.Date("2021-01-01")) %>%
    filter(!is.na(people_vaccinated))

CA_data <- country_vaccinations %>%
    filter(country == "Canada", na.rm = TRUE) %>%
    filter(date >= as.Date("2021-01-01")) %>%
    filter(!is.na(people_vaccinated))

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
                             

                             tabPanel('Vaccine Rates', 
                                      p("This page displays the number of people that have been vaccinated by the day, scaled by 100,000.",
                                      style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 50px; background-color: #Ffa07f; text-align: center; padding: 10px; border-radius: 20px"),
                                
                                      
                                      sidebarPanel(
                                        selectInput("date", "Choose a date:", sort(US_data$date))
                                      ),
                                      mainPanel(
                                        plotOutput("distPlot")
                                      ),
                                      
                            ),

                             
                             tabPanel('Hesitancy Map', 
                                      
                                      p("This page displays the percent of estimated people hesitant on receiving the COVID vaccine in the US, with the darker regions
                                        showing where there are higher populations of estimated hesitant people. The last selection shows the percent of fully vaccinated people
                                        in the US, displayed in a different color scheme than the rest.",
                                        style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 150px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                                      
                                      sidebarPanel(
                                          selectInput("mapFilter", "Display by:", c("Estimated % Hesitant or Unsure", "Estimated % Hesitant", "Estimated % Strongly Hesitant", "% Fully Vaccinated"), selected = "Estimated % Hesitant or Unsure")
                                      ),
                                      mainPanel(
                                          plotOutput("mapPlot")
                                      ),
                                      
                                      
                             ),
                             
                             tabPanel('Hesitancy Comparisons',
                                      p("This page displays... (change box size with height, change the spacing from the top with padding",
                                        style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 50px; background-color: #Ffa07f; text-align: center; padding: 10px; border-radius: 20px"),
                                      
                                      ),
                             
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
                                      ),
                                      column(6,
                                             p("Future ideas to advance the project",
                                               style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 400px; background-color: #Ffa07f; text-align: center; padding: 15px; border-radius: 20px"),
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
))
