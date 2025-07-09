# Load required libraries
library(ggplot2)
library(TSA)
library(tseries)
library(astsa)

# Read in the monthly Champagne sales CSV file
# The dataset has two columns: Month and Sales
df <- read.csv('/Users/jihwan/Documents/Academic/2024-2025/4A03Project/monthly_champagne_sales.csv')

# Convert the Sales column into a time series object: Starting at 1964, frequency = 12 for monthly data
ts_sales <- ts(df$Sales, start = c(1964, 1), frequency = 12)

# Check if there are any missing values in the Sales data
print(paste("Missing Values:", sum(is.na(ts_sales))))

# Plot the original time series to visualize raw Champagne sales data
plot(ts_sales,
     ylab = "Sales (in millions)",
     xlab = "Time")

# Apply seasonal differencing (lag = 12) to remove yearly seasonality
seasonaldiff <- diff(ts_sales, lag = 12)

# Plot the seasonally differenced series to confirm removal of seasonal peaks
plot(seasonaldiff,
     ylab = "Change in Sales (in millions)",
     xlab = "Time")

# Perform the Dickey Fuller test on the differenced data to check stationarity
seasonaldiff_adf <- adf.test(seasonaldiff)
print(seasonaldiff_adf)

# Plot ACF and PACF of the seasonally differenced data
par(mfrow = c(1, 2))
acf(seasonaldiff, lag.max = 50)
pacf(seasonaldiff, lag.max = 50)
par(mfrow = c(1, 1))  # reset plotting region

# Fit an initial SARIMA model: ARIMA(0,0,0) x (1,1,0)_12
# Check model diagnostics and residual plots
model1 <- sarima(ts_sales, 0, 0, 0, 1, 1, 0, 12)

# Fit a second SARIMA model: ARIMA(0,0,1) x (1,1,0)_12
# Check model diagnostics and residual plots
model2 <- sarima(ts_sales, 0, 0, 1, 1, 1, 0, 12)

# Generate a SARIMA forecast 24 steps (months) ahead using Model 2
sarima.for(ts_sales,
           n.ahead = 24,
           p = 0, d = 0, q = 1,
           P = 1, D = 1, Q = 0,
           S = 12,
           ylab = "Sales (in millions)",
           xlab = "Time")

