
## Required Library List

library(dplyr)
library(tidyr)
library(lubridate)
library(data.table)
library(reshape)
library(reshape2)


## Loading Data Tables

## Features List Table - features.txt - 561 obs of 2 variables
featuresdata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\features.txt", col.names = c("featureid", "featurename"))
### no longer required ### featuresdata <-featuresdata %>% rename(featureid = V1, featurename = V2)  ## Rename Columns

      ## Creating Column names out of features list
      featuresdatacolname <- featuresdata$featurename   ## Creates a character vector - for use with colnames() to create column names


## Activity Labels - activity_labels.txt - 6 obs of 2 variables
activitylabels <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\activity_labels.txt", col.names = c("activityid", "activity"))
### no longer required ## activitylabels <- activitylabels %>% rename(activityid = V1, activity = V2)   ## Rename Columns


## Test Subjects - subject_test.txt - 2947 obs of 1 variable
subjecttestdata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\test\\subject_test.txt", col.names = c("subject"))
### no longer required ### subjecttestdata <- subjecttestdata %>% rename(subject = V1)   ## Rename Columns


## Activity ID for Rows - y_test.txt - 2947 obs of 1 variable
ytestdata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\test\\y_test.txt", col.names = c("activityid"))
### no longer required ### ytestdata <- ytestdata %>% rename(activityid = V1)   ## Rename Columns


## Test Data - X_test.txt - 2947 obs of 561 variables
xtestdata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\test\\X_test.txt", col.names = featuresdata$featurename)



###################################################




##  Joining Activity Labels to Activity list
activitydatatest <- ytestdata %>% left_join(activitylabels, by = "activityid")   ## Join the activity list with activity labels
## TESTING activitydatatest <- mutate(activity, V3 = rownames(activity))   ## TESTING - Adds rownames() as a column to test if the data moves when using "merge" 


## Joining the subjecttest list with activity
activityanalysistest <- cbind(subjecttestdata, activity = activitydatatest$activity, xtestdata)   ## Combines the rows without changing the order



## Assigning Column names out of features list
### NO LONGER REQUIRED ### colnames(xtestdata) <- featuresdatacolname   ## Assigns the character vector as the column names


#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
#Train Data (below)
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------


## Train Subjects - subject_train.txt - 2947 obs of 1 variable
subjecttraindata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\train\\subject_train.txt", col.names = c("subject"))
### no longer needed ### subjecttraindata <- subjecttraindata %>% rename(subject = V1)   ## Rename Columns

## Train Data - X_train.txt - 2947 obs of 561 variables
xtraindata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\train\\X_train.txt", col.names = featuresdata$featurename)

## Activity ID for Rows - y_train.txt - 2947 obs of 1 variable
ytraindata <- read.table(file = "V:\\DataScience\\Projects\\GCDCourseProject\\UCI HAR Dataset\\train\\y_train.txt", col.names = c("activityid"))
### no longer needed ### ytraindata <- ytraindata %>% rename(activityid = V1)   ## Rename Columns


###################################################


##  Joining Activity Labels to Activity list
activitydatatrain <- ytraindata %>% left_join(activitylabels, by = "activityid")   ## Join the activity list with activity labels
## TESTING activitydatatrain <- mutate(activity, V3 = rownames(activity))   ## TESTING - Adds rownames() as a column to test if the data moves when using "merge" 


## Joining the subjecttrain list with activity
activityanalysistrain <- cbind(subjecttraindata, activity = activitydatatrain$activity, xtraindata)   ## Combines the rows without changing the order



## Assigning Column names out of features list
### NO LONGER REQUIRED ###colnames(xtraindata) <- featuresdatacolname   ## Assigns the character vector as the column names





## Full Combine of data (future) - Testing with activity analysis
activityanalysistidy <- rbind(activityanalysistest, activityanalysistrain)




### WORKING ###
## Filtering Samples - mean() and std()








## MISC
table(subjecttestdata$V1) ## Create table identifying number of times a subject has data rows

testdf <- subjecttestdata %>% left_join(activity, by = rownames(activity))   ## Will only work if we add matching columns with the rownum()
