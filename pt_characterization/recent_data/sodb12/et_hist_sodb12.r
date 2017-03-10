## sodb12
## 8192_sec

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_et_hist2_v5.eps")
x <- subset(x, x$ITERNUM > 40) 
x <- subset(x, x$ITERNUM != 84 & x$ITERNUM != 95 & x$ITERNUM != 105 & x$ITERNUM != 116 & x$ITERNUM != 45 & x$ITERNUM != 56 & x$ITERNUM != 66 & x$ITERNUM != 77)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=20
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 20
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-50,xmax+50),col="blue", main='ET frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 84 & x$ITERNUM != 95 & x$ITERNUM != 105 & x$ITERNUM != 116 & x$ITERNUM != 45 & x$ITERNUM != 56 & x$ITERNUM != 66 & x$ITERNUM != 77)
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
ymax <- 50
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-200,xmax+200),col="blue", main='ET frequency on INC8192', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_et_hist2_v5.eps")
x <- subset(x, x$ITERNUM > 40)
x <- subset(x, x$ITERNUM != 10 & x$ITERNUM != 16 & x$ITERNUM != 82 & x$ITERNUM != 87 & x$ITERNUM != 92 & x$ITERNUM != 98 & x$ITERNUM != 103 & x$ITERNUM != 108 & x$ITERNUM != 113 & x$ITERNUM != 119 & x$ITERNUM != 43 & x$ITERNUM != 48 & x$ITERNUM != 54 & x$ITERNUM != 59 & x$ITERNUM != 64 & x$ITERNUM != 69 & x$ITERNUM != 75 & x$ITERNUM != 80)
x_up = mean(x$METIME) + 2*sd(x$METIME)
x_dn = mean(x$METIME) - 2*sd(x$METIME)
binsize=20
x = subset(x, x$METIME >= x_dn & x$METIME <= x_up)
nbins <- ceiling((max(x$METIME)-min(x$METIME)) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$METIME)
xmax <-max(x$METIME)
ymax <- max(h$counts)
ymax <- ceiling(ymax/100)*100
ymax <- max(h$counts)
ymax <- 25
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-100,xmax+100),col="blue", main='ET frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_et_hist_v5.eps")
x <- subset(x, x$ITERNUM != 10 & x$ITERNUM != 16 & x$ITERNUM != 82 & x$ITERNUM != 87 & x$ITERNUM != 92 & x$ITERNUM != 98 & x$ITERNUM != 103 & x$ITERNUM != 108 & x$ITERNUM != 113 & x$ITERNUM != 119 & x$ITERNUM != 43 & x$ITERNUM != 48 & x$ITERNUM != 54 & x$ITERNUM != 59 & x$ITERNUM != 64 & x$ITERNUM != 69 & x$ITERNUM != 75 & x$ITERNUM != 80)
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
ymax <- 40
plot(h, freq=TRUE,ylim=c(0,ymax), xlim=c(xmin-100,xmax+300),col="blue", main='ET frequency on INC16384', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='ET (ms)', ylab=expression('Frequency'))
dev.off()


