# David - represents the task
# Pepper - represents the actions

# David: Ok Pepper here is some data
data<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Beta/Data_Collection/Store_31_item_9_2012_2014.csv")

# David: Ok Pepper, what do you see?
str(data)

# David: Make the orig_date as date <<< This could make it into JSON
data$orig_date<-as.Date(data$orig_date,"%m/%d/%Y")
str(data)
summary(data)

colnames(data)[4]<-"unitsP"

str(data)

"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<MAIN QUESTIONS/HYPOTHESIS TO TEST>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

#Pepper: Got it...hmm let me check my corpus to see what I should test for....
"Corpus:
Seasonality: Monthly, Weekly,Daily
Trend: Year over year
Holidays:
Autocorrelation
  - between recent days
  - between recent week
  - Seasonality between days?
  - Seasonality between weeks?"
  
#Pepper: This is what my corpus says

#David: Pepper this is cool and love the charts...oh ya what are our hypothesis?

"Pepper: Ah good point. Here they are
1) Pay week (Complete!)
  3) If i shop on Sat i prob wont shop on Sun
  4) If I shop on Fri, i prob wont shop on Sat
2) Non pay week (Complete!)
  3) If i shop on Sat i prob wont shop on Sun
  4) If I shop on Fri, i prob wont shop on Sat
5) Mid week top up
6) Prior week shopping compared to this week"

# Some things want to test here is the dependancy across previous days
# Say Sunday what is that dependepent on
# Can we isolate days, can we say autocorrelation of diff days seperately.....

# Below is the exploration or the analysis

# With each interation we can generalize

# Autocorrelation example

require(graphics)

## Examples from Venables & Ripley
acf(lh)
acf(lh, type = "covariance")
pacf(lh)

# For seasonality,  Probably a good example would be this
# Below is monthly seasonality. Notice when the oscillations go back up again, seasonality is 12 months at a time.
# i.e when previous decemember goes up, this decemember goes up
plot(ldeaths)
acf(ldeaths)

# So ACF, can be 

plot(data)

# first transform into time series
ts<-na.omit(data$units)
ts<-ts(ts,frequency=365,start=c(2012,1,1))
plot(ts)

acf(ts)

# so definetely weekly seasonality for sure...as in day of week

# next how to adjust for it. Or is there a way to detect it?

# Maybe build first and then later go back to see

# Ok now detected seasonality, how to remove

# seem to use arima, how does this work?

#use auto arima to help us detect
library(forecast)
fit <- auto.arima(ts)
plot(forecast(fit,h=20))
summary(fit)

# how to intepret auto.arima results

# Maybe start with the objective we want to have model that the residuals do not have any correlation

# so next let's plot residuals

# I'm guessing this should decrease after time - residuals should be stationary and non-seasonal?
acf(fit$residuals)

# next how to interpret model

# what does (4,0,3) mean?

# what does non-zero mean? 

# http://stats.stackexchange.com/questions/44992/what-are-the-values-p-d-q-in-arima

# 4 mean - autoregressive 4-order autogressive
# 12 means - 12th order moving average
# 0 is the difference between the autogressive model and moving average model

# how to check the seasonal component of ARIMA?
fit$arma

fit_manual<-arima(ts,order = c(4, 2, 3),  seasonal = list(order = c(0, 1, 9),period = 7))
fit_manual$arma

"Interpretation of ARIMA model, when doing model$ARMA:
Non-S(1):
4 - Non-S(1)           
3 - Non-S(3)
0 - S(1)
1 - S(3)
7 - S_Period
2 -Non-S(2) 
1 -S (2)
"

# hmm so auto-arima not picking up any season parts

# can we use acf to detect seasonality, then remove using stl

ts_7<-ts(ts,frequency=7,start=c(2012,1,1))
plot(ts_7)

plot(stl(ts_7, "periodic"))
seasonal_fit<-stl(ts_7, "periodic")
str(seasonal_fit$time.series)
plot(seasonal_fit$time.series[0:21],type='l')

seasonal   <- seasonal_fit$time.series[,1]
trend     <- seasonal_fit$time.series[,2]
remainder  <- seasonal_fit$time.series[,3]

ts_7_season_Adjust<-(trend+remainder)

# how to add previous plot, also how do we check that it works. What is our expectation?
acf(ts_7_season_Adjust)
acf(ts)

plot(ts_7,col="red",xlim=c(2010,2020))
par(new=TRUE)
plot(ts_7_season_Adjust,col="green",xlim=c(2010,2020))

# it looks like some adjustments are made but very little. Is seas

head(trend)
head(remainder)
head(seasonal)

seasonal_fit

# is seasonality so small?


"Ok based on the tools that we have can we build a simple model to predict Sunday

Start with the simplest.
Can we predict 2014 summer based on 2012 and 2013 data
"
ts<-ts(ts,frequency=365,start=c(2012,1,1))
plot(ts)
head(ts)

#Can we filter based on the months, say April,May,June
str(data)

ds_months456<-subset(data,Month >= 4 & Month <=6)
str(ds_months456)
summary(ds_months456)

ds_2012<-subset(ds_months456,Year == 2012)
ds_2013<-subset(ds_months456,Year == 2013)
ds_2014<-subset(ds_months456,Year == 2014)

plot(ds_2012$units, type = 'l',col='green',lwd=2)
par(new=TRUE)
#how to offset for day of week
plot(ds_2013$units, type = 'l',col='blue',lwd=2)
par(new=TRUE)
plot(ds_2014$units, type = 'l',col='black',lwd=2)

#abit hard to tell, why I think it's the thickness of the line. FIXED. Adjust thickness easier to see visually.
#Also are they y-axis to scale? Or each of them someway adjusted?
#Assume all are using the same scale
# I doubt they use the same scale, since it means we do not redraw the scale. That means they are similar but depend
# on some mean value

#TODO: Plot lines on the same graph using the same axis. Gain = Low, more for visualization

summary(ds_2012)

plot(ts_7,col="red",xlim=c(2010,2020))
par(new=TRUE)
plot(ts_7_season_Adjust,col="green",xlim=c(2010,2020))




