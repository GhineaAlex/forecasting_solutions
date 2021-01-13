## Used libraries

library(fpp2)
library(tseries)

## Exercise 1

### Explain the differences among these figures. Do they all indicate that the data are white noise?
  
### Afiseaza diferite valori critice. Toate graficele indica ca datele sunt white noise.

### Why are the critical values at different distances from the mean of zero? Why are the autocorrelations different in each figure when they each refer to white noise?

### Valorile critice demonstreaza faptul ca sunt la distante diferite fata de zero. Distanta diferita este cauzata de numarul de observatii realizate.
### Cu cat sunt mai multe observatii intr-un set de date care indica white noise, cu atat apare mai putin noise in estimarile corelarii.


## Exercise 2

ggtsdisplay(ibmclose)

### ggtsdisplay este o functie care ploteaza o serie de timp cu ACF si PACF

## Exercise 3

###For the following series, find an appropriate Box-Cox transformation and order of differencing in order to obtain stationary data.

#a. usnetelec
plot(usnetelec)
#Avand in vedere forma seriei, putem observa o crestere usor liniara
plot(diff(usnetelec))
Acf(diff(usnetelec), lag.max = 100)

Pacf(diff(usnetelec), lag.max = 100)

#Functiile ACF si PACF arata ca diferentele dintre seriile de date se comporta aproape ca un white noise

#b. usgdp

plot(usgdp)
Acf(usgdp)

Pacf(usgdp)

#Exista o valoare care este aproape 1, deci trebuie diferentiat (procesul nefiind non-stationar). Nu putem aplica modelul ARIMA fara diferentiere

lambda = BoxCox.lambda(usgdp)
plot(diff(BoxCox(usgdp,lambda)))

#Vom alege o valoare lambda pentru a diferentia cu o anumita putere

Acf(diff(BoxCox(usgdp, lambda)))
Pacf(diff(BoxCox(usgdp, lambda)))

#Dupa diferentierea realizata cu valoarea lambda putem observa ca seria de timp este stationara

#c. mcopper

plot(mcopper)

Acf(mcopper)

Pacf(mcopper)

lambda = BoxCox.lambda(mcopper)
plot(diff(BoxCox(mcopper, lambda)))

Acf(diff(BoxCox(mcopper, lambda)))
### ACF scade rapid cu cateva perturbatii pentru valorile mari de lag
Pacf(diff(BoxCox(mcopper, lambda)))

### ACF si PACF sunt stationare

#d. enplanements

plot(enplanements)
plot(log(enplanements))

Acf(log(enplanements))

### Datele trebuie diferentiate pentru a aplica modelul ARIMA. Cand aplicam log pe ACF, datele nu converg catre valori critice

Pacf(log(enplanements))

### Seria de timp trebuie diferentiata pentru a aplica modelul Arima. Datele sunt sezoniere si trebuie diferentiate cu un lag egal cu numarul de sezoane
plot(diff(log(enplanements), lag = 12))
acf(diff(log(enplanements), lag = 12))
pacf(diff(log(enplanements), lag = 12))

### Trebuie diferentiate de doua ori

plot(diff(diff(log(enplanements), lag = 12)))

acf(diff(diff(log(enplanements), lag = 12)))
pacf(diff(diff(log(enplanements), lag = 12)))

#e. visitors

plot(visitors)
lambda = BoxCox.lambda(visitors)
plot(BoxCox(visitors, lambda))

Acf(BoxCox(visitors, lambda))
### Avand in vedere modul lent prin care valorile scad lent, seria de date trebuie diferentiata

Pacf(BoxCox(visitors, lambda))

plot(diff(BoxCox(visitors, lambda), lag = 12))

Acf(diff(BoxCox(visitors, lambda), lag = 12))
Pacf(diff(BoxCox(visitors, lambda), lag = 12))

plot(diff(diff(BoxCox(visitors, lambda), lag = 12)))
Acf(diff(diff(BoxCox(visitors, lambda), lag = 12)))
Pacf(diff(diff(BoxCox(visitors, lambda), lag = 12)))

#EXERCISE 7

#Consider wmurders, the number of women murdered each year (per 100,000 standard population) in the United States.

#a. By studying appropriate graphs of the series in R, find an appropriate ARIMA(p, d, q) model for these data.

autoplot(wmurders)

#nu este nevoie de diferentiere sezoniera , ci doar de o diferentiere simpla
autoplot(diff(wmurders))

ndiffs(wmurders)
#conform ndiffs mai avem nevoie de 2 diferentieri
autoplot(diff(wmurders, differences = 2))
kpss.test(diff(wmurders, differences = 2))
#dupa 2 diferentieri seria devine stationara si trece testul kpss
diff(wmurders, differences = 2) %>% ggtsdisplay()

#Exista valori cu spike uri la lag 1 in cazul PACF si lag 2 in cazul ACF. Vom aplica un model (0,2,2)

#b. Should you include a constant in the model? Explain
# Nu voi include o constanta in model, ci va fi realizata diferentierea de doua ori. Introducerea unei constante poate crea un trend.

#c. Write this model in terms of backshift operator
#(1-B)^2Yt = (1 + thetaB + theta2B^2)*epsilont

#d. Fit the model using R and examine the residuals. Is the model satisfactory?

ex.arima <- Arima(wmurders, order = c(0,2,2))
checkresiduals(ex.arima)

#e. Forecast three times ahead. Check your forecasts by hand to make sure that you know how they have been calculated.

ex.arima <- forecast (ex.arima, h = 3)

#f. Create a plot of the series with the forecasts and precition intervals for the next three periods shown.

autoplot(ex.arima)

#g. Does auto.arima() give the same model you have chosen? If not, which model do you think is better?

ex.autoarima <- forecast( auto.arima(wmurders), h = 3)

#EXERCISE 8 

## Consider austa, the total international visitors to Australia (in millions) for the period 1980-2015.

### Use auto.arima() to find an appropriate ARIMA model. What model was selected. 
### Check that the residuals look like white noise. Plot forecasts for the next 10 periods.

autoplot(austa)
austa.arima <- forecast(auto.arima(austa), h = 10)

austa.arima$model

#ARIMA(0,1,1) with drift 

checkresiduals(austa.arima)
autoplot(austa.arima)

#Plot forecasts from an ARIMA(0,1,1) model with no drift and compare these to part a. Remove the MA term and plot again.

austa.arima011 <- forecast(Arima(austa, order = c(0,1,1)), h = 10)
autoplot(austa.arima011)

austa.arima010 <- forecast(Arima(austa, order = c(0,1,0)), h = 10)
autoplot(austa.arima010)

#Plot forecasts from an ARIMA(2,1,3) model with drift. Remove the constant and see what happens.
austa.arima213 <- forecast(Arima(austa, order = c(2,1,3), include.drift=TRUE), h = 10)
autoplot(austa.arima213)

austa.arima.drift <- austa.arima213$model$coef[6]
austa.arima213.nod <- austa.arima213$mean - austa.arima.drift

#Plot forecasts from an ARIMA(0,0,1) model with a constant. Remove the MA term and plot again.

austa.arima001 <- forecast(Arima(austa, order = c(0,0,1), include.constant = TRUE), h = 10)
autoplot(austa.arima001)

#Plot forecasts from an ARIMA(0,2,1) model with no constant.

austa.arima021 <- forecast(Arima(austa, order = c(0,2,1)), h = 10)
autoplot(austa.arima021)

#EXERCISE 9 

##For the usgdp series:

##If necessary, find a suitable Box-Cox transformation for the data;
autoplot(usgdp)
autoplot(BoxCox(usgdp, BoxCox.lambda(usgdp)))
us.lambda <- BoxCox.lambda(usgdp)
##fit a suitable ARIMA model to the transformed data using auto.arima();
us.auto.arima <- auto.arima(usgdp, lambda = us.lambda)
autoplot(usgdp) + autolayer(us.auto.arima$fitted)
#modelul se muleaza bine pe graficul initial usgdp
##try some other plausible models by experimenting with the orders chosen;
ndiffs(BoxCox(usgdp, us.lambda))
#avem nevoie de o diferentiere
ggtsdisplay(diff(BoxCox(usgdp, us.lambda)))

us.arima110.drift <- Arima(usgdp, lambda = us.lambda, order = c(1,1,0), include.drift = TRUE)
autoplot(usgdp, "raw") + autolayer(us.arima110$fitted, series = "fit")

##Choose what you think is the best model and check the residual diagnostics;
accuracy(us.arima110.drift)
checkresiduals(us.arima110.drift)
###rezidualele nu sunt distribuite normal 


##Produce forecasts of your fitted model. Do the forecasts look reasonable?
usgdp.autoarima <- forecast(us.auto.arima)
autoplot(usgdp.autoarima)

##Compare the results with what you would obtain using ets() (with no transformation).
us.ets <- forecast(ets(usgdp))
autoplot(us.ets)

#EXERCISE 13

###Choose one of the following seasonal time series: hsales, auscafe, qauselec, qcement, qgas.

autoplot(qcement)

## Aplicam o transformare Boxcox pentru a uniformiza variatiile
lambda.qcement <- BoxCox.lambda(qcement)

### Are the data stationary? If not, find an appropriate differencing which yields stationary data.

## datele au sezonalitate si un trend ascedent
ndiffs(qcement)

## avem nevoie de o diferentiere
kpss.test(diff(qcement, lag = 2))

### Identify a couple of ARIMA models that might be useful in describing the time series. Which of your models is the best according to their AIC values?

ggtsdisplay(diff(BoxCox(qcement, lambda.qcement), lag = 2))

qcement <- auto.arima(qcement, lambda = lambda.qcement)

qcement.arima <- Arima(qcement, lambda = lambda.qcement, order = c(0,1,1), seasonal = c(0,1,1))

## Estimate the parameters of your best model and do diagnostic testing on the residuals. Do the residuals resemble white noise? If not, try to find another ARIMA model which fits better.

