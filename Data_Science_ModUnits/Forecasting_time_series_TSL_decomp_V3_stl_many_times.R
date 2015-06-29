#library(csv)
library(zoo)

ds<-c("01/01/12")
as.Date(ds)
typeof(as.Date(ds, format = "%m/%d/%y"))
########### Read data ###############
ds<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/1_train_walmart_station2_deweatherize_and_nulls_replacedmonthly_rolluped.csv",
             header = TRUE, sep = ",")

head(ds$event_Dt)

ds$orig_date<-as.Date(ds$orig_date,"%m/%d/%Y")
str(ds)
summary(ds)


########## Create Model #############
# Load R library
library(forecast)

train <-subset(ds, orig_date <= "2012-12-31")
summary(train)
train_ds<-train$units_normalized
summary(train_ds)

test <-subset(ds, orig_date <= "2013-12-31")
summary(train)
train_ds<-train$units_normalized
summary(train_ds)

train_ts<- ts(log(train_ds), frequency=90, start = c(2012, 1))
train_ts<- ts(train_ds, frequency=11, start = c(2012, 1))

plot(train_ts)
#Perform STL decomposition. This assumes an additive model but there are ways to transform multiplicative to additive
fit1 <- stl(train_ts,  s.window="periodic", t.window = 365)
fit1 <- stl(train_ts,  s.window="periodic")
plot(fit1)

summary(fit1)
accuracy(forecast(fit1,h = 12))
plot(forecast(fit1,h = 12))

y <- msts(train_ds, seasonal.periods=c(7,365.25),ts.frequency= 7)
y <- msts(train_ds, seasonal.periods=7,ts.frequency= 7)
y <- msts(train_ds, seasonal.periods=c(7,365))
y <- msts(train_ds, seasonal.periods=c(7,90))
plot(y)
fit <- tbats(y,use.trend = FALSE,use.damped.trend = FALSE, use.box.cox=FALSE,use.arma.errors=FALSE )

fc <- forecast(fit,h = 365)
summary(fit)
plot(fit)
summary(fc)
plot(fc)

accuracy(forecast(fit,h = 365))
test<-forecast(fit,h = 365)$mean
test

plot(forecast(fit, h=365)$residuals)  # this gets the random, the random seems high

try multiplicative seems similar. Took the log of the data

# try different method
decompearn = decompose (train_ts, type = "additive")
decompearn = decompose (train_ts, type = "multiplicative")
plot (decompearn)

summary(decompearn)
decompearn

train_model <- forecast(decompearn, h = horizon, method = 'ets')


#Train model by using ETS
train_model <- forecast(fit1, h = horizon, method = 'ets')
#Visulize the prediction (User can see this graph by right clich the bottom right bubble of this module.)
plot(train_model)
summary(train_model)

########## Output data #########
#Get prediction from the trained model
file_path = "C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/"
file_name = "test3_usetbast.csv"
paste(file_path, file_name, sep="")


write.table(test, file =paste(file_path, file_name, sep=""),sep =",",col.names=TRUE)


train_pred <- train_model$mean
write.table(train_pred,file = )

data.forecast <- as.data.frame(t(train_pred))
# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("data.forecast");