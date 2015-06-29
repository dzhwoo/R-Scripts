
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Regression - using Loess Method."),
  
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("obs", 
                "Span:", 
                min = 0, 
                max = 1, 
                value = 0.5)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    h4("Why? For me, at least, i think the benefit is that it is non-parametric. 
       For me that means you fit the model to that data not try to fit a square peg into a round top. 
       Some literature states the following Support non-linear regression and also simplicity of linear regression 
       calc ( minimize least square error method. My next questions is then how to predict?.
       My answer would then be forecast based on forecasted values. Yes this is correct in a way. After the trend
       is identified, it then does a regression on top of that then adds seasonality to it.
       https://leve.rs/blog/how-to-correctly-forecast-seasonal-marketing-trends-with-stl/"),
    h3("How? A sort of piecewise weighted linear/nonlinear regression. 
       Does multi weighted linear regression and combines them"),
    h5("http://www.itl.nist.gov/div898/handbook/pmd/section1/pmd144.htm"),
    h6("http://polisci.msu.edu/jacoby/icpsr/regress3/lectures/week4/15.Loess.pdf"),
    plotOutput("distPlot")
  )
))
