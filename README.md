coursera-getdata-002
====================

Project for Coursera's course _Getting and Cleaning Data_.
The purpose of this course is to learn how to collect data
from various sources and clean it for later analysis.

The `run_analysis.R` script contains the solution to the course's project assignment.


##Usage

1. Download the
[input dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Extract the downloaded dataset into your working directory.
3. Run method 'tidyDataset' from `run_analysis.R` script in R to produce the cleaned dataset.


## Method

1. For both trainning and test datasets, the script combines the subjects, activities, and measurement variables.
2. It gives the variables appropriate headings and translates numeric actity codes into their string equivalents.
3. It drops all variables that do not contain -mean()- or -std()- in their names.
4. The script then merges the trainning and test datasets into one dataset.
5. It creates a new dataset that contains for each combination of subject and activity the average of each variable.
6. Finally, it writes this new dataset to file "tidy_dataset.txt" in the current working directory.


## Additional Information

Please refer to [code book](CodeBook.md) for a list of variables in the output dataset.
