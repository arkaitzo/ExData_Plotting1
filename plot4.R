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
png(file = "plot4.png", height = 480, width = 480) # Avoids legend truncation
par(bg = "transparent", mfrow = c(2, 2)) # Make the background transparent
with(data = df, {
    # Subplot 1
    plot(x = DateTime, y = Global_active_power,
         type = "l",
         col = "black",
         xlab = "Day of the Week", ylab = "Global Active Power")
    # Subplot 2
    plot(x = DateTime, y = Voltage,
         type = "l",
         col = "black",
         xlab = "Day of the Week", ylab = "Voltage")
    # Subplot 3
    plot(x = DateTime, y = Sub_metering_1,
         type = "l",
         col = "black",
         xlab = "Day of the Week", ylab = "Energy sub metering")
    lines(x = DateTime, y = Sub_metering_2,
          col = "red")
    lines(x = DateTime, y = Sub_metering_3,
          col = "blue")
    legend("topright", lty = 1, cex = .8,
           col = c("black", "red", "blue"),
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    # Subplot 4
    plot(x = DateTime, y = Global_reactive_power,
         type = "l",
         col = "black",
         xlab = "Day of the Week", ylab = "Global Reactive Power")
})
dev.off()
