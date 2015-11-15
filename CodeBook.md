INTRODUCTION:
A detailed description of the raw data is provided in the various files which are created in the course of executing the "run_analysis.R" script. This script results in two dataframes, "data_tidy1" and "data_tidy2", and writes these to local files as "tidy1.txt" and "tidy2.txt".

DESCRIPTION OF VARIABLES IN DATA_TIDY1:
- data_type: contains "TRAIN" or "TEST" indicating whether the data comes from the raw train or test data sets
- subject: contains as character string the subject number 1-30
- activity: contains as character string the activity label as in the file "activity_labels.txt" from the raw
- features-columns: a total of 79 columns, each with one of the features from the file "features.txt" from the 
raw data set, but only those that include a mean() or std() calculation

DESCRIPTION OF VARIABLES IN DATA_TIDY2:
- label: contains as characeter string a subject number or activity label
- feature-columns: the same column headers as the corresponding columns in data_tidy1, but now with the averages of 
the data-set corresponding to a specific subject or a specific activity

DESCRIPTION OF DATA TRANSFORMATION FOR DATA_TIDY1:
- Download the raw data from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
- Unzip the raw data
- Read from "features.txt" the column headers which belong to "x_train.txt" and "x_test.txt"
- Create two data tables "data_train" and "data_test" by reading from "x_train.txt" and "x_test.txt" with column headers 
from "features.txt"
- Create two data tables "subject_train" and "subject_test" by by reading from "subject_train.txt" and "subject_test.txt" 
with column name "subject"
- Create two data tables "activities_train" and "activities_test" by reading from "y_train.txt" and "y_test.txt" and 
replacing the activity codes with the corresponding activity labels from "activity_labels.txt"
- Merge the data tables "subject_train", "activities_train" and "data_train" into one data table via cbind, and insert a 
first column with header "data_type" and value "TRAIN". Execute a similar process for the "test" tables.
- Merge the two data tables, one containing the merged train-data and the other one the merged test-data, into a single 
dataframe "data_merged"
- Create a boolean vector by filtering the column header names on "mean" and "std" and subset "data_merged" on the first 
3 columns ("data_type", "subject", "activity") plus the columns specified by the boolean vector, creating the dataframe 
"data_tidy1"
- Write "data_tidy1" to the local file "tidy1.txt"

DESCRIPTION OF DATA TRANSFORMATION FOR DATA_TIDY2:
- Create a new dataframe with a first column called "label" which will contain subject and activity labels (as strings), 
and a sequence of columns with the features, which will contain average values.
- Create a dataframe called data_tidy2 by initializing it to NULL and then adding rows one by one via rbind for each of 
the subject and activity labels, by calculating the feature averages via applying ColMeans() on the subset of data_tidy1 
for each of the subject and activity labels
- Create a character vector by concatenating the subject and activity labels, and cbind this to data_tidy2 as the first 
column with header "label"
- Write "data_tidy2" to the local file "tidy2.txt"
