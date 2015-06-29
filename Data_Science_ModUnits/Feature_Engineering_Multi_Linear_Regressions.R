"Goal of this would be we are trying to predict a value given some variables which can explain it.
We want to figure out which variables are significant. Using linear regression to give us the first cut. 
Eventual relationship may not be linear but at least we know the coefficent is not zero.
Could the relationship be zero but the relationship is actually polynomial, possible..."

"First step do a multi linear regressions with output results as an example"

# Goal is to predict undergrad enrollment - ROLL
"Possible features include:
1.Unemployment rate - high then more kids go back to sch
2.Hgrad - also the support
3.Inc - Per capita income
Also, this is a time series model right.....so may seem like it's correlated when it is actually time?
Autocorrelation....enrollment increases over time because of population. So Hgrad and enrollment correlated
because of population growth over time?"

data<-read.csv("C:/Users/dwoo57/Documents/dataset_enrollmentForecast.csv")

model<-lm(formula = data$ROLL ~ data$UNEM + data$HGRAD + data$INC)

## this can help check which coefficients are significant. Showing the p value
## Then can see their coefficients
summary(model)


## Done this is if
plot(model$residuals, type = "l") #have to check that this is random

layout(matrix(c(1,2,3,4),2,2))
plot(model)

# check behavior of residuals plot make sure this is behaving
"Random about zero line
horizontal
No real outliers"
