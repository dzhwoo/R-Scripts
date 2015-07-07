# Goals take a time series data set 
# First thing is visualize see what is going on
# Second thing is start to generalize any repeatable patterns. Start quantifying.

# like deep learning start highlevel. get the most obvious then nip pick

#like the idea of calling it a sample, meaning that it's not the full population so we want to intepret abt the population
sample<-read.csv('C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Gamma/Exp_A/Dept92_All_stores.csv')

#like this idea. Need to check how they are being represented
str(sample)
sample$Date<-as.Date(sample$Date,"%m/%d/%Y")

#also assume weekly_sales is in units
# why is there decimals...oz?
# for now assume revenue, is there any stores that have 
# most of them do not round up to whole # so most likely dollars. Also, have to coincide with markdowns
# so could this be price increases or more people buying. Likely that more people buying. people expect same prices
# also prices shouldnt flunctuate so much as supply would be somewhat maintained

#High level then low level

####################### AGGREGATION ########################################

#Can we aggregate across stores

#option A preaggregate
library(plyr)
sample.new<-ddply(sample, .(Date,Weeknum,Year,IsHoliday),summarise,Weekly_Sales = sum(Weekly_Sales))
str(sample.new)
ddply(sample, .(Year),summarise,Weekly_Sales = sum(Weekly_Sales))

# now how to aggreate across stores
plot(Weekly_Sales ~ Date, data = sample.new, type = 'l')

mean(sample$Weekly_Sales)
sum(sample$Weekly_Sales)


####################### VISUALIZATION ########################################

library(lattice) # xyplot
library(latticeExtra) # layer_, panel.xblocks
library(gridExtra) # grid.arrange
library(RColorBrewer) # brewer.pal
library(ggplot2)

# several options for plotting
# need to overlap that is more useful

# this splits vertically
xyplot(Weekly_Sales ~ Weeknum | Year, sample.new, type = "l", layout = c(1, 3))

# this splits horizontally
xyplot(Weekly_Sales ~ Weeknum | Year, sample.new, type = "l", auto.key = list(lines = TRUE, points = FALSE))

# simple overlap plot
xyplot(Weekly_Sales ~ Weeknum, sample.new, group = Year, type = "l",
       auto.key = list(lines = TRUE, points = FALSE))

#this seems clearer
ggplot(sample.new, aes(Weeknum,Weekly_Sales)) + 
  geom_line( aes(colour = factor(Year) ),size = 1)  + 
  geom_point( aes(shape = factor(Year)),size = 3)

# this is helpful, by makring holidays so we know what is going on
ggplot(sample.new, aes(Weeknum,Weekly_Sales)) + 
  geom_line( aes(colour = factor(Year) ),size = 1)  + 
  geom_point( aes(color = factor(IsHoliday)),size = 3.5)



str(sample.new)
summary(sample.new)

plot()

# now show seasonality for simplicity
library(forecast)
sample.new.subset<-subset(sample.new, Date >= "2010-01-01" & Date <= "2012-02-28")

train_ts<- ts(sample.new.subset$Weekly_Sales, frequency=52, start = c(2010, 2,5))
plot(train_ts)

fit1 <- stl(log(train_ts),  s.window="periodic", t.window = 52)
plot(fit1)

#also look at the trend line does this seem ok
#check remainder can plot this and make sure meets assumptions.
#what would we expect to see here

summary(fit1)

#why is this not working
accuracy(forecast(fit1))

#if so then MAPE of 1.3% that seems reasonable

#next steps simple....how is the prediction?
#maybe this is where framing the problem is important or reframing the problem is important...
#maybe it's typical in exploring what we can solve from the problem
#2010 predicts 2011

# start with idea first then backwards. Set the bar high first then come to reality
# Predict rest of 2012, 2013. 2012 Nov to 2013 July (07) - so about 9 months. at the weekly level. Predict the next year
# Given 2.5 years predict 1 year in advance

#theoratically seasonality per year is betters

# what is the intution behind this?
# wanted to show the pay period more distinct
# also trend
# remainder see 2012 is low then 2013 is high back up again
# also for remainder can see autocorrelation?

#remainder shows the autocorrelation

# What general statements can we make at this point? 

# Across stores, 
    #2010 to 2011. 
        # Seasonality = very similar - can we quantify this
        # Trends = especially in the tail end of the year increases in sales. Assume prices remain constant
    #2011 to 2012
        #Seasonality = before typical spikes there is an uptick

    #also note that 2012 is a leap year so that's why the holidays may be offset
    #visualization is key, also starting at a high level helps

    #start with what we know first....the most obvious first
    #we know seasonality for 2010 and 2011 looks imilar can we quantify this

# Questions
    # does it look like 2012 is shifted one week forward? Because of that one day it shifts it so much?
    # i can possibly get the week offsets
    # how can we normalize and compare them? Do we use the holiday weeks to rebalance it?
      # why do we want to normalize? So we can compare effects promos to non-holiday and holiday...so
          #promos -     holiday , non-holiday
          #non-promos - holiday , non-holiday
          #what is the impact of the promos in this case.....
    # simple answer is should we shift 2012 backwards by 1?
    # also seems to be 3 holidays, should there be 4? Yes this is 4. Super Bowl, Labor Day, Thanksgiving, and Christmas. 

#todos
    # have todo list of things to look at
    # can we mark major holidays, there should be four of them
    # also a good concept is interaction plot for 2 treatments and dependent variable
    # can think of modules as variable types as well as # of variables


