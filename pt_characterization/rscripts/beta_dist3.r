
#### 16 second task #####

x = read.csv(file="16_sec.txt",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 16-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
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
x_beta<-dbeta(x_normal,a,b)
### get another histogram on the new x-axis values #####
h_beta = hist(x_beta, breaks=length(h$breaks),right=F, plot=F)
### denormalize to the raw x-axis values from the x-axis values by beta distribution #####
x_val = min(x$PRTIME) + ((h_beta$mids)/(max(h_beta$breaks)-min(h_beta$breaks))) * (max(x$PRTIME)-min(x$PRTIME))
### get frequency data of the histogram on the new x-axis values #####
y_val = h_beta$counts
### fit x_val and y_val #####
lines(x_val,y_val, col="blue", lwd=2)
dev.off()

#### 32 second task #####

x = read.csv(file="32_sec.txt",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_pt_beta.eps")
h = hist(x$PRTIME, right=F, plot=F)
### perform normalization of x #####
x_normal = (x$PRTIME-min(x$PRTIME))/(max(x$PRTIME)-min(x$PRTIME))
### get histogram on normalized x #####
h_normal = hist(x_normal, breaks=length(h$breaks),right=F, plot=F)
plot(h, freq=TRUE, ylim=c(0,400),xaxt='n', col="green", main='PT frequency on the 32-second task', xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(floor(min(h$mids))-2,ceiling(max(h$mids))+1)
axis(side=1, at=xaxtl, labels=xaxtl)
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
x_beta<-dbeta(x_normal,a,b)
### get another histogram on the new x-axis values #####
h_beta = hist(x_beta, breaks=15,right=F, plot=F)
### denormalize to the raw x-axis values from the x-axis values by beta distribution #####
x_val = min(x$PRTIME) + ((h_beta$mids)/(max(h_beta$breaks)-min(h_beta$breaks))) * (max(x$PRTIME)-min(x$PRTIME))
### get frequency data of the histogram on the new x-axis values #####
y_val = h_beta$counts
### fit x_val and y_val #####
lines(x_val,y_val, col="blue", lwd=2)
dev.off()


