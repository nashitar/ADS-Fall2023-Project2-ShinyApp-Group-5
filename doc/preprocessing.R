# install.packages("dplyr")
# install.packages("ggmap")
library(dplyr)
library(ggmap)

data <- read.csv("data/DisasterDeclarationsSummaries.csv")

register_google("AIzaSyDLtO6ZqLGYMNlOYHi-NwrH146ySmW3qR0")

# Create a new data frame with latitude and longitude columns
geocoded_data <- data %>%
  rowwise() %>%
  mutate(location = paste(fipsStateCode, fipsCountyCode, designatedArea, state, sep = ", "),
         geo_data = geocode(location),
         latitude = ifelse(!is.na(geo_data$lat), geo_data$lat, NA),
         longitude = ifelse(!is.na(geo_data$lon), geo_data$lon, NA)) %>%
  select(-location, -geo_data)

# Extract year and month from the declarationDate column
geocoded_data <- geocoded_data %>%
  mutate(declarationYear = as.integer(format(as.POSIXct(declarationDate, format = "%Y-%m-%dT%H:%M:%S.000Z"), "%Y")),
         declarationMonth = as.integer(format(as.POSIXct(declarationDate, format = "%Y-%m-%dT%H:%M:%S.000Z"), "%m")))

# View the updated data frame
head(geocoded_data)

write.csv(geocoded_data, "out/DisasterDeclarationsSummariesCleaned.csv", row.names = FALSE)

