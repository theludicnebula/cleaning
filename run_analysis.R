library("plyr")

#download file

#Global
activity_labels <- read.table("UCI HAR Dataset//activity_labels.txt")
features <- read.table("UCI HAR Dataset//features.txt")

#Test
subject_test<- read.table("UCI HAR Dataset//test//subject_test.txt")
x_test<- read.table("UCI HAR Dataset//test//X_test.txt")
y_test<- read.table("UCI HAR Dataset//test//Y_test.txt")
body_acc_x_test <- read.table("UCI HAR Dataset//test//Inertial Signals//body_acc_x_test.txt")

#build test 
names(x_test) <- features[,2]
test_set <- subject_test
names(test_set) <- c("Subject")
test_set <- cbind(test_set, x_test)

test_activities <- join(y_test, activity_labels)
names(test_activities) <- c("Activity_Code", "Activity_Name")
test_set <- cbind(test_set, test_activities)

#Train
subject_train<- read.table("UCI HAR Dataset//train//subject_train.txt")
x_train<- read.table("UCI HAR Dataset//train//X_train.txt")
y_train<- read.table("UCI HAR Dataset//train//Y_train.txt")

#build Train
names(x_train) <- features[,2]
train_set <- subject_train
names(train_set) <- c("Subject")
train_set <- cbind(train_set, x_train)

train_activities <- join(y_train, activity_labels)
names(train_activities) <- c("Activity_Code", "Activity_Name")
train_set <- cbind(train_set, train_activities)


#Merge by subject
#merge(test_set, train_set, by="Subject")
combined_data <- rbind(test_set, train_set)

#get the Mean and Standard Deviation columns
means <- combined_data[,grepl("[Mm]ean", names(combined_data))]
stds <- combined_data[,grepl("[Ss]td", names(combined_data))]
subjects <- data.frame(combined_data$Subject)
activities <- data.frame(combined_data$Activity_Name)
names(subjects) <- c("Subject")
names(activities) <- c("Activity_Name")


#merge into one data frame
cleaned_data<-cbind(subjects, activities, means, stds)

#Subject into Activites and Subjects and then take the mean of columns
Activity_Subject_Averages <- ddply(cleaned_data, .(Activity_Name, Subject), numcolwise(mean))
#remove Subject


#get averages
