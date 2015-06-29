max_plots <- 5

shinyServer(function(input, output) {
  
  # Insert the right number of plot output objects into the web page
  output$plots <- renderUI({
    plot_output_list <- lapply(1:input$n, function(i) {
      plotname <- paste("plot", i, sep="")
      plotOutput(plotname, height = 400, width = 500)
    })
    
    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, plot_output_list)
  })
  
  data<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Gamma/Train/Explanatory_Analysis/train_dept92_yoy_sales_unemployment.csv")
  fit<-lm(Weekly_Sales ~ Unemploy, data = data)
  
  # Call renderPlot for each one. Plots are only actually generated when they
  # are visible on the web page.
  #for (i in 1:2) {
    # Need local so that each item gets its own number. Without it, the value
    # of i in the renderPlot() will be the same across all instances, because
    # of when the expression is evaluated.
    local({
      #my_i <- i
      #plotname <- paste("plot", my_i, sep="")
      
      #plot scatter plot and linear regression
      plotname <- paste("plot", 1, sep="")
      output[[plotname]] <- renderPlot({
        plot(Weekly_Sales ~ Unemploy, data = data)
        abline(fit,col='skyblue')
      })
      
      plotname <- paste("plot", 2, sep="")
      output[[plotname]] <- renderPlot({
          par(mfrow = c(2, 2), oma = c(0, 0, 2, 0))
          plot(fit)
          #abline(fit,col='skyblue')
        
        })
      })
      
      
    #})
  #}
})