# Package
library(dplyr)
# Download data

if (!file.exists("data")){
    dir.create("data")
}

adres <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(adres, destfile = "./data/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", method = "curl")
#unzip the dataset
unzip("./data/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir = "./data")
list.files("./data/UCI HAR Dataset")

# look at train set
list.files("./data/UCI HAR Dataset/train")
# look at test set
list.files("./data/UCI HAR Dataset/test")

# Download data
X_tr <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_tr <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
sub_tr <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

X_t <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_t <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
sub_t <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# read data description
FeatureName <- read.table("./data/UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#1. Merges the training and the test sets to create one data set

X_all <- rbind(X_tr,X_t)
y_all <- rbind(y_tr, y_t)
sub_all = rbind(sub_tr, sub_t)
df <- cbind(sub_all, X_all, y_all)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

selected_var <- FeatureName[grep("mean\\(\\)|std\\(\\)",FeatureName[,2]),]
X_all <- X_all[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(y_all) <- "activity"
y_all$activitylabel <- factor(y_all$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_all[,-1]

# 4. Appropriately labels the data set with descriptive variable names.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(sub_all) <- "subject"
data_tidy <- cbind(X_all, activitylabel, sub_all)
all_mean <- data_tidy %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(all_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)

