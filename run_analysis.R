# 0 - You should create one R script called run_analysis.R that does the following:

library(plyr)

if (!file.exists(zipfile)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, zipfile)
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
  }
}

# 1 - Merges the training and the test sets to create one data set

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt") ; xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
allx <- rbind(xtrain, xtest)

ytrain <- read.table("UCI HAR Dataset/train/y_train.txt") ; ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
ally <- rbind(ytrain, ytest)

# 2 - Extracts only the measurements on the mean and standard deviation for each measuremen

features <- read.table("UCI HAR Dataset/features.txt")
my_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- allx[, my_features]
names(allx) <- features[my_features, 2]

# 3 - Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
ally[, 1] <- activities[ally[, 1], 2]
names(ally) <- "Activity"

# 4 - Appropriately labels the data set with descriptive variable names

subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt") ; subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
allsubject <- rbind(subjecttrain, subjecttest)
names(allsubject) <- "Subject"
data <- cbind(allx, ally, allsubject)

# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

melted_data <- melt(data, id = c("Subject", "Activity"))
datameans <- dcast(melted_data, Subject + Activity ~ variable, mean)

write.table(datameans, "tidy_data2.txt", row.names = F)