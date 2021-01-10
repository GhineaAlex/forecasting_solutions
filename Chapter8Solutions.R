## Used libraries

library(fpp2)
library(xlsx)
library(rdatamarket)
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

#Functiile ACF si PACF arata ca diferentele dintre seriile de date se comporta aproape ca un white

#b. usgdp

plot(usgdp)
Acf(usgdp, lag.max = 100)

Pacf(usgdp, lag.max = 100)

#Exista o valoare care este aproape 1, deci trebuie diferentiat (procesul nefiind non-stationar). Nu putem aplica modelul ARIMA fara diferentiere

lambda = BoxCox.lambda(usgdp)
plot(diff(BoxCox(usgdp,lambda)))

#Vom alege o valoare lambda pentru a diferentia cu o anumita putere

Acf(diff(BoxCox(usgdp, lambda)), lag.max = 100)
Pacf(diff(BoxCox(usgdp, lambda)), lag.max = 100)

#Dupa diferentierea realizata cu valoarea lambda putem observa ca seria de timp este stationara

#c. mcopper

plot(mcopper)

Acf(mcopper, lag.max = 100)

Pacf(mcopper, lag.max = 100)

lambda = BoxCox.lambda(mcopper)
plot(diff(BoxCox(mcopper, lambda)))

Acf(diff(BoxCox(mcopper, lambda)), lag.max = 100)
### ACF scade rapid cu cateva perturbatii pentru valorile mari de lag
Pacf(diff(BoxCox(mcopper, lambda)), lag.max = 100)

### ACF si PACF sunt stationare

#d. enplanements

plot(enplanements)
plot(log(enplanements))

Acf(log(enplanements), lag.max = 100)

### Datele trebuie diferentiate pentru a aplica modelul ARIMA. Cand aplicam log pe ACF, datele nu converg catre valori critice

Pacf(log(enplanements), lag.max = 100)

### Seria de timp trebuie diferentiata pentru a aplica modelul Arima. Datele sunt sezoniere si trebuie diferentiate cu un lag egal cu numarul de sezoane
plot(diff(log(enplanements), lag = 12))
acf(diff(log(enplanements), lag = 12), lag.max = 100)
pacf(diff(log(enplanements), lag = 12), lag.max = 100)

### Trebuie diferentiate de doua ori

plot(diff(diff(log(enplanements), lag = 12)))

acf(diff(diff(log(enplanements), lag = 12)), lag.max = 100)
pacf(diff(diff(log(enplanements), lag = 12)), lag.max = 100)

#e. visitors
