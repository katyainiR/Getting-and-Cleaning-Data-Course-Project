library(matrixStats)
library(dplyr)

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"assignment")

## Read the measurement names
features<- read.delim(unz("assignment", "UCI HAR Dataset/features.txt"), header = F, quote = '')

test_data<-read.delim(unz("assignment", "UCI HAR Dataset/test/X_test.txt"), header = F, sep = '')
test_label<-read.delim(unz("assignment", "UCI HAR Dataset/test/y_test.txt"), header = F, sep = '')
subject_test<-read.delim(unz("assignment", "UCI HAR Dataset/test/subject_test.txt"), header = F, sep = '')
test_table <- cbind(subject_test, test_label, test_data )

train_data<-read.delim(unz("assignment", "UCI HAR Dataset/train/X_train.txt"), header = F, sep = '')
train_label<-read.delim(unz("assignment", "UCI HAR Dataset/train/y_train.txt"), header = F, sep = '')
subject_train<-read.delim(unz("assignment", "UCI HAR Dataset/train/subject_train.txt"), header = F, sep = '')
train_table <- cbind(subject_train, train_label, train_data)

## 1. Merges all
data<- rbind(train_table, test_table)
merged <- data
colnames(merged)<- c("SubjectID", "Activity", as.character(features[,1]))

## 4. Descriptive Column names for each measurment 
colnames(data)<- c("SubjectID", "Activity", as.character(features[,1]))

data$Activity <- as.factor(data$Activity)
## 3. Inserting Descriptive Names for activities
levels(data$Activity)<- c("Walking", "Walking_Upstairs", "Walking_Downstairs","Sitting" ,"Standing", "Laying")


temp <- as.data.frame(select(data, -c("SubjectID", "Activity")))
temp <- as.matrix(temp)
mean <- colMeans(temp)
sd <- colSds(temp)

## 2. To store mean and standard deviation of each measurement in a data frame (Part_2)
Part_2 <- data.frame(features, means=mean, standard_deviation = sd, row.names = T)

## 5. to store a tidy set with means of each activity and each subject
tidy_data <- data %>% group_by(SubjectID, Activity) %>% summarise_at(as.character(features[,1]),mean2)
