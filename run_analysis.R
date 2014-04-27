#
# This function is the entry point to this analysis.
# It takes one optional argument, the file where to store the tidy dataset.
# It returns the tidy dataset and writes the result into the specified file.
# 
tidyDataset <- function(filename="tidy_dataset.txt") {
    testData <- readData("test")
    trainData <- readData("train")
    
    mergedData <- rbind(testData, trainData)
    splitData <- split(mergedData, mergedData$group)
    
    list <- lapply(splitData, function(x) { apply(x[, c(-1, -2, -3)], 2, mean)})
        
    result <- NULL
    for (i in seq_along(list)) {
        name <- names(list[i])
        values <- list[[i]]
        result <- rbind(result, c(ungroup(name), values))
    }
        
    result <- as.data.frame(result)
    write.table(result, file=filename)
    result
}

readData <- function(type="test") {
    dataSetRootDirectory <- "UCI HAR Dataset"
    specificDatasetDirectory <- paste(dataSetRootDirectory, type, sep="/")
    
    subjectFileName <- paste0("subject_", type, ".txt")
    activityFileName <- paste0("y_", type, ".txt")
    variableFileName <- paste0("X_", type, ".txt")
    
    subjectFilePath <- paste(specificDatasetDirectory, subjectFileName, sep="/")
    activityFilePath <- paste(specificDatasetDirectory, activityFileName, sep="/")
    variableFilePath <- paste(specificDatasetDirectory, variableFileName, sep="/")
    
    subjects <- read.table(subjectFilePath)
    names(subjects) <- "subject"
    
    activities <- read.table(activityFilePath)
    activities <- translateActivity(activities[[1]])
    
    data <- subjects
    data$activity <- activities
    data$activity <- as.factor(data$activity)
    data$subject <- as.factor(data$subject)
    data$group <- as.factor(paste(data$activity, data$subject, sep="_"))

    # Read and process the measured variables
    rawdata <- readVariables(variableFilePath)
    
    cbind(data, rawdata)
}

readVariables <- function(filename) {
    data <- read.table(filename)
    names(data) <- sub("^V(\\d+)", "\\1", names(data))
    
    names(data) <- labelFeature(as.integer(names(data)))
    
    index <- grep("-(mean|std)\\(\\)-", names(data))
    
    data <- data[,index]
    
    names(data) <- sub("\\(\\)", "", names(data))
    data
}

ungroup <- function(x="laying_10") {
    s = sub(".+_(\\d+)$", "\\1", x)
    a = sub("(.+)_\\d+$", "\\1", x)
    
    c(subject=s, activity=a)
}

labelFeature <- function(feature = 1) {
    
    # FIXME: cache feature labels; do not retrieve every time
    feature_labels <- read.table("UCI HAR Dataset/features.txt")
    
    feature_labels[[2]] <- tolower(feature_labels[[2]])
    feature_labels[feature, 2]
}

translateActivity <- function(activity = 1) {
    
    # FIXME: cache activity labels; do not retrieve every time
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
    
    activity_labels[[2]] <- tolower(activity_labels[[2]])
    activity_labels[activity, 2]
}
