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

# HYPOTHESIS: Below are the hypothesis to test:

#Pepper: What type of problem is this?
#David: This is a time series forecasting problem. Oh ya and this is a retail problem
#Pepper: Ah retail...that gives me some hints as well

#Pepper: Got it...hmm let me check my corpus to see what I should test for....
"Corpus:
Seasonality: Monthly, Weekly,Daily
Trend: Year over year
Holidays:
Autocorrelation
  - between recent days
  - between recent week"
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

# Numerical to numerical - we have this test - we are using linear regression/anova to test linear correlation
# Categorical to Numerical - #

# Can use ANOVA if have more than two levels for an independent variables
# for each level can we tell which is significant?

library(sqldf)

# This is still good. This is a module can be generalized. Testing for significance. 
#Can we use the same but now test for fri_delta
#Can it take a JSON?

#SCENARIO: say we want to look at the delta between fri and sat vs sat and sun

# 1. Data time........start with what data to use? or which features to create?
# Filters
# New Features

#How to generalize this? Can we deconstruct this?

# Features : a.orig_date, a.Weeknum_4week, units_Sun, units_Sat, units_Fri
# Filters:
# Joins: 

#filters = "and a.Year = 2012 and a.dayofweek= 7"
filters = "and a.Year = 2012"
Features_list = "SELECT a.orig_date,b.orig_date,a.dayofweek,a.Weeknum_4week ,b.dayofweek as dayofweek_prev, a.unitsP,b.unitsP as units_prev"

Query = "SELECT a.orig_date,a.dayofweek,a.Weeknum_4week,
              b.orig_date,b.dayofweek as dayofweek_prev,
              c.orig_date,c.dayofweek as dayofweek_prev,
              a.unitsP as units_Sun,b.unitsP as units_Sat,c.unitsP as units_Fri,
              c.unitsP - b.unitsP as dlt_Fri_Sat, b.unitsP - a.unitsP as dlt_Sat_Sun
              FROM data a , data b, data c
              where a.dayofweek = b.dayofweek + 1
              and a.dayofweek = c.dayofweek + 2
              and a.Year = b.Year
              and a.Weeknum = b.Weeknum
              and a.Year = c.Year
              and a.Weeknum = c.Weeknum
              "
Final_query<-paste(Query,filters,sep="")

Query = "SELECT a.orig_date,a.dayofweek,a.Weeknum_4week,
              b.orig_date,b.dayofweek as dayofweek_prev,
              c.orig_date,c.dayofweek as dayofweek_prev,
              a.unitsP as units_Sun,b.unitsP as units_Sat,c.unitsP as units_Fri,
              c.unitsP - b.unitsP as dlt_Fri_Sat, b.unitsP - a.unitsP as dlt_Sat_Sun
              FROM data a , data b, data c
              where a.dayofweek = b.dayofweek + 1
              and a.dayofweek = c.dayofweek + 2
              and a.Year = b.Year
              and a.Weeknum = b.Weeknum
              and a.Year = c.Year
              and a.Weeknum = c.Weeknum
              and a.Year = 2012
              and a.dayofweek= 7"

data_2012_weekend_delta <- sqldf(gsub("\n", "", Final_query))


#1b. Let's check the data
str(data_2012_weekend_delta)
head(data_2012_weekend_delta)
summary(data_2012_weekend_delta)


data_cleaned<-data_2012_weekend_delta
summary(data_cleaned)

data_cleaned$dayofweek<-factor(data_cleaned$dayofweek)
data_cleaned <- na.omit(data_cleaned)


#Maybe we need some indicators...need some objective measures.
#i.e linear regression or testing for correlation

library(plyr)
models <- dlply(data_cleaned, "Weeknum_4week", function(data_cleaned) {
  lm(data_cleaned$dlt_Sat_Sun ~ data_cleaned$dlt_Fri_Sat, data = data_cleaned)} )


# this will help us get the p values
anovas <- llply(models, anova)

models
anovas

# So interesting...This

# For delta: week 0 and 1 are significant. Week 3 almsot significant
# Should we plot it? Is this similar for 2013?
# For 2013: onyl week 1 
# For 2014: Looks like strong correlation

# Also are we grouping weeks? This is good, it is becoming more and more generalizable...

require ("lattice")
# how to order this?
# Have to make it a factor as well
# Plotting definetely helps
str(data)
data$Weeknum_4week<-factor(data$Weeknum_4week)
xyplot(data_cleaned$dlt_Sat_Sun ~ data_cleaned$dlt_Fri_Sat | Weeknum_4week, data, pch= 2,as.table=TRUE,strip=strip.custom(strip.names=1),
       type = c("p", "r"), col.line = "darkorange", lwd = 4)

# Can we now explore the features

# Say we are predicting Sun. can it learn from the features and store the results

# Store range and some generalizable index?

#Pepper/Olivia
# David: Can we try storing our results, so we can review over time
# Pepper: Ok how should I? Maybe this is more a nice to have

# Maybe build the capabilities of testing first....

#so built another capabilities - cat on numerical effect. Then just use visual effect
# use anova to see if they are significant. If there are significant then just inspect visually.

fit<-aov(data_cleaned$units_Fri ~ data_cleaned$Weeknum_4week,data = data_cleaned)

# Maybe for this we start with day of week. Know that this is significant. Then after this refine?
fit<-aov(data_cleaned$units_Fri ~ data_cleaned$dayofweek + data_cleaned$Weeknum_4week ,data = data_cleaned)
summary(fit)
plot(fit) # diagnostic plots

#So interesting weeknum has effect on Sun

