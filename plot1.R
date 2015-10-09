library(dplyr)
library(lubridate)

## Data sources
src <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "household_power_consumption.txt"

## Check if the data file is downloaded
if (!file %in% dir(".")) 
{
    print("Downloading...")
    download.file(src, destfile = "power_consumption.zip")
    unzip("power_consumption.zip", overwrite=TRUE)
}

## Reading and processing the data
data <- read.csv(file, header = TRUE, sep=";", as.is=TRUE)
data <- tbl_df(data)
data <- data %>%
    filter(Date=="1/2/2007" | Date=="2/2/2007") %>%
    mutate(Date = dmy(Date)) %>%
    mutate(Global_active_power=as.numeric(Global_active_power))

## Making the plot
png("plot1.png")
with(data, hist(Global_active_power, col="red", main="Global Active Power", 
                xlab="Global Active Power (kilowatts)"))
dev.off()
