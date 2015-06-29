library(shinyapps)


# a few resources:
#1. Setup: https://www.shinyapps.io/admin/#/dashboard
#2. Developing demo app: http://shiny.rstudio.com/articles/shinyapps.html


library(shiny)
library(ggplot2)

dataset <- diamonds

fluidPage(
  
  titlePanel("Diamonds Explorer"),
  
  sidebarPanel(
    
    sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(dataset),
                value=min(1000, nrow(dataset)), step=500, round=0),
    
    selectInput('x', 'X', names(dataset)),
    selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    selectInput('color', 'Color', c('None', names(dataset))),
    
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)

shinyapps::deployApp('path/to/your/app')

library(shiny)
runApp()