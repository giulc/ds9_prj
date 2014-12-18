
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(markdown)

shinyUI(
        fluidPage(
   
  # Application title
  titlePanel("Stocks Forecast"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
       
       uiOutput("stocks_list"),
       dateInput("dfrom", "From: ",
                 value = as.character(Sys.Date()-30),
                 min = as.character(as.Date("2001-01-01")),
                 max = as.character(Sys.Date()-30)
                 ),
#        dateInput("dto", "To: ",
#                  value = as.character(Sys.Date()-1),
#                  min = as.character(Sys.Date()-1),
#                  max = as.character(Sys.Date()-1)
#                  ),
       sliderInput("period", "Number of forecasted days",
                   value = 1, min = 1, max = 50, step = 1
          ),
       
       submitButton("Submit"),
   br(),
   tabsetPanel(
      tabPanel("Prediction Table",
               dataTableOutput("pred_table")
               )
      )       
    ),

    # Show a plot of the selected stock
    mainPanel(
       h4("Selected stock name: "),
       verbatimTextOutput("stock_selected"),
       plotOutput("plot_stock"),
       br(),
       tabPanel("About",
                includeMarkdown("readme.md"))
    )
))
)
