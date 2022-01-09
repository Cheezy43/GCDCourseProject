# GCDCourseProject

Getting and Cleaning Data course project.

This repository is a submission for the Getting and Cleaning Data final project.

### Project Files:

The following identifies the required files and describes the output of the project.

The **run_analysis.R** script prepares a tidy data set based on a the following steps:

    1. Downloading and Extracting the data set.
    2. Assigning data to variables and uses descriptive activity names to name the columns of the various raw data sets.
    3. Merges the training and the test sets to create one data set.
    4. Extracts only the measurements on the mean and standard deviation for each measurement. 
    5. Appropriately labels the data set with descriptive variable names. 
    6. From the data set in step 5, creates a second, independent tidy data set with
       the average of each variable for each activity and each subject.

**analysisdatatidy.txt** is the exported file of the run_analysis.R script

### Data set downloaded and extracted by the run_analysis.R script:

[Human Activity Recognition Using Smartphones Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
