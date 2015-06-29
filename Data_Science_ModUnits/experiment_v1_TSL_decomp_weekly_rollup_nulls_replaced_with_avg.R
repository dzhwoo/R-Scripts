# when doing this concept of experiments and also lego bricks - can swap in and out



library(zoo)

################ Lego brick 1 - Lets load the data in

########### Read data ###############
ds<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Cleaned_Data/v1_allstores_allitems_weekly_rollup_nulls_replaced_with_avg_36days.csv",
             header = TRUE, sep = ",")

# Do a hello world, see all columns loaded and what their types are being read in
str(ds)

#now do any conversions needed
ds$week_start_date<-as.Date(ds$week_start_date,"%m/%d/%Y")

#and then finally check what the columns look like
summary(ds)

################ Lego brick 2 - lets do the time series decomposition. Let's see the seasonality and trends. 
# Let's pick the store with the most weather events and flunctuates the most.
# down the road we want this to be a type of loop
# pictures pictures, keep the brain engaged

########## Create Model #############
# Load R library
library(forecast)

#############Lega brick 2a - prep train set
##### Prep data sets
ds_patient_zero<-subset(ds, store_nbr == 10 & item_nbr == 5)
all<-ds_patient_zero
all<-all[ order(ds_patient_zero$week_start_date , decreasing = FALSE ),]
all_ds<-all$units_nulls_filled

all_ds<- ts(all_ds, frequency=52, start = c(2012, 1))
plot(all_ds)

summary(ds_patient_zero)

# Train set use more, use 2 years of data
train <-subset(ds_patient_zero, week_start_date <= "2013-12-31")
summary(train)

# need to make sure this is ordered as well
head(train)
train<-train[ order(train$week_start_date , decreasing = FALSE ),]

train_ds<-train$units_nulls_filled
summary(train_ds)

#convert to time series
train_ts<- ts(train_ds, frequency=52, start = c(2012, 1))
plot(train_ts)


###############Lego brick 2b - now do test set

# test set use more, use 1 years of data
test <-subset(ds_patient_zero, week_start_date >= "2014-01-01" & week_start_date <= "2014-12-31")
summary(test)

# need to make sure this is ordered as well
head(test)
test<-test[ order(test$week_start_date , decreasing = FALSE ),]

test_ds<-test$units_nulls_filled
summary(test_ds)

test_ds_mini<-head(test_ds,26)

#convert to time series
test_ds<- ts(test_ds, frequency=52, start = c(2014, 1))
plot(test_ds)

test_ds_mini<-ts(test_ds_mini, frequency=52, start = c(2014, 1))


########## Lego brick 3 - now decompose


#Perform STL decomposition. This assumes an additive model but there are ways to transform multiplicative to additive
fit1 <- stl(train_ts,  s.window="periodic", t.window = 52)
plot(fit1)

summary(fit1)
accuracy(forecast(fit1,h = 52))
accuracy(forecast(fit1,h = 26,method=c("arima")),test_ds_mini)

plot(test_ds_mini)

plot(forecast(fit1,h = 26))
lines(test_ds_mini,col="purple")

plot(test_ds)

test<-forecast(fit1,h = 44,method=c("arima"))$mean



########## Output data #########
#Get prediction from the trained model
file_path = "C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Analysis/"
file_name = "test4_weeklyrollup.csv"
paste(file_path, file_name, sep="")


write.table(test, file =paste(file_path, file_name, sep=""),sep =",",col.names=TRUE)
