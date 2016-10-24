library(reshape2)

# 1 Merges the training and the test sets to create one data set.

### Reading Data
xtrain <- read.table("train/X_train.txt")
xtest <- read.table("test/X_test.txt")

ytrain <- read.table("train/y_train.txt")
ytest <- read.table("test/y_test.txt")

sub_train <- read.table("train/subject_train.txt")
sub_test <- read.table("test/subject_test.txt")

features <- read.table("features.txt")

### Labels

names(sub_train) <- "subjectid"
names(sub_test) <- "subjectid"

names(xtrain) <- features$V2
names(xtest) <- features$V2

names(ytrain) <- "activity"
names(ytest) <- "activity"

### Merge

train <- cbind(sub_train, ytrain, xtrain)
test <- cbind(sub_test, ytest, xtest)
merged <- rbind(train, test)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.

### Determine what cols to limit on
limitedcols <- grepl("-mean\\(\\)|-std\\(\\)", names(merged))

### Flag activity/subject as TRUE
limitedcols[1:2] <- TRUE

### Purge unwanted cols
merged <- merged[, limitedcols]

# 3 Uses descriptive activity names to name the activities in the data set

### Load activity map

activity_name <- read.table("activity_labels.txt", col.names = c("activity", "activityname"))

### Add activity name col

merged <- merge(merged, activity_name, by.x = "activity")

# 4 Appropriately labels the data set with descriptive variable names.

### Already completed above with labels

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### create the tidy data set
merge_melt <- melt(merged, id=c("subjectid","activityname"))
tidy_result <- dcast(merge_melt, subjectid+activityname ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy_result, "tidy_result.csv", row.names=FALSE)