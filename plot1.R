# Download and unzip the data
if(!file.exists("./data")) {dir.create("./data")}
download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
    destfile = "./data/household_power_consumption.zip", method = "curl")
dateDownloaded <- date()
unzip(zipfile = "./data/household_power_consumption.zip", exdir = "./")

# Read in the raw data (missing values are coded as "?")
df <- read.table(file = "household_power_consumption.txt", sep = ";",
                 header = TRUE, stringsAsFactors = FALSE, na.strings = "?")

# Convert the Date and Time variables to Date/Time classes
if (!require("lubridate")) {install.packages("lubridate")}; library(lubridate)
df$DateTime <- dmy_hms(paste(df$Date, df$Time))
df$Date <- NULL; df$Time <- NULL

# Subset the data
df <- df[grepl(df$DateTime, pattern = "2007-02-01|2007-02-02"), ]

# Plot the data as required
par(bg = "transparent") # Make the background transparent
with(data = df,
     hist(x = df$Global_active_power,
          main = "Global Active Power",
          col = "red",
          xlab = "Global Active Power (kilowatts)"))

# Save the plot to a PNG file
dev.copy(device = png, file = "plot1.png", height = 480, width = 480)
dev.off()
