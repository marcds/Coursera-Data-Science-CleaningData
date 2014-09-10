if (!require("data.table")) {
        install.packages("data.table")
}

if (!require("reshape2")) {
        install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Setting the working directory
setwd("~/Documents/Coursera/3.Getting_cleaning_data/UCI HAR Dataset")
        
# Load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement
extract_features <- grepl("mean|std", features)

# Load and process xTest & yTest data
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(xTest) <- features

# Extract only the measurements on the mean and standard deviation for each measurement
xTest <- xTest[,extract_features]

# Load activity labels
yTest[,2] <- activity_labels[yTest[,1]]
names(yTest) <- c("Activity_ID", "Activity_Label")
names(subjectTest) <- "Subject"

# Bind test data
test_data <- cbind(as.data.table(subjectTest), yTest, xTest)

# Load and process xTrain & ytrain data
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(xTrain) <- features

# Extract the measurements on the mean and standard deviation for each measurement
xTrain <- xTrain[,extract_features]

# Load activity data
yTrain[,2] <- activity_labels[yTrain[,1]]
names(yTrain) <- c("Activity_ID", "Activity_Label")
names(subjectTrain) <- "Subject"

# Bind train data
train_data <- cbind(as.data.table(subjectTrain), yTrain, xTrain)

# Merge test and train data
data <- rbind(test_data, train_data)
id_labels <- c("Subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.name = FALSE)
tidy <- read.table("./UCI HAR Dataset/tidy_data.txt")
