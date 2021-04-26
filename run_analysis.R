#Final Project

#Download file

if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/dataSet.zip")

#unzip file

unzip(zipfile = "./data/dataSet.zip", exdir = "./data")

#List of file

path <- file.path("./data", "UCI HAR Dataset") #sort of a paste0
files <- list.files(path, recursive = TRUE) #when true, analize all directories

#Reading the files

#Activity
activityTest <- read.table(file.path(path, "test", "y_test.txt"), header = FALSE)
activityTrain <- read.table(file.path(path, "train", "y_train.txt"), header = FALSE)

#Subject
subjectTest <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)

#Features
featureTest <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
featureTrain <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)

#Concatenating data
activity <- rbind(activityTest, activityTrain)
subject <- rbind(subjectTest, subjectTrain)
feature <- rbind(featureTest, featureTrain)

#Naming the columns
names(subject) <- "subject"
names(activity) <- "activity"
featureNames <- read.table(file.path(path, "features.txt"), header = FALSE)
names(feature) <- featureNames$V2

#Merging
data <- cbind(subject, activity, feature)

#subdata mean and sdt
subFeatureName <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)] #metacharacters

#columns to display
column <- c(as.character(subFeatureName), "subject", "activity")
data <- subset(data, select = column)

#loading activity labels
activityLabel <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)

#Describing activity variable by changing factor levels
data$activity <- factor(data$activity)
levels(data$activity) <- as.character(activityLabel$V2)

#Fixing column names
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

#sumarising by groups and rearranging
finalData <- aggregate(. ~ subject + activity, data = data, mean)
finalData <- finalData[order(finalData$subject, finalData$activity),]

#Exporting
write.table(finalData, file = "data.txt",row.name=FALSE)


