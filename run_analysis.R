# This R script does the following:
# 0.Set working directory, download the raw data set and unzip it
# 1.Merges the training and the test sets to create one data set. 
# 2.Extracts only the measurements on the mean and standard deviation for each
#   measurement.
# 3.Uses descriptive activity names to name the activities in the data set 
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set
#   with the average of each variable for each activity and each subject.
#
# Set the working directory, download the data set and unzip it to disk.
#setwd("G:/Users/Marcel/Documents/R/coursera/getcleandata/project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip")
unzip ("dataset.zip")
#
# "features.txt" contains the column headers of "x_train.txt" and "x_test.txt",
# so should be transposed to a row of column headers for these files
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
col_features <- as.vector(features$V2)
data_train <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                         header = FALSE, sep = "", col.names = col_features)
data_test <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                        header = FALSE, sep = "", col.names = col_features)
#
# "subject_train.txt" and "subject_test.txt" contain the subject for each of
# the data-rows, and should be added to the data frames as the 1st column with
# header "subject".
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            header = FALSE, col.names = c("subject"), colClasses = c("character"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           header = FALSE, col.names = c("subject"), colClasses = c("character"))
#
# "activity_labels.txt" contains the activity referred to in "y_train.text" and 
# "y_test.txt"; the latter files contain activity codes of the data-rows, and
# should be added as the second column with header "activity_code", after
# replacing the codes with the labels from "activity_labels.txt"
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
activities_train <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                               header = FALSE, col.names = c("activity"))
activities_test <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                              header = FALSE, col.names = c("activity"))
for (i in activity_labels$V1) {
    activities_train$activity[activities_train$activity==i] <- 
        as.character(activity_labels$V2[activity_labels$V1==i])
    activities_test$activity[activities_test$activity==i] <- 
        as.character(activity_labels$V2[activity_labels$V1==i])
}
#
# add a first column with header "type" in each of the 2 data tables and fill 
# column with "train" or "test", and merge the 3 train tables into 1, and
# similar for the 3 test tables
col_train <- c(rep("TRAIN", nrow(data_train)))
col_test <- c(rep("TEST", nrow(data_test)))
data_train <- cbind(data_type = col_train, subject_train, activities_train, data_train)
data_test <- cbind(data_type = col_test, subject_test, activities_test, data_test)
#
# merge the 2 data frames into 1 and create a vector of column headers
data_merged <- rbind(data_train, data_test)
col_headers <- colnames(data_merged)
#
# Create a boolean vector by filtering col_features on "mean" or "std" in the
# header strings, subset the dataframe with this boolean vector on these columns
# (plus TRUE in the 1st 4 columns). Then Write this data set to a file.
i <- grepl("std", col_headers)
j <- grepl("mean", col_headers)
col_select <- i | j
col_select[1:3] <- TRUE
data_tidy1 <- data_merged[,col_select]
nr_sub_feat <- ncol(data_tidy1) - 3
write.table(data_tidy1, file = "tidy1.txt", row.names = FALSE)
# 
# Create a new dataframe with as columns a first column and a column per
# feature (79). The row names are the 30 subject labels and the
# 6 activity labels, whereas the rows contain the average values of the features
# subsetted for each subject or activity label. Then Write this data set to a file. 
act <- as.character(activity_labels$V2)
sub <- as.character(c(1:30))
data_tidy2 <- NULL
for (i in sub){
    data_tidy2 <- rbind(data_tidy2, colMeans(data_tidy1[data_tidy1$subject==i,c(4:(nr_sub_feat+3))]))
}
for (i in act){
    data_tidy2 <- rbind(data_tidy2, colMeans(data_tidy1[data_tidy1$activity==i,c(4:(nr_sub_feat+3))]))
}
label <- c(sub,act)
data_tidy2 <- cbind(label, data_tidy2)
write.table(data_tidy2, file = "tidy2.txt", row.names = FALSE)

