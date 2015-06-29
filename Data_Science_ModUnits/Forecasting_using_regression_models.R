ds<-c("01/01/12")
as.Date(ds)
typeof(as.Date(ds, format = "%m/%d/%y"))
########### Read data ###############
ds<-read.csv("C:/Users/dwoo57/Google Drive/Career/Data Mining Competitions/Kaggle/Walmart - Inventory and weather prediction/Cleaned_Data/v2_item_9_store_14_features_for_regressions.csv",
             header = TRUE, sep = ",")



#head(ds$event_Dt)
#ds$orig_date<-as.Date(ds$orig_date,"%m/%d/%Y")
str(ds)
summary(ds)


### Steps
#1. Prep data: Factor values
#2 Partition Train and test data
#3. Model : Random forest then svm
#4. Cross validate and see which model better
#5. Then predict and see actual performance

#1. Prep data: Factor values
ds$dayofweek_num<-factor(ds$dayofweek_num)
ds$week_num_5wk<-factor(ds$week_num_5wk)
ds$month_num<-factor(ds$month_num)
ds$year_num<-factor(ds$year_num)
ds$qtr<-factor(ds$qtr)

ds$hol_in_same_day<-factor(ds$hol_in_same_day)
ds$hol_in_same_week<-factor(ds$hol_in_same_week)

str(ds)

#2 Partition Train and test data
train <-subset(ds, random_num <= 6 )

test <-subset(ds, random_num >= 7 )

summary(train)
summary(test)

#3. Model : Random forest then svm
library(randomForest)
str(train)
fit <- randomForest(units ~ qtr + month_num + week_num_5wk + dayofweek_num + month_Avg_units +
                      hol_in_same_day + hol_in_same_week,   data=train)
print(fit) # view results 
importance(fit) # importance of each predictor, higher value mean more improtant
accuracy(fit)

p1 <- predict(fit, test)

test$units_predict<-predict(fit,test)

##myresults$pred_paid_churn<-predict(mylogit,myresults,type="response")

write.table(test, file = "C:/Users/dwoo57/Documents/R/item9_store_14.csv", sep = ",", col.names = NA,
            qmethod = "double")


#4. Cross validate and see which model better
#5. Then predict and see actual performance