#
# Write plot built by fun() into PNG-file with filename
#
doPlotting <- function (filename, fun) {
    hpc <- getDataFrame()

    png(filename, width = 504, height = 504, units = "px", bg = "transparent", type="cairo-png")
    fun(hpc)

    dev.off()
    rm(hpc)

}


#
# Loads data frame with Household Power Consumption Data ("household_power_consumption.txt")
# If txt-file is present in current dir loads it, if not then unzip "household_power_consumption.zip"
# If there is no files throws error
#
getDataFrame <- function() {
    require(sqldf)

    datafile <- "household_power_consumption.txt"
    zipfile  <- "household_power_consumption.zip"

    if (!file.exists(datafile)) {
        unzip(zipfile)
    }
    if (!file.exists(datafile)) {
        stop(paste0("Cannot read data file: ", datafile))
    }

    #setClass("hpcDate")
    #setClass("hpcTime")
    #setAs("character", "hpcDate", function(from) { as.Date(from, format="%d/%m/%Y") })
    #setAs("character", "hpcTime", function(from) { as.Date(from, "%H:%M:%S") })
    #colsClasses<- c("hpcDate", "hpcTime", rep("numeric", 7))
    colsClasses<- c("character", "character", rep("numeric", 7))

    #hpc <- read.table(datafile, sep=";", header=T, na.strings ="?", colClasses=colsClasses, as.is=T)
    query <- "select * from file where Date in ('1/2/2007', '2/2/2007')"
    data <- read.csv.sql(datafile, sql=query, sep=";", header=T, colClasses=colsClasses)
    data$timestamp <- strptime(paste(data$Date, " ", data$Time), "%d/%m/%Y %H:%M:%S")
    data
}


## run code immediately if load it with source()

# need to set English locale to display weekdays as on test image
Sys.setlocale(locale = "English")
doPlotting(
    "plot3.png",
    function(df) {
        colours <- c("black", "red", "blue")
        variables <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
        plot(df$timestamp, df[[variables[1]]], type="n", main="", ylab="Energy sub metering", xlab="")
        legend("topright", col=colours, legend = variables, lty=1)
        for (i in 1:3) {
            lines(df$timestamp, df[[variables[i]]], col=colours[i])
        }
        #lines(hpc$timestamp, hpc[["Sub_metering_1"]], col="black")        
        #lines(hpc$timestamp, hpc[["Sub_metering_2"]], col="blue")
        #lines(hpc$timestamp, hpc[["Sub_metering_3"]], col="red")
    }
)
