#
#
# Downloading train & test data
#
if(!file.exists("./Project")){dir.create("./Project")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Project/Dataset.zip")
unzip(zipfile="./Project/Dataset.zip",exdir="./Project")
uciDir <- file.path("./Project" , "UCI HAR Dataset")
#
# 1.Merges the training and the test sets to create one data set.
#
tmpx1 <- read.table(file.path(uciDir,"train","X_train.txt"),header = FALSE)
tmpx2 <- read.table(file.path(uciDir,"test","X_test.txt"),header = FALSE)
x <- rbind(tmpx1, tmpx2)
#
tmpx1 <- read.table(file.path(uciDir,"train","subject_train.txt"),header = FALSE)
tmpx2 <- read.table(file.path(uciDir,"test","subject_test.txt"),header = FALSE)
s <- rbind(tmps1, tmps2)
#
#
tmpy1 <- read.table(file.path(uciDir,"train","y_train.txt"),header = FALSE)
tmpy2 <- read.table(file.path(uciDir,"test","y_test.txt"),header = FALSE)
y <- rbind(tmpy1, tmpy2)


# 2.	Extracts only the measurements on the mean
# and standard deviation for each measurement. 

featuresMeanStdev<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]


# 3.Uses descriptive activity names to name the activities in the data set

features <- read.table(file.path(uciDir,"features.txt"),header = FALSE)
names(x)<- features$V2
names(s)<-c("subject")
names(y)<-c("activity")
sensorData <- cbind(cbind(x, y), s)
selectedNames<-c(as.character(featuresMeanStdev), "subject", "activity")
sensorData<-subset(sensorData,select = selectedNames)


# 4.Appropriately labels the data set with descriptive variable names.

names(sensorData) <- gsub("\\(|\\)", "", names(sensorData))
names(sensorData) <- tolower(names(sensorData))
names(sensorData)<-gsub("^t", "time", names(sensorData))
names(sensorData)<-gsub("bodybody", "body", names(sensorData))
names(sensorData)<-gsub("acc", "accelerometer", names(sensorData))
names(sensorData)<-gsub("gyro", "gyroscope", names(sensorData))
names(sensorData)<-gsub("mag", "magnitude", names(sensorData))
names(sensorData)<-gsub("^f", "frequency", names(sensorData))


# 5.From the data set in step 4, creates a second, independent tidy 
# data set with the average of each variable for each activity and each subject.

tidySensorData = ddply(sensorData, c("subject","activity"), numcolwise(mean))
write.table(tidySensorData, file = "tidySensorData.txt", sep =" ", row.name = FALSE)

