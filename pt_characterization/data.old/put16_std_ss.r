x = read.csv(file="16_sec_1k.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_1k_hist.eps")
binsize=2
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
max(x$PRTIME)
min(x$PRTIME)
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
xmin <- min(x$PRTIME)-3
xmax <- max(x$PRTIME)+3
plot(h, xaxt='n', freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 500), col="green", main='PT frequency on PUT16_1K', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()
## empv5
x = read.csv(file="16_sec_1k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
setEPS()
postscript("16_sec_1k_hist2.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
max(h$counts)
max(x$PRTIME)
min(x$PRTIME)
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-1,max(x$PRTIME)+3),
ylim=c(0, 300), col="blue", main='PT frequency on PUT16_1K (by EMPv5)', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

#empv4
x = read.csv(file="16_sec_2k.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_2k_hist.eps")
binsize=2
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
max(x$PRTIME)
min(x$PRTIME)
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
xmin <- min(x$PRTIME)-10
xmax <- max(x$PRTIME)+17
plot(h, xaxt='n', freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 800), col="green", main='PT frequency on PUT16_2K', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()
#empv5
x = read.csv(file="16_sec_2k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
setEPS()
postscript("16_sec_2k_hist2.eps")
binsize=1
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
max(x$PRTIME)
min(x$PRTIME)
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
xmin <- min(x$PRTIME)-4
xmax <- max(x$PRTIME)+8
plot(h, xaxt='n', freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+8),
ylim=c(0, 500), col="blue", main='PT frequency on PUT16_2K (by EMPv5)', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16_sec_4k.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_4k_hist.eps")
binsize=2
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
xmin <- min(x$PRTIME)-11
xmax <- max(x$PRTIME)+15
plot(h, xaxt='n',freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 2000), col="green", main='PT frequency on PUT16_4K', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


#empv5
x = read.csv(file="16_sec_4k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
setEPS()
postscript("16_sec_4k_hist2.eps")
binsize=1
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
xmin <- min(x$PRTIME)-4
xmax <- max(x$PRTIME)+8
plot(h, xaxt='n',freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 1000), col="blue", main='PT frequency on PUT16_4K (by EMPv5)', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="16_sec_8k.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_8k_hist.eps")
binsize=2
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
xmin <- min(x$PRTIME)-11
xmax <- max(x$PRTIME)+10
plot(h, xaxt='n',freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 4000), col="green", main='PT frequency on PUT16_8K', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

#empv5
x = read.csv(file="16_sec_8k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
setEPS()
postscript("16_sec_8k_hist2.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
max(h$counts)
max(x$PRTIME)
min(x$PRTIME)
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+8),
ylim=c(0, 2000), col="blue", main='PT frequency on PUT16_8K (by EMPv5)', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16_sec_16k.dat",head=TRUE,sep="\t")
sd(x$PRTIME)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
sd(x$PRTIME)
x = read.csv(file="16_sec_16k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
sd(x$PRTIME)

x = read.csv(file="16_sec_16k.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_16k_hist.eps")
binsize=2
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
xmin <- min(x$PRTIME)-11
xmax <- max(x$PRTIME)+16
plot(h, xaxt='n',freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 7000), col="green", main='PT frequency on PUT16_16K', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

#empv5
x = read.csv(file="16_sec_16k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
setEPS()
postscript("16_sec_16k_hist2.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
max(h$counts)
max(x$PRTIME)
min(x$PRTIME)
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+9),
ylim=c(0, 4000), col="blue", main='PT frequency on PUT16_16K (by EMPv5)', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()

x = read.csv(file="16_sec_32k.dat",head=TRUE,sep="\t")
sd(x$PRTIME)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
sd(x$PRTIME)
x = read.csv(file="16_sec_32k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
sd(x$PRTIME)

x = read.csv(file="16_sec_32k.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_32k_hist.eps")
binsize=2
nbins = (max(x$PRTIME)-min(x$PRTIME)+1)/binsize
h = hist(x$PRTIME, right=F,breaks=nbins,plot=F)
max(h$counts)
min(x$PRTIME)
max(x$PRTIME)
xmin <- min(x$PRTIME)-1
xmax <- max(x$PRTIME)+5
plot(h, xaxt='n',freq=TRUE,xlim=c(xmin,xmax),
ylim=c(0, 14000), col="green", main='PT frequency on PUT16_32K', 
sub=paste("(n=",nrow(x)+1,", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

#empv5
x = read.csv(file="16_sec_32k.dat",head=TRUE,sep="\t")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
setEPS()
postscript("16_sec_32k_hist2.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
max(h$counts)
max(x$PRTIME)
min(x$PRTIME)
plot(h, axes = TRUE,freq=TRUE,xlim=c(min(x$PRTIME)-4,max(x$PRTIME)+9),
ylim=c(0, 8000), col="blue", main='PT frequency on PUT16_32K (by EMPv5)', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
dev.off()
