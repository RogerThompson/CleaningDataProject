#  CodeBook.md
The input data to the the process is the UCI HAR Dataset. THis following is
a description of the data which is obtained from the file "features_info.txt"
It is inserted here in its entirety:


Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

#  THis describes the run_analysis.R file

R code to read in  the course project dataset and produce tidy data

This file editied in GNU Emacs

>Note: As J. Adler indicates on pg 151 of "R in a Nutshell"
        R is not the best language for preprocessing data.
        I would normally use Perl, but that is outside the
        scope of this assignment.


By specification this function has no parameters
It is the case then that many things will be hard coded

ASSUMPTION: this program will be ruin in a directory that
has the source data set will be in a directory named "UCI HAR Dataset"

This directory will have been unzipped without alteration

This script will do the following steps (not neccessarily in this order):
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.
  5. From the data set in step 4, creates a second, independent tidy data set
     with the average of each variable for each activity and each subject.


First we read the features (features.txt) which are the column headings or variable names.
Then, we read the map activities.txt which maps the activity number to a textual name.

We now get the training data and the testing data, each of which contains three files:
1. subjects which a single column of numbers identifying the person on whom the
 measurements were taken.

2. activity which is a single column of numbers specifying what the subject was doing at the
time the meaurement uwas taken.

3. measurements which is all the measurements taken at a measurment interval.

These six pieces of data are combined together by binding by rows, so for example the measurements
are stacked with the test data first followed by the training data.  This yelds three objects: comb.subjects,
comb.activity, comb.measurements (comb => combied).

These three pieces are then put together column-wise to form one data frame.

Then, the activities object is merged the the big data frame.

The column names are constructed by appending "activity", "activityName", and "subject" to
the front of the features data. This 1 row is used to change the dataframe of the big object.
As there are some duplicate names for the measurements in the features file, the big object was
specifically converted to a data.frame with check.names set to true. This adds a number to deduplicate names

Once this big data.frame is constructed and named it is converted to a data.table via dplyr.
This is done to make it easy for subsequent manipulation.  With the data.table we extract another data.table
that is reduced to the subject and activityName columns and any column that contains either "mean" or "std"
in its name.

The problem specification says to compute means of each mean and std data for each subject/activity. We use the dplyr
verb 'group_by' to do the grouping.  WIth these groupings we use the dplyr function to summarizethe data and supply it
with the 'mean' function.  It is then written out without row names.


