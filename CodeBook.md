---
title: "run_analysis.R Codebook"
author: "Trevor Holder"
date: "January 8, 2022"
output:
  html_document:
    keep_md: yes
---

## Project Description
The run_analysis.r script prepares a tidy data set based on a the following 5 step process:
	
	1. Downloading and Extracting the data set.
	2. Assigning data to variables and Uses descriptive activity names to name the activities in the data set.
	3. Merges the training and the test sets to create one data set.
	4. Extracts only the measurements on the mean and standard deviation for each measurement. 
	5. Appropriately labels the data set with descriptive variable names. 
	6. From the data set in step 5, creates a second, independent tidy data set with
	   the average of each variable for each activity and each subject.


##Study design and data processing

###Collection of the raw data
Data is downloaded from a specific location and stored in the working directory within a "UCI HAR Dataset" folder 

###Notes on the original (raw) data 
The raw data stored in the "UCI HAR Dataset" folder consists of the following files:

features.txt
  List of all features and their corresponding identifier (561 obs of 2 variables)
  Variable name: "featuresdata"


activity_labels.txt
  List of all activity names with their corresponding identifier (6 obs of 2 variables)
  Variable name: "activitylabels"


test/subject_test.txt
  Identifies the subject who performed the activity (2947 obs of 1 variable)
  Variable name: "subjecttestdata"
  
test/X_test.txt
  Test data set containing recorded data corresponding to subjects identified in subject_test.txt (2947 obs of 561 variable)
  Variable name: "xtestdata"

test/y_test.txt
  Test label identifiers corresponding to the test data rows (2947 obs of 1 variable)
  Variable name: "ytestdata"
  

train/subject_train.txt
  Identifies the subject who performed the activity (7352 obs of 1 variable)
  Variable name: "subjecttraindata"
  
train/X_train.txt
  train data set containing recorded data corresponding to subjects identified in subject_train.txt (7352 obs of 561 variable)
  Variable name: "xtraindata"

train/y_train.txt
  train label identifiers corresponding to the train data rows (7352 obs of 1 variable)
  Variable name: "ytraindata"






##Creating the tidy datafile

###Guide to create the tidy data file

1. Downloading and unpacking the data

      The data is downloaded as a ".zip" file and unzipped to the working
      directory named "UCI HAR Dataset".
      
      The download code attempts to identify the environment of the users system
      (Windows/OSX/Linux) to ensure proper delivery of the data.


2. Loading required library (Optional code needed)

2. Variable assignments

      Each raw data file is assigned to a variable and decriptive variable names
      are assigned to the data tables.
      
      featuresdata <- features.txt (561 obs of 2 variables)
        Column name changes:
          featureid <- V1
          featurename <- V2
          
            featuresdatacolname <- featuresdata$featurename (chr [1:561])
              Creates a character vector from "featuresdata" for use with colnames()
              to replace column names in the "xtraindata" and "xtestdata" dataframes.
      
      
      activitylabels <- activity_labels.txt (6 obs of 2 variables)
        Column name changes:
          activityid <- V1
          activity <- V2

          
      subjecttestdata <- subject_test.txt (2947 obs of 1 variables)
        Column name changes:
          subject <- V1


      xtestdata <- X_test.txt (2947 obs of 561 variables)
        Column name changes (V1 to V561):
          Column names are assigned from the "featuresdatacolname" vector using
          colnames(xtestdata) <- featuresdatacolname

      ytestdata <- y_test.txt (2947 obs of 1 variables)
        Column name changes:
          activityid <- V1


      subjecttraindata <- subject_train.txt (7352 obs of 2 variables)
        Column name changes:
          subject <- V1


      xtraindata <- X_train.txt (7352 obs of 561 variables)
        Column name changes (V1 to V561):
          Column names are assigned from the "featuresdatacolname" vector using
          colnames(xtraindata) <- featuresdatacolname

      ytraindata <- y_train.txt (7352 obs of 1 variables)
        Column name changes:
          activityid <- V1


3.  Combining the data into a single data frame

      Combining the data into a single data frame is completed in 3 steps as
      described below.
      
      Step 1: Joining Activity Labels to Activity list for "test" data:
      
        activitydatatest (2947 obs of 2 variables) is created by joining
        "activitylabels" to "ytestdata" by "activity" column using a "left_join"  


      Step 2: Joining Subject, Activity and "test" data
        
        activityanalysistest (2947 obs of 563 variables) is created by merging
        "subjecttestdata" to "activitydatatest" selecting only the "activity" 
        column, and "xtestdata" using c_bind()


      Step 3: Joining Activity Labels to Activity list for "train" data
        activitydatatrain (7352 obs of 2 variables) is created by joining
        "activitylabels" to "ytraindata" by "activity" column using a "left_join"


      Step 4: Joining Subject, Activity and "train" data
        
        activityanalysistrain (7352 obs of 563 variables) is created by merging
        "subjecttraindata" to "activitydatatrain" selecting only the "activity" 
        column, and "xtraindata" using c_bind()

        NOTE: activityid numbers are replaced by activity names in this step


      Step 5: Combining "test" and "train" data
        
        activityanalysisttidy (10299 obs of 563 variables) is created by merging
        "activityanalysisttest" to "activitydatatrain" using c_bind()

4.  Extracts only the measurements on the mean and standard deviation for each measurement

      activityanalysisttidy (10299 obs of 88 variables) is created by subsetting
      the data frame using dplyr::select().
        Columns included:
          subject
          activity
          column names containing "mean" or "std"


5.  Using descriptive names for column names

      Column names for the data are adjusted to more descriptive names based on
      the feature descriptions in features_info.txt.
      
      All columns starting with "t" are adjusted to start with "Time."
      All columns starting with "f" are adjusted to start with "Frequency."
      All columns containing  "[Aa]cc" are adjusted to "Accelerometer"
      All columns containing  "[Gg]yro" are adjusted to "Gyroscopic"
      All columns containing  "[Mm]ag" are adjusted to "Magnitude"
      All columns containing  "[Bb]ody[Bb]ody" are adjusted to "Body"
      All columns containing  "-[Mm]ean" are adjusted to ".Mean"
      All columns containing  "-[Mm]eanFreq" are adjusted to ".MeanFrequency"
      All columns containing  "-[Ss]td" are adjusted to ".STD"
      All columns containing  "[-[Aa]ngle" are adjusted to "Angle"
      All columns containing  "(tBody" are adjusted to "(Time.Body"


6.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject

      independenttidy data (180 obs of 88 variables) is created by using
        group_by() to group the data by subject and activity columns
        summarize() to calculate the mean for each column
      
      write.table() is used to export the tidy data set into "Independent Tidy Data.txt"
      


##Sources
Download and Unpack files adjusted based on original code by Len Greski https://github.com/lgreski/datasciencectacontent/blob/master/markdown/rprog-downloadingFiles.md

