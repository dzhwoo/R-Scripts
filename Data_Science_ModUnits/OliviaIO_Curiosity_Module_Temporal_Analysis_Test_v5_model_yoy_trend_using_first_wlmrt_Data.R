# David - represents the task
# Pepper - represents the actions

# David: Ok Pepper here is some data
data<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Experiments/Gamma/Train/Explanatory_Analysis/train_dept92_yoy_sales_unemployment.csv")

# David: Ok Pepper, what do you see?
str(data)


"WISH LIST
a) from date, form years, months, payperiod"


library(plyr)
models <- dlply(data, "Store_type", function(data) {
  lm(Weekly_Sales ~ Unemploy, data = data)} )


# this will help us get the p values
anovas <- llply(models, anova)

models
anovas

# usually look at coefficent to see if significant or not
fit<-lm(Weekly_Sales ~ Unemploy, data = data)
summary(fit)

# how to make this visualy appealing...more fun to work with?

plot(Weekly_Sales ~ Unemploy, data = data)
plot(fit)
