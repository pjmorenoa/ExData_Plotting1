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
    mutate(Date_Time = paste(Date, Time, sep = " ")) %>%
    select(Date_Time, Sub_metering_1, Sub_metering_2, Sub_metering_3) %>%
    mutate(Date_Time = dmy_hms(Date_Time))%>%
    mutate(Sub_metering_1=as.numeric(Sub_metering_1)) %>%
    mutate(Sub_metering_2=as.numeric(Sub_metering_2)) %>%
    mutate(Sub_metering_3=as.numeric(Sub_metering_3)) 

## Making the plot
png("plot3.png")

with(data, {
    plot(Sub_metering_1~Date_Time, type="l", xlab="", 
                ylab = "Energy sub metering")
    lines(Sub_metering_2~Date_Time, col="red")
    lines(Sub_metering_3~Date_Time, col="blue")
    legend("topright", col=c("black","red","blue"), lty=1, lwd=2, 
                  legend = c("Sub_metering_1", "Sub_metering_2", 
                             "Sub_metering_3"))
})
dev.off()


