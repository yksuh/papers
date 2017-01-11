x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
h = hist(x$PRTIME, breaks = 100, plot=F)
postscript("4_sec_pt_hist.eps")
counts = h$counts
breaks = h$breaks[0:(length(h$breaks)-1)]
plot(breaks, counts, xaxt='n', yaxt='n', col="green", log='y', type='h', lwd=5, lend=2, main='', xlab='PT (ms)', ylab=expression('Frequency'))
delta=max(breaks)-min(breaks)
xaxtl <- seq(0,ceiling(max(breaks)+delta/2),by=(ceiling((delta/2)/100)*5))
axis(side=1, at=xaxtl, labels=xaxtl)
axt <- seq(0,1000,by=10)
axis(side=2, at=axt, labels=axt)
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
h = hist(x$PRTIME, breaks = 100, plot=F)
postscript("8_sec_pt_hist.eps")
counts = h$counts
breaks = h$breaks[0:(length(h$breaks)-1)]
plot(breaks, counts, xaxt='n', yaxt='n', col="green", log='y', type='h', lwd=5, lend=2, main='', xlab='PT (ms)', ylab=expression('Frequency'))
delta=max(breaks)-min(breaks)
xaxtl <- seq(0,ceiling(max(breaks)+delta/2),by=(ceiling((delta/2)/100)*5))
axis(side=1, at=xaxtl, labels=xaxtl)
axt <- seq(0,1000,by=10)
axis(side=2, at=axt, labels=axt)
dev.off()


x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
h = hist(x$PRTIME, breaks = 100, plot=F)
postscript("16_sec_pt_hist.eps")
counts = h$counts
breaks = h$breaks[0:(length(h$breaks)-1)]
plot(breaks, counts, xaxt='n', yaxt='n', col="green", log='y', type='h', lwd=5, lend=2, main='', xlab='PT (ms)', ylab=expression('Frequency'))
delta=max(breaks)-min(breaks)
xaxtl <- seq(0,ceiling(max(breaks)+delta/2),by=(ceiling((delta/2)/100)*5))
axis(side=1, at=xaxtl, labels=xaxtl)
axt <- seq(0,1000,by=10)
axis(side=2, at=axt, labels=axt)
dev.off()

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
h = hist(x$PRTIME, breaks = 100, plot=F)
postscript("32_sec_pt_hist.eps")
counts = h$counts
breaks = h$breaks[0:(length(h$breaks)-1)]
plot(breaks, counts, xaxt='n', yaxt='n', col="green", log='y', type='h', lwd=5, lend=2, main='', xlab='PT (ms)', ylab=expression('Frequency'))
delta=max(breaks)-min(breaks)
xaxtl <- seq(0,ceiling(max(breaks)+delta/2),by=(ceiling((delta/2)/100)*5))
axis(side=1, at=xaxtl, labels=xaxtl)
axt <- seq(0,1000,by=10)
axis(side=2, at=axt, labels=axt)
dev.off()
