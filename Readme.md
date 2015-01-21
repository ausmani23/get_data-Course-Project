## Readme.md file 

#Adaner Usmani's submission for the Cleaning and Getting Data Course Project

The original data come from the researchers at the Smartlab-NonLinear Complex Systems Laboratory, located in Genoa, Italy. [Link to original](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

**run_analysis.R** is a file that takes the original data, downloadable at the link above, and transforms it into the two different tidy datasets in this folder. The basic tasks were to merge the training and the test data, which were kept separate by the researchers, and extract only the information for the mean and the standard deviation for the 561 variables for which researchers collected and/or computed observations. If you would like to run the script yourself, the file is currently configured to run if stored in the same directory as the folder containing all the data--but roots can be modified easily enough to suit your preferences. 

**tidyset.txt** is this dataset. It contains 10,299 observations on 68 variables of interest. Each column corresponds to a different variable, and each row a specific observation. In that sense, this dataset conforms to the 'tidy' dataset principles as defined by Hadley Wickham See his [paper] (http://vita.had.co.nz/papers/tidy-data.pdf) for more details. 

**tidyset2.txt** is the subject and activity-specific average of all the 68 variables in tidyset.txt. Because there were 30 subjects, each of whom was observed doing 6 activities, there are a total of 180 observations. 

**CodeBook.md** describes the variables in a bit more detail. 