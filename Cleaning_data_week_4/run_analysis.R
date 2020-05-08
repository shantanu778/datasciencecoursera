library(dplyr)
run_analysis <- function(){
  train_X <- read.table('train/X_train.txt')
  train_y <- read.table('train/y_train.txt')
  train_subject <- read.table('train/subject_train.txt')
  
  test_X <- read.table('test/X_test.txt')
  test_y <- read.table('test/y_test.txt')
  test_subject <- read.table('test/subject_test.txt')
  
  # read features
  features <- read.table("features.txt")
  activities <- read.table("activity_labels.txt")
  
  activity_data <- rbind(
    cbind(train_subject, train_X, train_y),
    cbind(test_subject, test_X, test_y)
  )
  #Extracts only the measurements on the mean and standard deviation for each measurement.
  
  colnames(activity_data) <- c("subject", as.character(features[, 2]), "activity")
  
  # determine columns of data set to keep based on column name...
  col <- grepl("subject|activity|mean|std", colnames(activity_data))
  
  # ... and keep data in these columns only
  activity_data <- activity_data[, col]
  # labelling activity data with the activity name
  activity_data$activity <- factor(activity_data$activity,levels = activities[, 1], labels = activities[, 2])
  
  
  #Uses descriptive activity names to name the activities in the data set
  colnames(activity_data) <- gsub("[\\(\\)-]", "", colnames(activity_data))
  colnames(activity_data) <- gsub("^f", "frequencyDomain", colnames(activity_data))
  colnames(activity_data) <- gsub("^t", "timeDomain", colnames(activity_data))
  colnames(activity_data) <- gsub("Acc", "Accelerometer", colnames(activity_data))
  colnames(activity_data) <- gsub("Gyro", "Gyroscope", colnames(activity_data))
  colnames(activity_data) <- gsub("Mag", "Magnitude", colnames(activity_data))
  colnames(activity_data) <- gsub("Freq", "Frequency", colnames(activity_data))
  colnames(activity_data) <- gsub("mean", "Mean", colnames(activity_data))
  colnames(activity_data) <- gsub("std", "StandardDeviation", colnames(activity_data))
  colnames(activity_data) <- gsub("BodyBody", "Body", colnames(activity_data))
  
  FinalData <- activity_data %>%
    group_by(subject, activity) %>%
    summarise_all(mean)
  
  write.table(FinalData, "FinalData.txt", row.name=FALSE)
}