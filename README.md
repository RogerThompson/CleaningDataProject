# CleaningDataProject
repo of the course project for Getting and Cleaning Data
# Scripts

There is only one script in this directory: run_analysis.R.

In the real world I would have run some perl scripts to clean up the variable names
to remove characters the R does not like in column headers in data.frames. These characters
are '(', ')', ',', and '-'.

So to just take a few examples:

38 tBodyAcc-correlation()-X,Y
556 angle(tBodyAccJerkMean),gravityMean)

would have become:

38 tBodyAcc_correlation_XY
556 angle_tBodyAccJerkMean_gravityMean

This sort of transformation is trivial in Perl.
