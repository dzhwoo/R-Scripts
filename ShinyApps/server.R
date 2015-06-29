
# This is the server logic for a Shiny web application.
# server is where all the magic happens. UI is calling the functon and gives parameters or inputs as well.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
     
    # generate and plot an rnorm distribution with the requested
    # number of observations
    #dist <- rnorm(input$obs)
    #hist(dist)
    data(cars)
    
    cars.lo <- loess(dist ~ speed, cars, span =input$obs)
    #predict(cars.lo, data.frame(speed = seq(5, 30, 1)), se = TRUE)
    
    plot(dist ~ speed, data=cars,pch=19,cex=0.1)
    j <- order(cars$speed)
    lines(cars$speed[j],cars.lo$fitted[j],col="red",lwd=3)
    
  })
  
})
