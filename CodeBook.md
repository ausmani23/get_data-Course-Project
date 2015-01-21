## CodeBook.md file 

#Adaner Usmani's submission for the Cleaning and Getting Data Course Project

As mentioned in Readme.md, the original data come from the researchers at the Smartlab-NonLinear Complex Systems Laboratory, located in Genoa, Italy. [Link to original](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

These are data from experiments conducted with 30 volunteers. As described at that link, these subjects performed six activities wearing a smartphone. Using the accelerometer and the gyroscope, the researchers collected various measurements of interest. 

This dataset has combined the 'test' and the 'training' subsets of that dataset, which they kept separate. And we have ommitted many of the measurements available in the original. Here, I have included only the observations pertaining to the mean and standard deviation of the given variables. This results in a dataset with 68 variables (the original has 561 vars) 

There are two versions of the dataset, as also mentioned in the Readme.md file. 

**tidyset.txt** contains contains 10,299 observations on 68 variables of interest. Each column corresponds to a different variable, and each row a specific observation. In that sense, this dataset conforms to the 'tidy' dataset principles as defined by Hadley Wickham See his [paper] (http://vita.had.co.nz/papers/tidy-data.pdf) for more details. 

**tidyset2.txt** is the subject and activity-specific average of all the 68 variables in tidyset.txt. Because there were 30 subjects, each of whom was observed doing 6 activities, there are a total of 180 observations. 

Those who are interested in the details of these variables are encouraged to read the original documentation available at the link above. Each of these variables measures a different component of the movement of the experiment subject. Tidyset2 is obviously not in the same units as tidyset, given that it is the subject- and activity-average of the variables in tidyset.txt.