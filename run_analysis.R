## Coursera Getting and Cleaning Data Course Project
## 14 December 2016
##
## This script will do the following.
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for each measurement.
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive variable names.
##  5. From the data set in step 4, creates a second, independent tidy data set with the average
##     of each variable for each activity and each subject.

#Load libraries
library(dplyr)
library(reshape2)

#Set working directory to downloaded files
setwd("C:/Users/nh14/Dropbox (KiTEC)/Data Science - Coursera/data/UCI HAR Dataset")

#Read in the data from files
featureNames = read.table('./features.txt', header=FALSE)
activityType = read.table('./activity_labels.txt', header=FALSE)
subjectTrain = read.table('./train/subject_train.txt', header=FALSE)
trainFeatures = read.table('./train/x_train.txt', header=FALSE)
trainActivity = read.table('./train/y_train.txt', header=FALSE)
subjectTest = read.table('./test/subject_test.txt', header=FALSE)
testFeatures = read.table('./test/X_test.txt', header=FALSE)
testActivity = read.table('./test/y_test.txt', header=FALSE)

#Step 1: Merge test and train data to create 1 dataset.
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(trainActivity, testActivity)
features <- rbind(trainFeatures, testFeatures)

#Step 4: Appropriately labels the data set with descriptive variable names by labeling columns
colnames(activity)<- "activity"
colnames(featureNames)<-c("FeatureCode", "feature")
colnames(features)<-featureNames$feature
colnames(subject)<-c("ID")

#Compile complete dataset
FullDataset<-cbind(subject,activity,features)

#Step 2: Extract mean and standard deviation for each measure by taking any variable with 'mean' or 'std' in the title

meanSD <- grep(".*mean.*|.*std.*",x = names(FullDataset), ignore.case=TRUE)


#Step 3: Uses descriptive activity names to name the activities in the data set by changing the numeric values to  the descriptive
#        names from the'activity_labels' text file.
FullDataset$activity <- factor(FullDataset$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", 
                                                              "Sitting", "Standing", "Laying"))

#Step 5: Create a second, independent tidy data set with the average of each variable for each activity (activity) and each subject (ID).
tidy<-cbind(FullDataset[1:2], FullDataset[,meanSD])
tidymeans<-melt(tidy, id=c("ID", "activity"))
tidymeans<-dcast(tidymeans, ID + activity ~ variable, mean)

#Write the tidy data set to a new file.
write.csv(tidymeans, "tidy.csv", row.names=FALSE)
