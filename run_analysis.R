# setup env

library(dplyr)

# read data to data frames

subject_test <- read.table("./test/subject_test.txt")
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/Y_test.txt")

subject_train <- read.table("./train/subject_train.txt")
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/Y_train.txt")

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

#rename columns in activity_labels
activity_labels <- rename(activity_labels, activity = V1, activityType = V2)

# create a data set

finalDataSet <- data.frame(matrix(ncol = (length(names(xtest))+3), nrow = 0))
colnames(finalDataSet) <- c("activity", "activityType", "subject", paste0("V", c(1:length(names(xtest)))))

for (set_type in c("test", "train")) {
  
  if (set_type == "test") {set <- xtest ; y <- ytest ; subject <- subject_test}
  if (set_type == "train") {set <- xtrain ; y <- ytrain ; subject <- subject_train}
  
  # attach activity and subject
  set$subject <- as.numeric(as.character(subject$V1))
  set$activity <- as.numeric(as.character(y$V1))

  # reordering rows
  set <- set[, c(length(names(set)), length(names(set))-1, c(1:(length(names(set))-2)) )]

  # merge with activity labels
  set <- merge(activity_labels, set, by = "activity")
  
  ## final data set
  finalDataSet <- rbind(finalDataSet, set)
  
}

# remove temp data frames
rm(set, y, subject, set_type)

# attach variables names from features to finalDataSet
features$V2 <- as.character(features$V2)
var_names <- as.list(features$V2)
colnames(finalDataSet) <- c("activity", "activityType", "subject", var_names )

# extract only those variables which correspond to mean or std
# [Mm]ean|[Ss]td filter gave 86 variables
finalDataSet <- finalDataSet[,c("activityType","subject",grep("[Mm]ean|[Ss]td", names(finalDataSet), value = TRUE))]

# create a list of patterns to replace column names
rep_list <- list(c("BodyBody","Body"), c("Acc","Accelerometer"),
                 c("Gyro", "Gyroscope"), c("Mag", "Magnitude"),
                 c("-",""), c("\\()",""))

# replace column names in finalDataSet
cnames <- names(finalDataSet)
repl <- function(x, df = cnames) { 
  for (n in c(1:length(x))) {
  df <- gsub(x[[n]][1], x[[n]][2], df)
  }
  df
}
colnames(finalDataSet) <- repl(rep_list)

rm(cnames, rep_list, var_names)

# creating a data frame for average values
final_avg <- finalDataSet %>% group_by(activityType, subject) %>% summarise_each(funs(mean))

# remove temp
rm(xtest,ytest,xtrain, ytrain, activity_labels, features, subject_test, subject_train, finalDataSet)
