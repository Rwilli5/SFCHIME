# SIR Model
# Anshul Saxena
# 2020-04-03


library(deSolve)
library(tidyverse)
library(lubridate)

data_all <- read.csv("https://urldefense.proofpoint.com/v2/url?u=https-3A__raw.githubusercontent.com_nytimes_covid-2D19-2Ddata_master_us-2Dcounties.csv&d=DwIGAg&c=lhMMI368wojMYNABHh1gQQ&r=mVr-r9NPAqGQx9-ub1jree0Ze-CRIXG5uPNvt5ADyuo&m=dbqn59Hx7Y17l9DeUN6GwXoVLlwr1CbQr7Hdzdr4DOA&s=Uq_LcDFn4p2V_0zHo9zxyJHzs_8cl1e5e5iZzUQFa6M&e= ")

# Can also use JHU source, that one is more recent

mdc <- data_all %>% filter(state=='Florida') %>% filter(fips==12086) %>%
  mutate(incidence = c(0, diff(cases)), time=(1:length(cases)), Date=date(date))

data1=mdc


SIR <- function(time, state, parameters) {
  par <- as.list(c(state, parameters))
  with(par, {
    dS <- -beta/N * I * S
    dI <- beta/N * I * S - gamma * I
    dR <- gamma * I
    list(c(dS, dI, dR))
  })
}

Infected <- data1$cases
Day <- 1:(length(Infected))



N <- 2752000 # population of MDC


old <- par(mfrow = c(1, 2))
plot(Day, Infected, type ="b")
plot(Day, Infected, log = "y", ylab = "Infected (log scaled)")
abline(lm(log10(Infected) ~ Day))
title("Confirmed COVID Cases in Miami-Dade (2020-04-01)", outer = TRUE, line = -2)


init <- c(S = N-Infected[1], I = Infected[1], R = 0)
RSS <- function(parameters) {
  names(parameters) <- c("beta", "gamma")
  out <- ode(y = init, times = Day, func = SIR, parms = parameters)
  fit <- out[ , 3]
  sum((Infected - fit)^2)
}

Opt <- optim(c(0.5, 0.5), RSS, method = "L-BFGS-B", lower = c(0, 0), upper = c(1, 1)) 

Opt$message
## [1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"

Opt_par <- setNames(Opt$par, c("beta", "gamma"))
Opt_par


t <- 1:70 # time in days
fit <- data.frame(ode(y = init, times = t, func = SIR, parms = Opt_par))
col <- 1:3 # colour

matplot(fit$time, fit[ , 2:4], type = "l", xlab = "Day", ylab = "Number of subjects", lwd = 2, lty = 1, col = col)
matplot(fit$time, fit[ , 2:4], type = "l", xlab = "Day", ylab = "Number of subjects (log scaled)", lwd = 2, lty = 1, col = col, log = "y")


points(Day, Infected)
legend("bottomright", c("Susceptible", "Infected", "Recovered"), lty = 1, lwd = 2, col = col, inset = 0.05)
title("SIR model for total COVID cases in Miami-Dade (2020-04-01)", outer = TRUE, line = -2)

par(old)

R0 <- setNames(Opt_par["beta"] / Opt_par["gamma"], "R0")
R0