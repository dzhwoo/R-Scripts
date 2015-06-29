library(tsoutliers)
library(expsmooth)
library(fma)

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


outlier.train_ts <- tsoutliers::tso(train_ts,types = c("AO", "LS", "TC", "SLS"), maxit = 1, 
                                    remove.method = "bottom-up", tsmethod = "arima", 
                                    args.tsmethod = list(order = c(0, 1, 1), 
                                                         seasonal = list(order = c(0, 1, 1))))
outlier.train_ts
plot(outlier.train_ts)

# can this be done in sql?
RMSE <- sqrt(mean((y-y_pred)^2))

