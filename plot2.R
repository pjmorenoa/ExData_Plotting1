library(dplyr)
library(lubridate)
Sys.setlocale("LC_TIME","English")

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
    mutate(Date_Time = paste(Date, Time, sep = " ")) %>%
    select(Date_Time, Global_active_power) %>%
    mutate(Date_Time = dmy_hms(Date_Time))%>%
    mutate(Global_active_power=as.numeric(Global_active_power))


## Making the plot
png("plot2.png")
with(data, plot(Date_Time, Global_active_power, type="l", 
                ylab = "Global Active Power (kilowatts)", xlab=""))
dev.off()