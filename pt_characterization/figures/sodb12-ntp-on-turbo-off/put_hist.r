x.org = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("1_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,200), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("1_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,200), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("2_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,200), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("2_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,200), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/3, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()


x.org = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
setEPS()
postscript("4_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,130), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("4_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,130), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()


x.org = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("8_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,100), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("8_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,100), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("16_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,100), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("16_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,120), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("32_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,100), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$METIME)+max(x$METIME))/2, max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("32_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,100), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$PRTIME)+max(x$PRTIME))/2, 90, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("64_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,60), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$METIME)+max(x$METIME))/2, max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("64_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,80), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$PRTIME)+max(x$PRTIME))/2, max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("128_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,80), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$METIME)+max(x$METIME))/2, max(h$counts)+mean(h$counts)/2, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("128_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,80), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 0.1*sd(x.sub$METIME) # rather than 2
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("256_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,60), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$METIME)+max(x$METIME))/2, max(h$counts)+mean(h$counts)/5, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("256_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,60), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$PRTIME)+max(x$PRTIME))/2, max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 0*sd(x.sub$METIME) # rather than 2
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("512_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,50), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$METIME)+max(x$METIME))/2, max(h$counts)+mean(h$counts)/5, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("512_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,50), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$PRTIME)+max(x$PRTIME))/2, max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) - 0.08*sd(x.sub$METIME) # rather than 2
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("1024_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,40), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$METIME)+max(x$METIME))/2, max(h$counts)+mean(h$counts)/5, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("1024_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,40), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) + 0*sd(x.sub$METIME) # rather than 2
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("2048_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,20), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), max(h$counts)+mean(h$counts)/5, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("2048_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,25), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend((mean(x$PRTIME)+max(x$PRTIME))/2, max(h$counts)+mean(h$counts)/4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.org = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$METIME) - 0.05*sd(x.sub$METIME) # rather than 2
x_dn = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x = subset(x.sub, x.sub$METIME >= x_dn & x.sub$METIME <= x_up)
setEPS()
postscript("4096_sec_et_hist.eps")
h = hist(x$METIME, right=F, breaks=max(x$METIME)-min(x$METIME)+1, plot=F)
plot(h, ylim=c(0,4), freq=TRUE,  xaxt='n', col="yellow", main='', xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$METIME),max(x$METIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$METIME),sd=sd(x$METIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$METIME)
lines(xfit, yfit, col="red", lwd=2)
### perform normalization of x #####
x_normal = (x$METIME-min(x$METIME))/(max(x$METIME)-min(x$METIME))
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
x_val = sort(x$METIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$METIME), 4, c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()

x.sub <- subset(x.org, x.org$ITERNUM <= 300)
x_up = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
x_dn = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x = subset(x.sub, x.sub$PRTIME >= x_dn & x.sub$PRTIME <= x_up)
postscript("4096_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F, breaks=max(x$PRTIME)-min(x$PRTIME)+1, plot=F)
plot(h, ylim=c(0,10), freq=TRUE,  xaxt='n', col="green", main='', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids)),ceiling(max(h$mids)))
axis(side=1, at=xaxtl, labels=xaxtl)
xfit<-seq(min(x$PRTIME),max(x$PRTIME),length=40)
yfit<-dnorm(xfit,mean=mean(x$PRTIME),sd=sd(x$PRTIME))
yfit <- yfit*diff(h$mids[1:2])*length(x$PRTIME)
lines(xfit, yfit, col="red", lwd=2)
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
x_val = sort(x$PRTIME)
y_val = min(h$counts) + ((y_beta)/(max(y_beta)-min(y_beta))) * (max(h$counts)-min(h$counts))
lines(x_val,y_val, col="blue", lwd=2)
legend(min(x$PRTIME), max(h$counts), c("Normal-fit","Beta-fit"), lty=c(1,1), lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()
