library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  data<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Gamma/Train/Explanatory_Analysis/train_dept92_yoy_sales_unemployment.csv")
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'skyblue', border = 'white')
    
    fit<-lm(Weekly_Sales ~ Unemploy, data = data)
    
    # how to do multiple plots
    
    # C for consistency
    # diagnostic 1a: Check for constant variance, variance of errors should be constant along the line
    plot(Weekly_Sales ~ Unemploy, data = data)
    abline(fit,col='skyblue')
    
    # diagnostic 1b: Scatter plot of residuals
    
    # diagnostic 2: errors should be normally distributed - as in centered and now skewed, some type of steady state
    plot(fit)
    
    # diagnostic 3: residual analysis but residual is rescaled. All values are positive. 
    #This checks for consistency but since before residuals can be both -ve and +ve
    
    #diagnostic 4: leverage is a measure of how much each point influences the regression. 
    #useful for picking out points. Make sure no points are outside of cook's distance
    # further aways from zero and more of them, means more influence
  })
  
  output$distPlotB <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'skyblue', border = 'white')
    
  })
})