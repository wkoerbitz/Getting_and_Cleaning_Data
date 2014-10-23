# set working directory inside of to the folder "UCI HAR Dataset" 
# setwd()
#-- load packages --------------------------------------------------------------------------- 
library(car);library(reshape2)

#-- load variable labels --------------------------------------------------------------------
labels             <- read.table(file="features.txt", sep=" ")

#-- 1) load and merge data ------------------------------------------------------------------
train.train          <- read.table("./train/X_train.txt")
train.person.ID      <- read.table("./train/subject_train.txt")
train.activity       <- read.table("./train/y_train.txt")

colnames(train.train) <- labels$V2
train.train$ID        <- train.person.ID$V1
train.train$activity  <- train.activity$V1

test.test             <- read.table("./test/X_test.txt")
test.person.ID        <- read.table("./test/subject_test.txt")
test.activity         <- read.table("./test/y_test.txt")

colnames(test.test)   <- labels$V2
test.test$ID          <- test.person.ID$V1
test.test$activity    <- test.activity$V1

data                  <- rbind(test.test, train.train)

#-- 2) select variables in data set ---------------------------------------------------------
data                  <- data[,c(which(colnames(data)=="ID"), which(colnames(data)=="activity"), grep("mean\\(\\)|std\\(\\)", colnames(data)))]

#-- 3) label activity varaible --------------------------------------------------------------
data$activity         <- recode(data$activity, "1='WALKING';2='WALKING_UPSTAIRS';3='WALKING_DOWNSTAIRS';4='SITTING';5='STANDING';6='LAYING'")

#-- 4) clean variable names -----------------------------------------------------------------
colnames(data)        <- gsub("()", "", colnames(data), fixed=TRUE)
colnames(data)        <- gsub("^fBody", "", colnames(data))

#-- 5) aggregate on ID and activity --------------------------------------------------------
data.tidy             <- melt(data, id=c("ID", "activity"), measure.var=grep("mean|std", colnames(data)))
data.tidy             <- dcast(data.tidy, ID + activity ~ variable, mean) 

write.table(data.tidy, file="tidy_data_set.txt", row.name=FALSE)
