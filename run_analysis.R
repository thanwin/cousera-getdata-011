library(dplyr)

#Read Data
#features_info.txt': Shows information about the variables used on the feature vector.

#'features.txt': List of all features.
features <- read.table("./UCI_HAR_Dataset/features.txt", header=FALSE, stringsAsFactors=FALSE)[,2]

#'activity_labels.txt': Links the class labels with their activity name.
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)[,2]

#'train/X_train.txt': Training set.
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt", header=FALSE, stringsAsFactors=FALSE)

#'train/y_train.txt': Training labels.
Y_train <- read.table("./UCI_HAR_Dataset/train/Y_train.txt", header=FALSE, stringsAsFactors=FALSE)

#'test/X_test.txt': Test set.
X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt", header=FALSE, stringsAsFactors=FALSE)

#'test/y_test.txt': Test labels.
Y_test <- read.table("./UCI_HAR_Dataset/test/Y_test.txt", header=FALSE, stringsAsFactors=FALSE)

#'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt", header=FALSE, stringsAsFactors=FALSE)

#'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt", header=FALSE, stringsAsFactors=FALSE)

#add names 
names(X_test) = features
names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

# Load activity labels
Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

Y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#merge
mTrain <- cbind(subject_train, Y_train, X_train)
mTest <- cbind(subject_test, Y_test, X_test)
mData <- rbind(mTest, mTrain)

#group df by subject, activity and calculate mean
tidy_data <- arrange(mData, subject, Activity_ID) %>% mutate(subject = mean(subject), Activity_ID = mean(Activity_ID))

#save tidy data to txt
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
