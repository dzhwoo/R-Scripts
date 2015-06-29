#library(csv)
library(zoo)

ds<-c("01/01/12")
as.Date(ds)
typeof(as.Date(ds, format = "%m/%d/%y"))
########### Read data ###############
ds<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/1_train_walmart_station2_highest_rain_snow_highest_product_mod.csv",
             header = TRUE, sep = ",")

head(ds$event_Dt)

ds$event_Dt<-as.Date(ds$event_Dt,"%m/%d/%y")
str(ds)
summary(ds)

# User define horizon (horizon means the time you want to predict in future )
horizon <- 365
customer_input<- data.frame(horizon = horizon)

bz <- zoo(c(2,NA,1,4,5,2))
na.locf(bz)
na.locf(bz, fromLast = TRUE)

dsmod<-subset(ds, select=c("event_Dt","units_cleaned"))
str(dsmod)
dsmod
dsmod<-na.locf(dsmod,fromLast = TRUE)

# Select data.frame to be sent to the output Dataset port
#maml.mapOutputPort("customer_input");

########## Create Model #############
# Load R library
library(forecast)
#Data cleaning . 
# This is renaming the column
#colnames(ds) <- c("event_Dt","units") 
# use the oil_price as what to forecast
test <- dsmod$units
# define the time horizon or time window, seems 52 weeks or annual
horizon <- customer_input$horizon[1]
#Create time series data (This example has weekly data and thue frequency is 52. User can addjust when the data has different resolution.)
#The format is ts(vector, start=, end=, frequency=)
# 52 tells it that it's weekly data
# create time series object
train_ts<- ts(test, frequency=364, start = c(2012, 1))
plot(train_ts)
#Perform STL decomposition. This assumes an additive model but there are ways to transform multiplicative to additive
fit1 <- stl(train_ts,  s.window="periodic",t.window = 364)
plot(fit1)

monthplot(fit1$time.series[,"seasonal"], main="", ylab="Seasonal", phase = cycle(train_ts))


## Next steps: exploratory analysis

### a) Notice there are some outliers if you plot this
train_ts<- ts(test, frequency=364, start = c(2012, 1))
plot(train_ts)

### b) are these weather related? Can we tag points that are weather related or not? Weather - red, non weather - black
## next bring in wa


#Train model by using ETS
train_model <- forecast(fit1, h = horizon, method = 'ets')
#Visulize the prediction (User can see this graph by right clich the bottom right bubble of this module.)
plot(train_model)

## c) what is the expected accuracy of the model
## Currently, use RMSE error, this is the expected error. Take this divded by the median and then take the %. 
## So value can be between +- 17%. Ok for now but should improve over time
summary(fit1)
summary(train_model)
summary(ds)

### Test benchmark
### next steps, set up framework, to use this model across

###1. Export results
file_path = "C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/"
file_name = "test1_station2_product25_no_weather.csv"
paste(file_path, file_name, sep="")


write.table(train_model$mean, file =paste(file_path, file_name, sep=""),sep =",",col.names=TRUE)
summary(train_model)


########## Output data #########
#Get prediction from the trained model
train_pred <- train_model$mean
data.forecast <- as.data.frame(t(train_pred))
# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("data.forecast");