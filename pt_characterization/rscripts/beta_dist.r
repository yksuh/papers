###### 1 second task #######

x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,200),xaxt='n', col="green", main='PT frequency on the 2-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()


###### 2 second task #######
x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,200),xaxt='n', col="green", main='PT frequency on the 2-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()


###### 4 second task #######

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 4-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()


###### 8 second task #######

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 8-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()


###### 16 second task #######

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 16-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 32 second task #######

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 32-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 64 second task #######

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("64_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 64-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 128 second task #######

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("128_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,150), xaxt='n', col="green", main='PT frequency on the 128-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-3,max(x$PRTIME)+4)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 256 second task #######

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("256_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,200), xaxt='n', col="green", main='PT frequency on the 256-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-5,max(x$PRTIME)+5)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 512 second task #######

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a+1,b+1)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,300), xaxt='n', col="green", main='PT frequency on the 512-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-30,max(x$PRTIME)+30)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 1024 second task #######

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,300), xaxt='n', col="green", main='PT frequency on the 1024-second task', xlab='PT (ms)', ylab=expression('Frequency'))
nb = ceiling((max(h$mids)-min(h$mids))/20)
xaxtl <- seq(min(x$PRTIME)-20,max(x$PRTIME)+20, by=nb)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()

###### 2048 second task #######

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2048_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
x_normal = sort(x_normal)

### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
### get mean/variance of normalized x #####
m = mean(x_normal)
v = var(x_normal)
estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(params = list(alpha = alpha, beta = beta))
}
### get parameters a, b from beta distribution on normalized x #####
r <- estBetaParams(m,v)
a <- r[1]; b <- r[2]
a <- as.double(a)
b <- as.double(b)

### get new x-axis values by beta distribution of normalized x #####
y_beta<-dbeta(x_normal,a,b)

### fit x_val and y_val #####
plot(h, freq=TRUE, ylim=c(0,100),  xaxt='n', col="green", main='PT frequency on the 2048-second task', xlab='PT (ms)', ylab=expression('Frequency'))
nb = ceiling((ceiling(max(h$mids))-floor(min(h$mids)))/20)
xaxtl <- seq(floor(min(h$mids)-10),ceiling(max(h$mids)+10), by=nb)
axis(side=1, at=xaxtl, labels=xaxtl)
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
dev.off()
setEPS()
