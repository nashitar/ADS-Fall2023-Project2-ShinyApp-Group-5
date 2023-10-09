setwd(dirname(rstudioapi::getSourceEditorContext()$path))
library(readr)
data <- read_csv("../data/raw_dataset_FemaWebDeclarationAreas.csv")
# Drop the columns 'id', 'hash', and 'lastRefresh'
data <- data[, !(names(data) %in% c("id", "hash", "lastRefresh"))]
data <- as.data.frame(data)
write_csv(data, "../out/cleaned_dataset_FemaWebDeclarationAreas.csv")



