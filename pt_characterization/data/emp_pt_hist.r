x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-1,max(x$PRTIME)+1),col="green", main='PT frequency on INC1', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-1,max(x$PRTIME)+1,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
#axis(side=1, at=seq(min(h$mids)-1,max(h$mids)+1,1), labels=seq(min(x$PRTIME),max(x$PRTIME)+1,by=1))
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-2,max(x$PRTIME)+1),col="green", main='PT frequency on INC2', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-2,max(x$PRTIME)+2),col="green", main='PT frequency on INC4', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,350), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-2,max(x$PRTIME)+2),col="green", main='PT frequency on INC8', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,300), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-5,max(x$PRTIME)+5),col="green", main='PT frequency on INC16', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,250), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+1),col="green", main='PT frequency on INC32', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("64_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,200), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+5),col="green", main='PT frequency on INC64', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("128_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,80), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+5),col="green", main='PT frequency on INC128', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("256_sec_pt_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, ylim=c(0,50), axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+2),col="green", main='PT frequency on INC256', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_pt_hist.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=5
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
plot(h, ylim=c(0,200), xaxt='n',freq=TRUE,xlim=c(min(x$PRTIME)-15,max(x$PRTIME)+28),col="green", main='PT frequency on INC512', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-15,max(x$PRTIME)+28,by=15)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_pt_hist.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=5
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$PRTIME)-16
xmax <-max(x$PRTIME)+19
plot(h, ylim=c(0,140), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC1024', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=20)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2048_sec_pt_hist.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=10
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
max(x$PRTIME)-min(x$PRTIME)
xmin <-min(x$PRTIME)-21
xmax <-max(x$PRTIME)+24
plot(h, ylim=c(0,150), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC2048', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4096_sec_pt_hist.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=10
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
max(x$PRTIME)-min(x$PRTIME)
xmin <-min(x$PRTIME)-21
xmax <-max(x$PRTIME)+21
plot(h, ylim=c(0,50), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC4096', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_pt_hist.eps")
binsize=10
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
max(x$PRTIME)-min(x$PRTIME)
xmin <-min(x$PRTIME)-10
xmax <-max(x$PRTIME)+23
ymax <- ceiling(max(h$counts)/10)*10
plot(h, ylim=c(0,ymax), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_pt_hist.eps")
binsize=20
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
max(x$PRTIME)-min(x$PRTIME)
xmin <-min(x$PRTIME)-47
xmax <-max(x$PRTIME)+56
ymax <- ceiling(max(h$counts)/10)*10
plot(h, ylim=c(0,ymax), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

