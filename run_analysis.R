#clears the environment
rm(list=ls())

#load necessary libraries
library(stringr)
library(dplyr)

#gets working directory
home<-getwd()
wd<-file.path(home,"UCI HAR Dataset")

#in relation to the working directory, sets the location of all relevant files

x_test.loc <- file.path(wd,"test","X_test.txt")
y_test.loc <- file.path(wd,"test","y_test.txt")
subject_test.loc<-file.path(wd,"test","subject_test.txt")

x_train.loc<-file.path(wd,"train","X_train.txt")
y_train.loc<-file.path(wd,"train","y_train.txt")
subject_train.loc<-file.path(wd,"train","subject_train.txt")

features.loc<-file.path(wd,"features.txt")

####################
####################

#I find it easiest to load the test set, 
#perform all relevant matching/naming operations,
#do the same on the training set, and then merge at the end. 

####################
####################

#first, the test data

#load x_test

x_test <- read.table(x_test.loc)
dim(x_test) #2947 rows, and 561 columns

#we can use the 'feature vector', which is tellingly of length 561
#each item in the feature vector corresponds to a variable in test and train set

#so first thing to do is to use the feature vector .txt file 
#to name the variables in x_test

features <- read.table(features.loc)
dim(features) #561 rows, and 2 columns

#we will extract the relevant column from features, 
#and use it to name the variables 

colnames(x_test)<-features[[2]]
head(x_test[1:5]) #naming was successful

#now, we move to recording which activities each measurement corresponds to
#this information is available in y_test

y_test <- read.table(y_test.loc)
dim(y_test) #2947 rows, and 1 column

#y_test contains values 1-6; i.e., one of the six 
#activities recorded in this experiment
unique(y_test) #shows that only values 1-6 are included

#we will add it as an additional column to x_testset, 
#and call the composite dataset 'testset'
testset<-cbind(y_test,x_test)

#we need to rename this, so we know what is what
colnames(testset)[1]<-"activity"
head(testset[1:5]) #naming was successful

#and now we move on to incorporate subject ID"s
#this information is contained in subject_test.txt

subject_test<-read.table(subject_test.loc)

#again, we add it as an additional column to testset
testset<-cbind(subject_test,testset)
colnames(testset)[1]<-"subject_id"
head(testset[1:5])

#to save memory, remove what we don't need
rm(x_test)
rm(y_test)
rm(subject_test)

####################

#second, the train data
#we could write a loop to do all of the above in one go
#first for test, and then for train
#but it's six of one, half a dozen of the other
#i leave comments out because they are redundant

x_train <- read.table(x_train.loc)
dim(x_train) 

colnames(x_train)<-features[[2]]
head(x_train[1:5]) 

y_train <- read.table(y_train.loc)
dim(y_train) 

trainset<-cbind(y_train,x_train)
colnames(trainset)[1]<-"activity"
head(trainset[1:5]) 

subject_train<-read.table(subject_train.loc)
dim(subject_train)

trainset<-cbind(subject_train,trainset)
colnames(trainset)[1]<-"subject_id"
head(trainset[1:5])

rm(x_train)
rm(y_train)
rm(subject_train)
rm(features)

####################

#and now, we can merge the two datasets. 
#all variables are the same, of course
#so we can use rbind to join the two datasets

fullset<-rbind(testset, trainset)
head(fullset[1:5])
rm(testset)
rm(trainset)

####################

#from this dataset, we only want those obserations which 
#are means and standard deviations on each measurement

#note that the word 'mean' surfaces in the measurement of 
#angles. but this does not interest us, as I understand the question

#the way to do this will be to run through the list of variables,
#and select only those which have the "-mean()" or "-std()" in them

#for this we can use 'grepl()'
#note that fixed has to be set to TRUE, because we want exact matches

mean.l<-grepl("mean()",names(fullset), fixed=TRUE) 
std.l<-grepl("std()",names(fullset), fixed=TRUE) 

#we can use 'Reduce()' to deliver a single vector where either 
# meanl or sdl is TRUE 
#(i.e., where the variable name contains either "mean()" or "std()")

logicals<-Reduce("|",list(mean.l,std.l))

#we don't want to throw out the first two columns of our dataset, of course
#those contain the variables we inserted

logicals[1:2]<-TRUE

#and now we can subset using logicals

fullset<-(fullset[,logicals])
head(fullset,10)
dim(fullset) #10,299 rows, 68 columns

#now that we have this dataset, we need to make it a tad neater,
#as per the assignment instructions. 

#we need descriptive activity names, as the instructions suggest
#we can do this easily, by creating a factor variable from 'activity'

activitylabels <- c("walking","walking upstairs","walking downstairs","sitting","standing","laying")
fullset$activity <- factor(fullset$activity, labels=activitylabels)

#and then we need descriptive variable names. 
#I interpret this to mean that we should make the variable names 
# a bit more easy to interpret 

# But I am not sure how to improve on what they have provided
# without making them unduly long. 

# So I make them lower-case, make dashes underscores, 
# eliminate parentheses, and then move on. 

names(fullset)<-tolower(names(fullset))
names(fullset)<-gsub("-","_",names(fullset))
names(fullset)<-gsub("\\(\\)","",names(fullset))

head(fullset,10)

####################

#now, we want a dataset which contains only the averages of each 
#measurement for each subject and each activity

#we will call this fullset2
#i begin by creating it as an ordered version of fullset
#this isn't necessary, but it's neater

fullset2<-arrange(fullset,subject_id,activity)
head(fullset2[,1:2],20) #subject 1 and activity 1 (walking) is at the top
tail(fullset2[,1:2],20) #subject 30 and activity 6 (laying) is at the bottom

#there are 30 subjects, and 6 activities, which means that 
#our target dataset will have 180 rows

#this is easy to create, using the group_by() feature in dplyr
fullset2<-fullset2 %>% group_by(subject_id,activity) %>% summarise_each(funs(mean))
dim(fullset2) #180 observations on 68 variables

#I modify the names by adding "avg_" to the front, just to 
#clarify that these are different from the variables in fullset

names(fullset2)[-(1:2)]<-paste0("avg_",names(fullset2)[-(1:2)])
fullset2

####################

View(fullset)
View(fullset2)

####################

#finally, write the two datasets to a .txt file 

write.table(fullset, file="tidyset.txt", row.name=FALSE)
write.table(fullset2, file="tidyset_avgs.txt", row.name=FALSE)
