x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_pt_hist_v5.eps")
binsize=1
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$PRTIME)
xmax <-max(x$PRTIME)
plot(h, ylim=c(0,1000), xaxt='n',freq=TRUE,xlim=c(xmin-1,xmax+1),col="green", main='PT frequency on INC1', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin-1,xmax+1,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_pt_hist_v5.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-2,max(x$PRTIME)+3),col="green", main='PT frequency on INC2', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_pt_hist_v5.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,400), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-2,max(x$PRTIME)+4),col="green", main='PT frequency on INC4', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 629 & x$ITERNUM != 658)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,350), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+4),col="green", main='PT frequency on INC8', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 686 & x$ITERNUM != 700)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,300), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-8,max(x$PRTIME)+8),col="green", main='PT frequency on INC16', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 284 & x$ITERNUM != 291 & x$ITERNUM != 727 & x$ITERNUM != 732 & x$ITERNUM != 734)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,250), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-5,max(x$PRTIME)+9),col="green", main='PT frequency on INC32', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("64_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 85 & x$ITERNUM != 89 & x$ITERNUM != 308 & x$ITERNUM != 312 & x$ITERNUM != 437 
& x$ITERNUM != 437 & x$ITERNUM != 531 & x$ITERNUM != 535 & x$ITERNUM != 754 
& x$ITERNUM != 758 & x$ITERNUM != 977 & x$ITERNUM != 981)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,200), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-9,max(x$PRTIME)+8),col="green", main='PT frequency on INC64', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("128_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 90 & x$ITERNUM != 202)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=1
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
plot(h, ylim=c(0,80), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+5),col="green", main='PT frequency on INC128', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("256_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM != 6 & x$ITERNUM != 62 & x$ITERNUM != 118 & x$ITERNUM != 171 & x$ITERNUM != 202 & x$ITERNUM != 258)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=1
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
plot(h, ylim=c(0,50), axes = TRUE,freq=TRUE,xlim=c(xmin-4,xmax+7),col="green", main='PT frequency on INC256', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 16 & x$ITERNUM != 44 & x$ITERNUM != 72 & x$ITERNUM != 100 & x$ITERNUM != 128 & x$ITERNUM != 156 &
	       x$ITERNUM != 184 & x$ITERNUM != 212 & x$ITERNUM != 240 & x$ITERNUM != 268 & x$ITERNUM != 296 & x$ITERNUM != 297)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=1
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmax <- xmax + 8
xmin <- xmin - 3
plot(h, ylim=c(0,50), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC512', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=5)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 27 & x$ITERNUM != 88 & x$ITERNUM != 252 & x$ITERNUM != 276)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=5
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$PRTIME)-16
xmax <-max(x$PRTIME)+26
plot(h, ylim=c(0,140), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC1024', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=20)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2048_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 117)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=5
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$PRTIME)-17
xmax <-max(x$PRTIME)+19
plot(h, ylim=c(0,100), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC2048', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4096_sec_pt_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 3 & x$ITERNUM != 36 & x$ITERNUM != 57 & x$ITERNUM != 116 & x$ITERNUM != 119 & x$ITERNUM != 135 & x$ITERNUM != 180 & x$ITERNUM != 284)
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmax <- max(x$PRTIME)
xmin <- min(x$PRTIME)
binsize=10
nbins <- ceiling((xmax-xmin) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-xmin-26
xmax <-xmax+27
plot(h, ylim=c(0,50), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC4096', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_pt_hist1_v5.eps")
#x <- subset(x, x$ITERNUM <= 40) 
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
postscript("16384_sec_pt_hist1_v5.eps")
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

