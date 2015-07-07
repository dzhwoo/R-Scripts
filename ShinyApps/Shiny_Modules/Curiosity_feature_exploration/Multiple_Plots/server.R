max_plots <- 5
library(ggplot2)

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
  
    local({

      #plot scatter plot and linear regression
      #for the scatter plot want to plot by groups
      plotname <- paste("plot", 1, sep="")
      output[[plotname]] <- renderPlot({
        plot(Weekly_Sales ~ Unemploy, data = data)
        
        # this does the scatter plot by color
        # next how to make the font bigger, for now using size
        qplot(Unemploy,Weekly_Sales,data = data, color = Store_type ,size=20)
        
        # next frequency count by store stype
        # So A and B are majority
        # also wondering if it make sense to look at the negative unemployment rate. mostly positive.
        # actually what does the unem
        # should we do a box plot?
        
        abline(fit,col='skyblue')
      })
      
      plotname <- paste("plot", 2, sep="")
      output[[plotname]] <- renderPlot({
          par(mfrow = c(2, 2), oma = c(0, 0, 2, 0))
          plot(fit)
          #abline(fit,col='skyblue')
        
        })
      })
})