# SIR Model
# Anshul Saxena
# 2020-04-03

# Gabriel Odom cleaned this code on 2020-04-03


library(deSolve)
library(tidyverse)
library(lubridate)


######  Import and Explore Data  ##############################################
data_all <- read.csv(
  "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"
)

# Can also use JHU source, that one is more recent

dataMDC <- data_all %>%
  filter(fips == 12086) %>%
  mutate(
    incidence = c(0, diff(cases)),
    day       = 1:length(cases),
    Date      = date(date)
  ) %>% 
  select(-date, -county, -state, -fips)


par(mfrow = c(1, 2))
plot(dataMDC$day, dataMDC$cases, type ="b")
plot(dataMDC$day, dataMDC$cases, log = "y", ylab = "Infected (log scaled)")
abline(lm(log10(dataMDC$cases) ~ dataMDC$day))
title(
  "Confirmed COVID Cases in Miami-Dade (2020-04-01)",
  outer = TRUE,
  line = -2
)



######  Set Up Optimisation  ##################################################
N <- 2752000 # population of MDC

init <- c(
  S = N - dataMDC$cases[1],
  I = dataMDC$cases[1],
  R = 0
)

SIR <- function(time, state, parameters) {
  
  par <- as.list(c(state, parameters))
  
  with(
    data = par,
    expr = {
      
      dS <- -beta/N * I * S
      dI <- beta/N * I * S - gamma * I
      dR <- gamma * I
      list(c(dS, dI, dR))
      
    }
  )
  
}

RSS <- function(parameters, .f, initialVals, response, day_int) {
  
  names(parameters) <- c("beta", "gamma")
  
  out <- ode(
    y = initialVals,
    times = day_int,
    func = .f,
    parms = parameters
  )
  
  fit <- out[ , 3]
  sum((response - fit) ^ 2)
  
}

algorithms <- c(
  NelderMead = "Nelder-Mead",
  QuasiNewton = "BFGS",
  ConjGrad = "CG",
  BddQuasiNewton = "L-BFGS-B",
  SimAnneal = "SANN"
)

fitMessages <- vector("list", length = length(algorithms))

optParams <- vector("list", length = length(algorithms))

R0 <- rep(NA_real_, length = length(algorithms))

names(R0) <- names(fitMessages) <- names(optParams) <- names(algorithms)



######  Fit Predictions  ######################################################
col <- 1:3
for (m in 3:length(algorithms)) {
  # Nelder-Mead and Quasi-Newton are bad; if you get negative values from 
  #   simulated annealing, run it again.
  # browser()
  
  alg <- algorithms[m]
  
  ###  Optimimal Slution  ###
  if(alg != "L-BFGS-B"){
    Opt <- optim(
      par = c(0.5, 0.5),
      fn = RSS,
      .f = SIR,
      initialVals = init,
      response = dataMDC$cases,
      day_int = dataMDC$day,
      method = alg
    ) 
  } else {
    Opt <- optim(
      par = c(0.5, 0.5),
      fn = RSS,
      .f = SIR,
      initialVals = init,
      response = dataMDC$cases,
      day_int = dataMDC$day,
      method = alg,
      lower = c(0, 0),
      upper = c(5, 5)
    ) 
  }
  
  fitMessages[[m]] <- Opt$message
  ## [1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"
  # "ERROR: ABNORMAL_TERMINATION_IN_LNSRCH"
  
  Opt_par <- setNames(Opt$par, c("beta", "gamma"))
  
  optParams[[m]] <- Opt_par
  
  R0[m] <- Opt_par["beta"] / Opt_par["gamma"]
  
  
  ###  Plot Prediction  ###
  fit <- data.frame(
    ode(y = init, times = 1:70, func = SIR, parms = Opt_par)
  )
  
  matplot(
    fit$time, fit[ , 2:4],
    type = "l",
    xlab = "Day",
    ylab = "Number of subjects",
    lwd = 2,
    lty = 1,
    col = col
  )
  matplot(
    fit$time, fit[ , 2:4],
    type = "l",
    xlab = "Day",
    ylab = "Number of subjects (log scaled)",
    lwd = 2,
    lty = 1,
    col = col,
    log = "y"
  )
  points(dataMDC$day, dataMDC$cases)
  legend(
    "bottomright",
    c("Susceptible", "Infected", "Recovered"),
    lty = 1,
    lwd = 2,
    col = col,
    inset = 0.05
  )
  title(
    paste(
      "SIR model for total COVID cases in Miami-Dade (2020-04-01) using",
      names(alg),
      "Numeric Optimization"
    ),
    outer = TRUE,
    line = -2
  )
  
  # END for()
}

###  Optimal Parameters and R0  ###
# Conjugate Gradients:  beta = 0.6856, gamma = 0.3144, R0 = 2.18
# Bounded Quasi-Newton: beta = 0.8342, gamma = 0.4629, R0 = 1.80
# Simulated Annealing:  beta = 1.0870, gamma = 0.7152, R0 = 1.52

