
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(quantmod)
library(forecast)
stocks <- read.csv(
   "stocks.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)
n_list <- as.list(stocks[,2])

shinyServer(function(input, output) {

   output$stocks_list <- renderUI({
      selectInput("in_stock_name", "Choose Stock:", n_list,
                  selected = stocks[1,2])
   })
   
   
   output$stock_selected <- renderPrint({
      if (is.null(input$in_stock_name) == TRUE)
         return()
      str(input$in_stock_name)
   })
   
   
   fore <- reactive({
      if (is.null(input$in_stock_name) == TRUE)
         return()
      
      for (i in 1:dim(stocks)[1]){
         if (stocks[i, 2] == input$in_stock_name) {
            symb <- stocks[i, 1]
            break
         }
      }
      
      data <- getSymbols(symb, src = "yahoo", 
                         from = input$dfrom,
                         to = Sys.Date(),
                         auto.assign = FALSE)
      ts_data <- ts(Cl(data), frequency=1)
      
      # Forecast
      fit <- auto.arima(ts_data)
      fore_data <- forecast(fit, h=input$period)
      fore_data
   })

   ptab <- reactive({
      if (is.null(input$in_stock_name) == TRUE)
         return()
      ptable <- data.frame(round(fore()$mean, 3))
      names(ptable)[1] <- "Prediction"
      ptable
   })
   
   
   output$plot_stock <- renderPlot({
      
      if (is.null(input$in_stock_name) == TRUE)
         return()
#       
      plot.forecast(fore())
      
#       chartSeries(data,
#                   theme = chartTheme("white"), 
#                   type = "line", log.scale = FALSE,
#                   TA = "addTA(Cl(foreTrain))")
   })
   
   output$pred_table <- renderDataTable({
      if (is.null(input$in_stock_name) == TRUE)
         return()
      ptab()
   }, options = list(lengthMenu = c(5, 10), pageLength = 5,
                     searching = FALSE)
   )

#   output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
#     x    <- faithful[, 2]
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
#     hist(x, breaks = bins, col = 'darkgray', border = 'white')

#   })

})
