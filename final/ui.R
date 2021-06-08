#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# libraries used
library(shiny)
library(shinythemes)
library(dplyr)

# all datasets that were read in for plot and map usage
country_vaccinations <- read.csv("data/country_vaccinations.csv")
country_by_manufacturer <- read.csv("data/country_vaccinations_by_manufacturer.csv")
county_statistics <- read.csv("data/county_statistics.csv")
trump_biden <- read.csv("data/trump_biden_polls.csv")
trump_clinton <- read.csv("data/trump_clinton_polls.csv")
vaccine_hesitancy <- read.csv("data/Vaccine_Hesitancy_County.csv")
vaccine_hesitancy_state <-read.csv("data/Data_with_state_vaccine.csv")

# dataset used for the vaccine rates tab compared between the US and Canada
Comparison_data <- country_vaccinations %>%
  filter(country == "United States" | country == "Canada") %>%
  filter(date >= as.Date("2021-01-01")) %>%
  filter(!is.na(people_vaccinated_per_hundred))

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme('united'),
                  
                  # Application title
                  titlePanel(h1('US COVID-19 Vaccine and Household Incomes', align = 'center', style = 'color: #Ffa07f')),
                  
                  navbarPage(':)', 
                             #home page
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
                             
                             #vaccine rates tab, added css elements for code like other tabs for description at the top
                             tabPanel('Vaccine Rates', 
                                      p("This page displays the number of people that have been vaccinated per hundred, filtered by date.",
                                        style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 50px; background-color: #Ffa07f; text-align: center; padding: 10px; border-radius: 20px"),
                                      
                                      
                                      sidebarPanel(
                                        selectInput("date", "Choose a date:", sort(Comparison_data$date))
                                      ),
                                      mainPanel(
                                        plotOutput("distPlot")
                                      ),
                                      
                             ),
                             
                             #hesitancy map tab, added css elements for code like other tabs for description at the top
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
                             
                             #hesitancy comparison map, added css elements for code like other tabs for description at the top
                             tabPanel('Hesitancy Comparisons',
                                      p("This page compares the percentage of Covid-19 vaccine hesitancy per state to political and socio-economic data.
                                        Each dot represents a U.S. state, and each dot is placed at x axis = percenttage of vaccine hesitancty, and y axis = user selected data.
                                        A positive slope represents a positive correlation between the two datasets compared, and a negative slope represents an inverse correlation.",
                                        style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 150px; background-color: #Ffa07f; text-align: center; padding: 10px; border-radius: 20px"),
                                      sidebarPanel(
                                        selectInput("select", h3("Select data to compare"),
                                                    choices = list("Income per Capita (2018)",
                                                                   "% Voted Trump (2016)",
                                                                   "% Voted Trump (2020)",
                                                                   "Poverty Rate (2019)",
                                                                   "Unemployment Rate (Apr2021)"
                                                    ), 
                                                    selected = 1)
                                      ),
                                      mainPanel(
                                        plotOutput("scatter_plot")
                                      ),
                                      
                                      
                                      
                                      
                                      
                             ),
                             
                             #conclusion tab, separated into columns of 6 and added css elements for code like other tabs
                             tabPanel('Conclusion Page',
                                      column(6,
                                             p("Some notable observations from our insight include: the positive correlation between Republican States and vaccine hesitancy, and the inverse correlation between income per capita and vaccine hesitancy.",
                                               style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 200px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                                      ),
                                      column(6,
                                             p("We can see under the Hesitancy Comparisons page, the lower the household income, the higher the vaccine hesitancy. We reflected that this can be due to
                                               the lack of medical support and insurance coverage people in poverty have, and education access to the impoverished is low, which can also
                                               lead to vaccine hesitancy, as people may not trust a vaccine that they did not receive much information about or do not understand.",
                                               style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 170px; background-color: #Ffa07f; text-align: center; padding: 20px; border-radius: 20px"),
                                      ),
                                      column(6,
                                             p("As mentioned above, we can see how poverty and unemployment rates affect the vaccine hesitancy rate. While we are not negatively targeting
                                               the population who voted for Donald Trump, the data signifies a higher percentage of vaccine hesitancy for those who voted for him.",
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
                                             p("Future ideas to advance the project:::Some ideas that could be implemented to advance our project would include ways to analyze how race and state statistics like 
                              COVID-19 deaths or mask mandates. Having more data on these aspects would make it easier to understand vaccine hesitancy rates and what is driving the current vaccination efforts in the U.S.",
                                               style = "color: #Af3a10; font-family: Calibri; font-size: 20px; height: 400px; background-color: #Ffa07f; text-align: center; padding: 15px; border-radius: 20px"),
                                      )
                                      
                                      
                                      
                                      
                             )
                             
                  )
                  
              
))



