x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=1
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,500),xlim=c(xmin,xmax),
col="blue", main='PT frequency on PUT1', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
nrow(x)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,600),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT2', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,300),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT4', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

#x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <= 300)
#max(x$METIME)
#min(x$METIME)

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,350),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT8', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,300),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT16', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,250),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT32', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("64_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,200),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT64', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("128_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
nrow(x)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,80),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT128', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("256_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,50),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT256', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-1
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,50),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT512', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
#xmin <-min(x$PRTIME)-2
#xmax <-max(x$PRTIME)+3
#h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+3
binsize=2
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,60),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT1024', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2048_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 1000)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
#xmin <-min(x$PRTIME)-1
#xmax <-max(x$PRTIME)+2
#h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+2
binsize=2
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,40),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT2048', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4096_sec_pt_hist2.eps")
x <- subset(x, x$ITERNUM <= 300)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-15
xmax <-max(x$PRTIME)+16
binsize=10
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,50),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT4096', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_pt_hist_out1.eps")
x <- subset(x, x$ITERNUM <= 40)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=10
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-12
xmax <-max(x$PRTIME)+15
h = hist(x$PRTIME, breaks=seq(xmin,xmax,by=binsize),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,15),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT8192 in Apr 2015', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8192_sec_pt_hist_out2.eps")
x <- subset(x, x$ITERNUM > 40)
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
max(x$PRTIME)
min(x$PRTIME)
#xmin <-min(x$PRTIME)-12
#xmax <-max(x$PRTIME)+11
#binsize=10
#h = hist(x$PRTIME, breaks=seq(xmin,xmax,by=binsize),right=F,plot=F)
xmin <-min(x$PRTIME)-12
xmax <-max(x$PRTIME)+11
binsize=10
h = hist(x$PRTIME, breaks=seq(xmin,xmax,by=binsize),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,35),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT8192 in Nov 2015', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16384_sec1.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_pt_hist_out1.eps")
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=20
max(x$PRTIME)
min(x$PRTIME)
xmin <-min(x$PRTIME)-37
xmax <-max(x$PRTIME)+25
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,14),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT16384 in Apr 2015', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="16384_sec2.dat",head=TRUE,sep="\t")
setEPS()
postscript("16384_sec_pt_hist_out2.eps")
x_up = mean(x$PRTIME) + 5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 5*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=20
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-49
xmax <-max(x$PRTIME)+42
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,50),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT16384 in Nov 2015', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()
