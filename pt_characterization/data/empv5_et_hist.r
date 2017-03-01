x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_et_hist_v5.eps")
binsize=1
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
xmin <-min(x$METIME)
xmax <-max(x$METIME)
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+1),col="blue", main='ET frequency on INC1', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_et_hist_v5.eps")
binsize=1
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
xmin <-min(x$METIME)
xmax <-max(x$METIME)
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+1),col="blue", main='ET frequency on INC2', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_et_hist_v5.eps")
binsize=1
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
xmin <-min(x$METIME)
xmax <-max(x$METIME)
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-2,xmax+2),col="blue", main='ET frequency on INC4', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_et_hist_v5.eps")
binsize=1
x <- subset(x, x$ITERNUM != 629 & x$ITERNUM != 658)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-binsize-1,xmax+binsize+1),col="blue", main='ET frequency on INC8', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 686 & x$ITERNUM != 700)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+2),col="blue", main='ET frequency on INC16', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()


x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 284 & x$ITERNUM != 291 & x$ITERNUM != 727 & x$ITERNUM != 732 & x$ITERNUM != 734)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=1
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-1,xmax+2),col="blue", main='ET frequency on INC32', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
#xaxtl <- seq(xmin-1,xmax+1,by=1)
#axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("64_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 85 & x$ITERNUM != 89 & x$ITERNUM != 308 & x$ITERNUM != 312 & x$ITERNUM != 437 & x$ITERNUM != 437 & x$ITERNUM != 531 & x$ITERNUM != 535 & x$ITERNUM != 754 & x$ITERNUM != 758 & x$ITERNUM != 977 & x$ITERNUM != 981)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=1
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-4,xmax+4),col="blue", main='ET frequency on INC64', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("128_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 90 & x$ITERNUM != 202)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=1
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 80
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-4,xmax+4),col="blue", main='ET frequency on INC128', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("256_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 6 & x$ITERNUM != 62 & x$ITERNUM != 118 & x$ITERNUM != 171 & x$ITERNUM != 202 & x$ITERNUM != 258)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=1
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 60
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-3,xmax+2),col="blue", main='ET frequency on INC256', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 16 & x$ITERNUM != 44 & x$ITERNUM != 72 & x$ITERNUM != 100 & x$ITERNUM != 128 & x$ITERNUM != 156 &
	       x$ITERNUM != 184 & x$ITERNUM != 212 & x$ITERNUM != 240 & x$ITERNUM != 268 & x$ITERNUM != 296 & x$ITERNUM != 297)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=1
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 50
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-5,xmax+5),col="blue", main='ET frequency on INC512', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 27 & x$ITERNUM != 88 & x$ITERNUM != 252 & x$ITERNUM != 276)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=2
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 60
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-10,xmax+10),col="blue", main='ET frequency on INC1024', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2048_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 117)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=5
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 80
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-100,xmax+100),col="blue", main='ET frequency on INC2048', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4096_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM <= 300)
x <- subset(x, x$ITERNUM != 3 & x$ITERNUM != 36 & x$ITERNUM != 57 & x$ITERNUM != 116 & x$ITERNUM != 119 & x$ITERNUM != 135 & x$ITERNUM != 180 & x$ITERNUM != 284)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=50
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 30
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-500,xmax+500),col="blue", main='ET frequency on INC4096', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <= 40)
setEPS()
postscript("8192_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 44 & x$ITERNUM != 55 & x$ITERNUM != 65 & x$ITERNUM != 76)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=50
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 20
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-200,xmax+200),col="blue", main='ET frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 10 & x$ITERNUM != 16 & x$ITERNUM != 47 & x$ITERNUM != 52 & x$ITERNUM != 58 & x$ITERNUM != 63 
& x$ITERNUM != 68 & x$ITERNUM != 73 & x$ITERNUM != 79)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=50
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 20
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-100,xmax+300),col="blue", main='ET frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()
