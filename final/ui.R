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

poverty_data <- read.csv('data/poverty_estimate.csv')
hesitancy_data <- read.csv('data/vaccine_hesitancy.csv')


# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme('united'),

    # Application title
    titlePanel('Final Project...?'),
    
    navbarPage('Tabs', 
               tabPanel(icon('home')),
                        
               tabPanel('1'),
               
               tabPanel('2'),
               
               tabPanel('3')
                        
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
