x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_et_hist.eps")
xmax <- max(x$METIME)
xmin <- min(x$METIME)
h = hist(x$METIME, right=F,breaks=xmax-xmin+1,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize=1
plot(h, axes = TRUE,freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+1),col="blue", main='ET frequency on INC1', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin-1,xmax+1,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_et_hist.eps")
xmax <- max(x$METIME)
xmin <- min(x$METIME)
h = hist(x$METIME, right=F,breaks=xmax-xmin+1,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize=1
plot(h, axes = TRUE,freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+1),col="blue", main='ET frequency on INC2', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin-1,xmax+1,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_et_hist.eps")
xmax <- max(x$METIME)
xmin <- min(x$METIME)
h = hist(x$METIME, right=F,breaks=xmax-xmin+1,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize=1
plot(h, axes = TRUE,freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+1),col="blue", main='ET frequency on INC4', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin-1,xmax+1,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_et_hist.eps")
xmax <- max(x$METIME)
xmin <- min(x$METIME)
binsize <- 4
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-binsize,8500),col="blue", main='ET frequency on INC8', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmin <- min(x$METIME)
xmin <- floor(xmin/100)*100
binsize <- 4
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC16', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmin <- min(x$METIME)
xmin <- floor(xmin/100)*100
binsize <- 8
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC32', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("64_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmin <- min(x$METIME)
xmin <- floor(xmin/100)*100
binsize <- 4
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC64', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("128_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmin <- min(x$METIME)
xmin <- floor(xmin/100)*100
binsize <- 16
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- 250
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC128', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("256_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmin <- min(x$METIME)
xmin <- floor(xmin/500)*500
xmin <- 256000
binsize <- 64
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC256', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmax <- 540000
xmin <- min(x$METIME)
xmin <- floor(xmin/500)*500
xmin <- 510000
binsize <- 512
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC512', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_et_hist.eps")
xmax <- max(x$METIME)
xmax <- ceiling(xmax/100)*100
xmax <- 1050000
xmin <- min(x$METIME)
xmin <- floor(xmin/500)*500
xmin <- 1020000
binsize <- 512
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC1024', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2048_sec_et_hist.eps")
max(x$METIME)
min(x$METIME)
xmax <- max(x$METIME)
xmax <- ceiling(xmax/10000)*10000
#xmax <- 1050000
xmin <- min(x$METIME)
xmin <- floor(xmin/10000)*10000
#xmin <- 1020000
binsize <- 512
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC2048', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4096_sec_et_hist.eps")
max(x$METIME)
min(x$METIME)
xmax <- max(x$METIME)
xmax <- ceiling(xmax/10000)*10000
#xmax <- 1050000
xmin <- min(x$METIME)
xmin <- floor(xmin/10000)*10000
#xmin <- 1020000
binsize <- 2048
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- 250
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC4096', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 40)
setEPS()
postscript("8192_sec_et_hist.eps")
max(x$METIME)
min(x$METIME)
xmax <- max(x$METIME)
xmax <- ceiling(xmax/500)*500
xmax <- 8209500
xmin <- min(x$METIME)
xmin <- floor(xmin/1000)*1000
xmin <- 8207500
binsize <- 128
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- 10
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 40)
setEPS()
postscript("16384_sec_et_hist.eps")
max(x$METIME)
min(x$METIME)
xmax <- max(x$METIME)
xmax <- ceiling(xmax/1000)*1000
xmax <- 16445000
xmin <- min(x$METIME)
xmin <- floor(xmin/1000)*1000
#xmin <- 8207500
binsize <- 512
nbins <- (xmax-xmin)/binsize
h = hist(x$METIME, right=F,breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- 30
binsize <- h$breaks[2] - h$breaks[1] 
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin,xmax),col="blue", main='ET frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()
