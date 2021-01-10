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


