library(tsoutliers)
library(expsmooth)
library(fma)

################ Lego brick 1 - Lets load the data in

########### Read data ###############
ds<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Alpha/Input Files/2_Store_31_item_9_2012_only.csv",
             header = TRUE, sep = ",")

# Do a hello world, see all columns loaded and what their types are being read in
str(ds)

#now do any conversions needed
ds$orig_date<-as.Date(ds$orig_date,"%m/%d/%Y")

#and then finally check what the columns look like
summary(ds)

################ Lego brick 2 - lets do the time series decomposition. Let's see the seasonality and trends. 
# Let's pick the store with the most weather events and flunctuates the most.
# down the road we want this to be a type of loop
# pictures pictures, keep the brain engaged

########## Create Model #############
# Load R library
library(forecast)
library(stats)

#############Lega brick 2a - prep train set
##### Prep data sets

all_ds<- ts(ds$units, frequency=7, start = c(2012, 1))
plot(all_ds)

fit1 <- stl(all_ds,  s.window="periodic", t.window = 365)
plot(fit1)

auto.arima(fit1$time.series[,3])

plot(forecast(auto.arima(fit1$time.series[,3])))

test=acf(all_ds)
pacf(all_ds)


test=acf(fit1$time.series[,3])
pacf(fit1$time.series[,3])


n <- 2000
m <- 200
y <- ts(rnorm(n) + (1:n)%%100/30, f=m)
plot(y)

fourier <- function(t,terms,period)
{
  n <- length(t)
  X <- matrix(,nrow=n,ncol=2*terms)
  for(i in 1:terms)
  {
    X[,2*i-1] <- sin(2*pi*i*t/period)
    X[,2*i] <- cos(2*pi*i*t/period)
  }
  colnames(X) <- paste(c("S","C"),rep(1:terms,rep(2,terms)),sep="")
  return(X)
}

library(forecast)
fit <- Arima(y, order=c(2,0,1), xreg=fourier(1:n,4,m))
plot(forecast(fit, h=2*m, xreg=fourier(n+1:(2*m),4,m)))
plot(fit)
