Getting and Cleaning Data Project
========================================================

Script: run_analysis.R

Data: Downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
The file was unzipped using windows explorer.  The export directory was "UCH HAR Dataset"

The Data files are explained in the files README.txt and features_info.txt of the unzipped data.


Code

Extra libraries loaded - "plyr"

Variables

************** Global Data **************

activity_labels - Used to read in the activity labels used in the data.  The activities in the dataset are coded by numbers.  This file contains the translation of those numbers.
```{r}
activity_labels <- read.table("UCI HAR Dataset//activity_labels.txt")
```

features - Used to read in the columns of activities in the dataset.  The data is not coded with column names
```{r}
features <- read.table("UCI HAR Dataset//features.txt")
```

************** Test Data **************

subject_test - Used to read in the test Subjects (people) found in the test dataset.
```{r}
subject_test<- read.table("UCI HAR Dataset//test//subject_test.txt")
```
x_test - Used to read in the main data of the test set.
```{r}
x_test<- read.table("UCI HAR Dataset//test//X_test.txt")
```
y_test - Used to read in data containing the activities for the test set
```{r}
y_test<- read.table("UCI HAR Dataset//test//Y_test.txt")
```
test_set - Used to combine the Test data from variables Subject, x_test, and y_test

test_activities - used to match the Activities codes from y_test with the activity names in activity_lables

#building test set

The following was used to set the column names of the x_test set with the feature names.  These columns are expained more in the features_info.txt
```{r}
names(x_test) <- features[,2]
```

The test_set variable was built first by assigning it to the Subjects and then by combining the x_test data
```{r}
test_set <- subject_test
test_set <- cbind(test_set, x_test)
```

The activities were matchup from the y_test set using the join command and then added back to the test_set
```{r}
test_activities <- join(y_test, activity_labels)
names(test_activities) <- c("Activity_Code", "Activity_Name")
test_set <- cbind(test_set, test_activities)
```


************** Training Data **************

subject_train - Used to read in the train Subjects (people) found in the train dataset.
```{r}
subject_train<- read.table("UCI HAR Dataset//train//subject_train.txt")
```
x_train - Used to read in the main data of the train set.
```{r}
x_train<- read.table("UCI HAR Dataset//train//X_train.txt")
```
y_train - Used to read in data containing the activities for the train set
```{r}
y_train<- read.table("UCI HAR Dataset//train//Y_train.txt")
```
train_set - Used to combine the train data from variables Subject, x_train, and y_train

train_activities - used to match the Activities codes from y_train with the activity names in activity_lables

#building train set

The following was used to set the column names of the x_train set with the feature names.  These columns are explained more in the features_info.txt
```{r}
names(x_train) <- features[,2]
```

The train_set variable was built first by assigning it to the Subjects and then by combining the x_train data
```{r}
train_set <- subject_train
train_set <- cbind(train_set, x_train)
```

The activities were matchup from the y_train set using the join command and then added back to the train_set
```{r}
train_activities <- join(y_train, activity_labels)
names(train_activities) <- c("Activity_Code", "Activity_Name")
train_set <- cbind(train_set, train_activities)
```


************** Combine Data **************


combined_data - Used to merge the test and training sets together
```{r}
combined_data <- rbind(test_set, train_set)
```

means - Used to extract all the columns that contained the word "mean" in the column name in the combined_data set
```{r}
means <- combined_data[,grepl("[Mm]ean", names(combined_data))]
```
stds - Used to extract all the columns that contained the phrase "std" in the column name in the combined_data set
```{r}
stds <- combined_data[,grepl("[Ss]td", names(combined_data))]
```

subjects - get the column of just the subjects from the combined_data set
```{r}
subjects <- data.frame(combined_data$Subject)
```
activities - get the column of just the activities by name from the combined_data set
```{r}
activities <- data.frame(combined_data$Activity_Name)
```
cleaned_data - merge together a clean set of the just Subjects, Activities and data columns that have mean or std for the data
```{r}
cleaned_data<-cbind(subjects, activities, means, stds)
```

************** Group by Activities and Subjects **************

Activity_Subject_Averages - A tidy subject of data that groups Activities and Subjects and then displays the mean for each column.
```{r}
Activity_Subject_Averages <- ddply(cleaned_data, .(Activity_Name, Subject), numcolwise(mean))
```

