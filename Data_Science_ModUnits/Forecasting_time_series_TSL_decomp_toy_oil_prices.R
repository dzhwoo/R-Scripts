#goals

#import oil dataset has 2011 to 2015 data
ds<-read.csv('C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Input Files/oil_price.csv',
             header = TRUE)

ds$Date<-as.Date(ds$Date,"%m/%d/%y")
str(ds)

plot(ds)

#then determine seasonal, trend factors using stl , loess method
library(forecast)

#need to covert into time series

#assume ds is sorted
ds_ts<-ds[order(ds$Date),] 

ds_ts<-ts(ds_ts$OilPrice,start=c(2011,2,14),frequency = 52)
plot(ds_ts)

# s.window = periodic, i assume season repeats each yeat
# t.window = 52 weeks. Want to look at trend per year, remove seasonalityies.
model<-stl(ds_ts,s.window = "periodic",t.window = 52)

plot(model)

monthplot(model$time.series[,"seasonal"], main="", ylab="Seasonal", phase = cycle(ds_ts))

model$time.series[,"seasonal"]

#forecast following year

predict<-forecast(model,method=c("arima"),h=52,level = c(90, 95))
plot(predict)
summary(predict) # here i look at RMSE as a bench mark
accuracy(predict)

# guage what the accuracy level is