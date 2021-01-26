pacman::p_load(zoo, dplyr, forecast, ggplot2)
#library(RColorBrewer)
# Import data
BOEData = read.csv('C:/Users/kriss/RProjects/Forecasting/Test1/BOE-Database_export.csv', header = TRUE)
# Creating a quick plot to check
ggplot() + 
  geom_line(data = BOEData, aes(x = Year, y = D1/1000000), color = "black") +
  geom_line(data = BOEData, aes(x = Year, y = D5/1000000), color = "Blue") +
  geom_line(data = BOEData, aes(x = Year, y = D10/1000000), color = "purple") +
  geom_line(data = BOEData, aes(x = Year, y = D20/1000000), color = "orange") +
  geom_line(data = BOEData, aes(x = Year, y = D50/1000000), color = "red") +
  xlab('Year') +
  ylab('Value (millions)')

MyData <- BOEData[2:6]/1000
MyData <- tibble::rownames_to_column(MyData, "Year")

# Splits data out in 2 columns year / denom
# Then pipes data into timeseries with an annual frequency
D1 <- MyData[c(2)] %>% ts(start = 1975, frequency = 1)
D5 <- MyData[c(3)] %>% ts(start = 1975, frequency = 1)
D10 <- MyData[c(4)] %>% ts(start = 1975, frequency = 1)
D20 <- MyData[c(5)] %>% ts(start = 1975, frequency = 1)
D50 <- MyData[c(6)] %>% ts(start = 1975, frequency = 1)

# Basic timeseries plot for all denoms
# ts.plot(D1,D5,D10,D20,D50)

# Creates an ouptut using a basic 5 year forecast
# Puts the forecast into a data frame
ForcOut1 <- data.frame(forecast(D1, h=5))
# Adds a header for year column
ForcOut1 <- tibble::rownames_to_column(ForcOut, "Year")
ForcOut5 <- data.frame(forecast(D5, h=5))
ForcOut10 <- data.frame(forecast(D10, h=5))
ForcOut20 <- data.frame(forecast(D20, h=5))
ForcOut50 <- data.frame(forecast(D50, h=5))

FullAnnualForecast <- rbind(ForcOut1,ForcOut5, ForcOut10, ForcOut20, ForcOut50)

# Plot the forecast
autoplot(forecast(D20, h=5))
