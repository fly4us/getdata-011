# load test data
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# bind test data, activity and subject columns
test <- x_test
test <- cbind(test, y_test)
test <- cbind(test, subject_test)

# load train data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# bind train data, activity and subject columns
train <- x_train
train <- cbind(train, y_train) 
train <- cbind(train, subject_train) 

# row bind test and train data
# 1.Merges the training and the test sets to create one data set.
data <- rbind(test, train)

# load features data
features <- read.table("features.txt")

# find all features that include "mean" or "std"
v_va <- grepl("mean", as.character(features$V2)) | grepl("std", as.character(features$V2))

# format the column names
names <- gsub("-", ".", features$V2[v_va])
names <- gsub("\\(\\)", "", names)
names <- c(names, "activity", "subject")

# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 4.Appropriately labels the data set with descriptive variable names. 
data <- data[, v_va]
colnames(data) <- names

# 3.Uses descriptive activity names to name the activities in the data set
activity <- factor(data$activity, levels=c(1,2,3,4,5,6), labels=c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))
subject <- factor(data$subject)

# 5.creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data <- data[, 1:79]
result <- aggregate(data, by=list(activity=activity, subject=subject), FUN=mean)
write.table(result, "result.txt", row.name=FALSE) 

