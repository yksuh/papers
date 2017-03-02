x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_pt_hist2_v5.eps")
x <- subset(x, x$ITERNUM > 40) 
x <- subset(x, x$ITERNUM != 84 & x$ITERNUM != 95 & x$ITERNUM != 105 & x$ITERNUM != 116 & x$ITERNUM != 45 & x$ITERNUM != 56 & x$ITERNUM != 66 & x$ITERNUM != 77)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=10
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-xmin-17
xmax <-xmax+15
plot(h, ylim=c(0,15), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 84 & x$ITERNUM != 95 & x$ITERNUM != 105 & x$ITERNUM != 116 & x$ITERNUM != 45 & x$ITERNUM != 56 & x$ITERNUM != 66 & x$ITERNUM != 77)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=10
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-xmin-17
xmax <-xmax+15
plot(h, ylim=c(0,15), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_pt_hist2_v5.eps")
x <- subset(x, x$ITERNUM > 40) 
x <- subset(x, x$ITERNUM != 10 & x$ITERNUM != 16 & x$ITERNUM != 82 & x$ITERNUM != 87 & x$ITERNUM != 92 & x$ITERNUM != 98 & x$ITERNUM != 103 & x$ITERNUM != 108 & x$ITERNUM != 113 & x$ITERNUM != 119 & x$ITERNUM != 43 & x$ITERNUM != 48 & x$ITERNUM != 54 & x$ITERNUM != 59 & x$ITERNUM != 64 & x$ITERNUM != 69 & x$ITERNUM != 75 & x$ITERNUM != 80)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=20
nbins <- ceiling((xmax-xmin) / binsize)+1
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-xmin-57
xmax <-xmax+45
plot(h, ylim=c(0,25), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 10 & x$ITERNUM != 16 & x$ITERNUM != 82 & x$ITERNUM != 87 & x$ITERNUM != 92 & x$ITERNUM != 98 & x$ITERNUM != 103 & x$ITERNUM != 108 & x$ITERNUM != 113 & x$ITERNUM != 119 & x$ITERNUM != 43 & x$ITERNUM != 48 & x$ITERNUM != 54 & x$ITERNUM != 59 & x$ITERNUM != 64 & x$ITERNUM != 69 & x$ITERNUM != 75 & x$ITERNUM != 80)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=20
nbins <- ceiling((xmax-xmin) / binsize)+1
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-xmin-57
xmax <-xmax+45
plot(h, ylim=c(0,25), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()
