### run_analysis,R
### Indentions are used in a non standard way to break the code into subsets. Ideally, each step would be broken into separate functions.

##Remember to set the directory correctly
	#setwd("D:/Courses/Getting and Cleaning Data/Assignment")

## Read in all the data

	#Read in each of the files in the Dataset, Begin with the activity labels and the features
	activity_labels <- read.table("./UCI HAR Dataset//activity_labels.txt", sep = "")
	features <- read.table("./UCI HAR Dataset/features.txt", sep = "")

	#Read in data for the test set
	y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "")
	X_test <- read.delim("./UCI HAR Dataset/test/X_test.txt", sep = "",header=FALSE)
	subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "")

	#Read in data for the train set
	y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "")
	X_train <- read.delim("./UCI HAR Dataset/train/X_train.txt", sep = "",header=FALSE)
	subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "")

## Handle 
	#From the feature frame, extract the feature indexes with mean() and std(), meanFreq() will not be matched [step 2]
	patternIndexForMeanAndStd<-which(lapply(features$V2, grep, pattern="mean\\(\\)|std\\(\\)")==TRUE)
	measureNames<-as.character(features$V2[patternIndexForMeanAndStd])
	
	#place only the columns matching mean() and std() in the new data frame test
	test<-X_test[,patternIndexForMeanAndStd]
	names(test)<-measureNames	#apply the column names to the frame

	#place only the columns matching mean() and std() in the new data frame train
	train<-X_train[,patternIndexForMeanAndStd]
	names(train)<-measureNames	#apply the column names to the frame


# Convert the activity labels to the corresponding activity name for the test data [Step 3]
	test_activity_name<-activity_labels[y_test[,1],2]
	train_activity_name<-activity_labels[y_train[,1],2]

# joins the subject_test, test labels and the feature vector for test data [Step 4]
	
	id = c("subject", "activity")
	
	test<-cbind(subject_test,test_activity_name,test)
	names(test)[1:2]=id

	train<-cbind(subject_train,train_activity_name,train)
	names(train)[1:2]=id

# bind the two data sets together [Step 1]
	allData<-rbind(test,train)

# Generate the new data set with means[Step 5]
	allDataMelt <- melt(allData,id=id,measure.vars=measureNames)
	output<-dcast(allDataMelt,subject+activity ~ variable, mean)
	write.table(output, "output.txt", row.names = FALSE)
