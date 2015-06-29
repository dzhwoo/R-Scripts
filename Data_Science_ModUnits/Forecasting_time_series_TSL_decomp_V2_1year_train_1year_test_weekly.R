#library(csv)
library(zoo)

ds<-c("01/01/12")
as.Date(ds)
typeof(as.Date(ds, format = "%m/%d/%y"))
########### Read data ###############
ds<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/data_sets_for_modeling/1_train_walmart_station2_deweatherize_and_nulls_replaced_weekly_rollup.csv",
             header = TRUE, sep = ",")

head(ds$event_Dt)

ds$orig_date<-as.Date(ds$orig_date,"%m/%d/%Y")
str(ds)
summary(ds)


########## Create Model #############
# Load R library
library(forecast)

##### Prep data sets
train <-subset(ds, orig_date <= "2013-12-31")
#train <-subset(ds, orig_date <= "2012-12-31")
summary(train)
train_ds<-train$units_normalized
summary(train_ds)

test <-subset(ds, orig_date >= "2014-01-01" & orig_date <= "2014-12-31")
summary(test)
test_ds<-test$units_normalized
summary(test_ds)

train_ts<- ts(train_ds, frequency=52, start = c(2012, 1))
plot(train_ts)

test_ts<- ts(test_ds, frequency=52, start = c(2014, 2))
plot(test_ts)

#Perform STL decomposition. This assumes an additive model but there are ways to transform multiplicative to additive
fit1 <- stl(train_ts,  s.window="periodic", t.window = 52)
plot(fit1)

summary(fit1)
accuracy(forecast(fit1,h = 52))
accuracy(forecast(fit1,h = 42,method=c("arima")),test_ts)
plot(forecast(fit1,h = 42))

test<-forecast(fit1,h = 42,method=c("arima"))$mean


########## Output data #########
#Get prediction from the trained model
file_path = "C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/"
file_name = "test4_weeklyrollup.csv"
paste(file_path, file_name, sep="")


write.table(test, file =paste(file_path, file_name, sep=""),sep =",",col.names=TRUE)
