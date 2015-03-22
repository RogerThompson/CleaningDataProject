##  run_analysis.R
##  R code to read in  the course project dataset and produce tidy data
##  This file editied in GNU Emacs
##  Note: As J. Adler indicates on pg 151 of "R in a Nutshell"
##        R is not the best language for preprocessing data.
##        I would normally use Perl, but that is outside the
##        scope of this assignment.

########################################
##                                    ##
##  In no way is this code efficient  ##
##                                    ##
########################################

run_analysis <- function () {
    ##
    ##  By specification this function has no parameters
    ##  It is the case then that many things will be hard coded
    ##  Assumption: this program will be ruin in a directory that
    ##  has the source data set will be in a directory named "UCI HAR Dataset"
    ##
    ##  This directory will have been unzipped without alteration
    ##
    ##  This script will do the following steps (not neccessarily in this order):
    ##  1. Merges the training and the test sets to create one data set.
    ##  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    ##  3. Uses descriptive activity names to name the activities in the data set
    ##  4. Appropriately labels the data set with descriptive variable names.
    ##  5. From the data set in step 4, creates a second, independent tidy data set
    ##     with the average of each variable for each activity and each subject.

    ##  We are eventually going to use the dplyr library
    library(dplyr)
    default.stringsAsFactors=FALSE
    
    ## ok, now we get the data

    ##  features are the variables (column header labels) in the dataset
    filepath <- "./UCI HAR Dataset/features.txt"
    features <- read.table(filepath)

    ##  activities are a map from the numeric activity label to a descriptive textual label
    filepath <- "./UCI HAR Dataset/activity_labels.txt"
    activities <- read.table(filepath)

    ########################################
    ##
    ##  Now we get the training data
    ##

    ##  this column contains the subject identifiers
    filepath <- "./UCI HAR Dataset/train/subject_train.txt"
    train.subjects <- read.table(filepath)

    ##  This column contains the activity identifiers
    filepath <- "./UCI HAR Dataset/train/y_train.txt"
    train.activity <- read.table(filepath)

    ##  This matrix contains all the measurement data
    filepath <- "./UCI HAR Dataset/train/X_train.txt"
    train.measurements <- read.table(filepath)

    ########################################
    ##
    ##  Now we get the test data
    ##

    ##  this column contains the subject identifiers
    filepath <- "./UCI HAR Dataset/test/subject_test.txt"
    test.subjects <- read.table(filepath)

    ##  This column contains the activity identifiers
    filepath <- "./UCI HAR Dataset/test/y_test.txt"
    test.activity <- read.table(filepath)

    ##  This matrix contains all the measurement data
    filepath <- "./UCI HAR Dataset/test/X_test.txt"
    test.measurements <- read.table(filepath)

    ########################################
    ##
    ##  Now, we have to do some assembling and mapping
    ##
    ##  It is assumed that the rows line up for these two
    ##  sets of data.  That is row 1 of the activity, subject,
    ##  and measurement data all correspond.

    comb.subjects     <- rbind(test.subjects,     train.subjects,     dparse.level=0)
    comb.activity     <- rbind(test.activity,     train.activity,     dparse.level=0)
    comb.measurements <- rbind(test.measurements, train.measurements, dparse.level=0)

    comb.data <- cbind(comb.activity, comb.subjects, comb.measurements)

    ##  Add the descriptive activity labels

    comb.data.2 <- merge (activities, comb.data, by.x=1, by.y=1, sort=FALSE)

    features.new <- array(c(1:3, "activity", "activityName", "subject"), c(3,2))
    features.2   <- rbind(features.new, features)
    features.3   <- features.2[,2]
    names(comb.data.2) <- features.3

    ##  fix the duplicate column names
    comb.data.3 <- data.frame(comb.data.2, check.names=TRUE)

    ## convert to table for easy column removal    
    comb.data.tbl <- tbl_df(comb.data.3)

    ##  Reduce the table by selecting only the variables (columns) we want: means and diseases (bad joke)
    combined.reduced.tbl <- select(comb.data.tbl, activityName, subject, contains("mean"), contains("std"))

    ##  Now lets build our tidy data
    subj.act.groups <- group_by(combined.reduced.tbl, subject, activityName)

    ##  I could have combined this with the line above
    tidy <- subj.act.groups %>% summarise_each(funs(mean), contains("mean"), contains("std"))
    
    write.table(tidy, file="getdata_tidy.txt" ,row.name=FALSE)
    
} # function
