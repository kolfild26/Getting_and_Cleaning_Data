This document describes the steps which the **run_analysis.R** script goes through to get the final tidy data set. These are extracting data from .txt into R objects, merging the data sets into one, transforming tables and selecting only required measures.  
The script should be placed into **UCI HAR Dataset** folder

#### Read data from the .txt files
The script read data from the .txt files into R objects (data frames) using the **read.table** function. At this step we get the following frames:  

 * subject_test - subject who performed an action
 * subject_train - subject who performed an action
 * xtrain - train data
 * ytrain - y test data
 * activity_labels - type of activity
 * features - variable names

#### Combine the train and test data sets
Combining is done by using the **rbind** function.

#### Attach activity labels and subjects
the **merge** function is used for that.

#### Naming variables
 * First is extracting variable names from features
 * Then, these names is passed to column names of a final data set using the colnames() function.

### Select variables
Select only those variables which are **mean()** or **std()**  
**grep()** function is used for that.

### Rename variables
Creating descriptive variable names through **gsub()** function
The following list of patterns is used for that:

 * "BodyBody" to "Body"
 * "Acc" to "Accelerometer"
 * "Gyro" to "Gyroscope"
 * "Mag" to "Magnitude"

At the result of the steps before we have a data frame (finalDataSet) of 88 columns, 1 - activity type, 2 - subject, and 86 variables of **mean** and **std**
 
### Create a final data set
Using **group_by()** and **summarise_each** functions from **dplyr** package, create a final data set, with the average of each variable for each activity and each subject. It's called **final_avg**.
