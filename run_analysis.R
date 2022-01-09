
### Download and Unpack files - Original Code by Len Greski https://github.com/lgreski/datasciencectacontent/blob/master/markdown/rprog-downloadingFiles.md

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfilename <- "getdata_projectfiles_UCI HAR Dataset.zip"
dlMethod <- "curl" # sets default for OSX / Linux
if(substr(Sys.getenv("OS"),1,7) == "Windows") dlMethod <- "wininet"
if(!file.exists(zipfilename)) {
      download.file(fileUrl,
                    destfile = zipfilename,  # stores file in R working directory
                    method=dlMethod) # use OS-appropriate method
}

if (!file.exists("UCI HAR Dataset")) { 
      unzip(zipfilename) 
}


### Required Library List1
library(dplyr)


### Loading Universal Data Tables: features and activity_labels

## Features List Table - features.txt - 561 obs of 2 variables
featuresdata <- read.table(file = ".\\UCI HAR Dataset\\features.txt", col.names = c("featureid", "featurename"))

## Creating Column names out of features list
featuresdatacolname <- featuresdata$featurename   ## Creates a character vector - for use with colnames() to create column names


## Activity Labels - activity_labels.txt - 6 obs of 2 variables
activitylabels <- read.table(file = ".\\UCI HAR Dataset\\activity_labels.txt", col.names = c("activityid", "activity"))


## Loading Test data: subject_test, X_test, y_test 
#--------------------------------------------------------------

## Test Subjects - subject_test.txt - 2947 obs of 1 variable
subjecttestdata <- read.table(file = ".\\UCI HAR Dataset\\test\\subject_test.txt", col.names = c("subject"))

## Activity ID for Rows - y_test.txt - 2947 obs of 1 variable
ytestdata <- read.table(file = ".\\UCI HAR Dataset\\test\\y_test.txt", col.names = c("activityid"))

## Test Data - X_test.txt - 2947 obs of 561 variables
xtestdata <- read.table(file = ".\\UCI HAR Dataset\\test\\X_test.txt")
colnames(xtestdata) <- featuresdatacolname   ## Assigns the character vector as the column names


## Joining Test data
#--------------------------------------------------------------

##  Joining Activity Labels to Activity list
activitydatatest <- ytestdata %>% left_join(activitylabels, by = "activityid")   ## Join the activity list with activity labels


## Joining the subjecttest list with activity and xtestdata
activityanalysistest <- cbind(subjecttestdata, activity = activitydatatest$activity, xtestdata)   ## Combines the rows without changing the order



## Loading Train data: subject_train, X_train, y_train 
#--------------------------------------------------------------

## Train Subjects - subject_train.txt - 2947 obs of 1 variable
subjecttraindata <- read.table(file = ".\\UCI HAR Dataset\\train\\subject_train.txt", col.names = c("subject"))

## Train Data - X_train.txt - 2947 obs of 561 variables
xtraindata <- read.table(file = ".\\UCI HAR Dataset\\train\\X_train.txt")
colnames(xtraindata) <- featuresdatacolname   ## Assigns the character vector as the column names

## Activity ID for Rows - y_train.txt - 2947 obs of 1 variable
ytraindata <- read.table(file = ".\\UCI HAR Dataset\\train\\y_train.txt", col.names = c("activityid"))


## Joining Train data
#--------------------------------------------------------------

##  Joining Activity Labels to Activity list
activitydatatrain <- ytraindata %>% left_join(activitylabels, by = "activityid")   ## Join the activity list with activity labels

## Joining the subjecttrain list with activity
activityanalysistrain <- cbind(subjecttraindata, activity = activitydatatrain$activity, xtraindata)   ## Combines the rows without changing the order



## Combining Train and Test data
#--------------------------------------------------------------

## Full Combine of data (future) - Testing with activity analysis
activityanalysistidy <- rbind(activityanalysistest, activityanalysistrain)



## Filtering to mean() and std()
#--------------------------------------------------------------

## Filtering Samples - mean() and std()
activityanalysistidy <- activityanalysistidy %>% select(subject, activity, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE))



## Renaming data columns
#--------------------------------------------------------------

## Appropriate Names
names(activityanalysistidy)<-gsub("^t", "Time.", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("^f", "Frequency.", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("[Aa]cc", "Accelerometer", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("[Gg]yro", "Gyroscopic", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("[Mm]ag", "Magnitude", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("[Bb]ody[Bb]ody", "Body", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("-[Mm]ean\\()", ".Mean", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("-[Mm]eanFreq\\()", ".MeanFrequency", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("-[Ss]td\\()", ".STD", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("[Aa]ngle", "Angle", names(activityanalysistidy))
names(activityanalysistidy)<-gsub("\\(tBody", "\\(Time.Body", names(activityanalysistidy))



## Creating an independent data set - Average of each variable
#--------------------------------------------------------------

independenttidy <- activityanalysistidy %>%
      group_by(subject,activity) %>%
      summarize(across(everything(), list(mean)))
      

## Write the independent tidy data set
#--------------------------------------------------------------

write.table(independenttidy, "Independent Tidy Data.txt", row.name=FALSE, col.names = TRUE)

