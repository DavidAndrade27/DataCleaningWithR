## Coursera data science cleaning data project
# By David Andrade


# read dplyr library
library(dplyr)



# Read feature list and activity names
features_list <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))


# Read test in one dataset
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features_list$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")

# joining by label
y_test_label <- left_join(y_test, activity, by = "label")

tidy_test <- cbind(subject_test, y_test_label, x_test)
# tidy dataset whithout variable label
tidy_test <- select(tidy_test, -label)



# Read Train dataset
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features_list$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
#join by label
y_train_label <- left_join(y_train, activity, by = "label")
tidy_train <- cbind(subject_train, y_train_label, x_train)

#train without label
tidy_train <- select(tidy_train, -label)

# test and train join
tidy_set <- rbind(tidy_test, tidy_train)

# mean and std
tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

# avg all variable of each subj and activ
tidy_mean_std$subject <- as.factor(tidy_set$subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)
tidy_avg <- tidy_mean_std %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))


# writing file
write.table(tidy_avg, file = "tidydataset_avg.txt", row.names = F)
