# David - represents the task
# Pepper - represents the actions


# David: Ok Pepper here is some data
data<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Beta/Data_Collection/Store_31_item_9_2012_2014.csv")

# David: Ok Pepper, what do you see?
str(data)
#Pepper: The data i'm seeing has these value types...is this correct?

# David: Make the orig_date as date <<< This could make it into JSON
data$orig_date<-as.Date(data$orig_date,"%m/%d/%Y")
str(data)

# Pepper: Ok how about now?
# David: Perfect

# Pepper: Ok here is what i am seeing.... << Possibly can visualize this....
summary(data)


#Pepper: What do you want me to do with the data?

#David: I need to predict units...anything else is to explain it.

#Pepper: Got it...let me label the column to be predicted
colnames(data)[4]<-"unitsP"

#Pepper: Next: i'll probably do some simple test on the variables. I'll use all years for now but label them differently.
#Pepper: My goal is to generalize across the board...
str(data)

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

#David: Let's start with the autocorrelations

#David: Let's start simple and then become complex...

#David: I think that Sat is correlated to Sun...but i need to know how...

#David: For each Sun, can we find the corresponding Sat?

library(sqldf)

str(data)

## inner join
data_2012 <- sqldf("SELECT a.orig_date,b.orig_date,a.dayofweek,a.Weeknum_4week ,b.dayofweek as dayofweek_prev, a.unitsP,b.unitsP as units_prev
              FROM data a , data b
              where a.dayofweek = b.dayofweek + 1
              and a.Year = b.Year
              and a.Weeknum = b.Weeknum
              and a.Year = 2012
              and a.dayofweek= 7")

data_2012_week2 <- sqldf("SELECT a.orig_date,b.orig_date,a.dayofweek,a.Weeknum_4week ,b.dayofweek as dayofweek_prev, a.unitsP,b.unitsP as units_prev
              FROM data a , data b
              where a.dayofweek = b.dayofweek + 1
              and a.Year = b.Year
              and a.Weeknum = b.Weeknum
              and a.Year = 2012
              and a.dayofweek= 7
              and a.Weeknum_4week=3")


data_2013 <- sqldf("SELECT a.orig_date,b.orig_date,a.dayofweek,a.Weeknum_4week ,b.dayofweek as dayofweek_prev, a.unitsP,b.unitsP as units_prev
              FROM data a , data b
              where a.dayofweek = b.dayofweek + 1
              and a.Year = b.Year
              and a.Weeknum = b.Weeknum
              and a.Year = 2013
              and a.dayofweek= 7")

data_2014 <- sqldf("SELECT a.orig_date,b.orig_date,a.dayofweek,a.Weeknum_4week ,b.dayofweek as dayofweek_prev, a.unitsP,b.unitsP as units_prev
              FROM data a , data b
              where a.dayofweek = b.dayofweek + 1
              and a.Year = b.Year
              and a.Weeknum = b.Weeknum
              and a.Year = 2014
              and a.dayofweek= 7")

# next only for Sunday match with Saturday
head(data_2012)
summary(data_2012)

#David: next can we do the matrix thingy...for multiple scatter plots matrix

# Basic Scatterplot Matrix
pairs(~unitsP+units_prev,data=data_2012, 
      main="Simple Scatterplot Matrix")


library(car)
scatterplotMatrix(~unitsP+units_prev|Weeknum_4week, data=data_2012,
                   main="Three Cylinder Options")

# this is good but hard to see when all on the same chart. Can do diff plot?
scatterplot(unitsP ~ units_prev | Weeknum_4week, data=data_2012, 
            xlab="units - Sat", ylab="units - Sun", 
            main="Enhanced Scatter Plot")

# This is better...maybe next can plot line or give regressions
require ("lattice")
xyplot(unitsP ~ units_prev | Weeknum_4week, data_2012, pch= 2)

require ("lattice")
xyplot(unitsP ~ units_prev | Weeknum_4week, data_2013, pch= 2)

xyplot(unitsP ~ units_prev | Weeknum_4week, data_2014, pch= 2)


# This is still good. This is a module can be generalized. Testing for significance. 
#Can we use the same but now test for fri_delta
#Can it take a JSON?

#

#Maybe we need some indicators...need some objective measures.
#i.e linear regression or testing for correlation

library(plyr)
# Break up d by state, then fit the specified model to each piece and
# return a list
models <- dlply(data_2012, "Weeknum_4week", function(data_2012) {
  lm(unitsP ~ units_prev, data = data_2012)} )

# this will help us get the p values
anovas <- llply(models, anova)
models

test<-lm(unitsP ~ units_prev, data = data_2012)

summary(lm(unitsP ~ units_prev, data = data_2012_week2))

#how to get p values from linear regression

#also, can this help us find outliers or abnormalies..
#should we compare against previous years

#Are there bench marks we can use? Add lines

#David: Pepper this is cool and love the charts...oh ya what are our hypothesis?

"Pepper: Ah good point. Here they are
1) Pay week
2) Non pay week 
3) If i shop on Sat i prob wont shop on Sun
4) If I shop on Fri, i prob wont shop on Sat
5) Mid week top up
6) Prior week shopping compared to this week"

#Pepper: I'm working on a way of testing this....

#David: Let's do one at a time then can generalize over time

