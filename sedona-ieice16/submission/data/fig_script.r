x = read.csv(file="all_spec_before.dat",head=TRUE,sep="\t")
y = read.csv(file="all_spec_after.dat",head=TRUE,sep="\t")
specCpu.std <- cbind(ORG_ET_std=(x$STD_ET),FIND_ET_std=(y$STD_PT))
specCpu.std <- round(specCpu.std,1)
setEPS()
postscript("spec_std.eps")
b<-barplot(t(specCpu.std[1:31,]), log="y", yaxt="n", main="", beside=TRUE, 
names.arg=c("400","401","403","410","416","429","433","434","435","436","437",
	    "444","445","447","450","453","454","456","458","459","462","464",
	    "465","470","471","473","481","482","483","998","999"), 
	las=2,xlab="SPEC CPU2006",ylab="Standard deviation in log scale (msec)", ylim=c(0.1,8192), col=c("tan2","blue"))
#legend(x=85.1,y=8000, c("ORG: ET", "FIND: PT"),cex=.8, col=c("tan2","blue"),pch=c(22,0,0))
legend(x=9,y=8000, c("ORG-ET", "FIND-PT"),cex=.8, col=c("tan2","blue"),pch=c(22,0,0))
ticks <- seq(-1, 16, by=1)
axis(2, at=c(-1,1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192,16384))
dev.off()

x = read.csv(file="all_spec_before.dat",head=TRUE,sep="\t")
y = read.csv(file="all_spec_after.dat",head=TRUE,sep="\t")
specCpu.std <- cbind(ORG_ET_re=(x$RE_ET),FIND_ET_re=(y$RE_PT))
#specCpu.std <- round(specCpu.std,1)
setEPS()
postscript("spec_re.eps")
b <- barplot(t(specCpu.std[1:31,]), log="y", yaxt="n", main="", beside=TRUE, 
names.arg=c("400","401","403","410","416","429","433","434","435","436","437","444", "445","447","450","453","454","456","458","459","462","464","465","470","471","473","481","482","483","998","999"), 
las=2,xlab="SPEC CPU2006",ylab="Relative error in log scale (msec)", ylim=c(0.000001,1), col=c("tan2","blue"))
legend(x=3,y=0.5, c("ORG-ET", "FIND-PT"),cex=.8, col=c("tan2","blue"),pch=c(22,0,0))
ticks <- seq(-6, 0, by=1)
labels <- sapply(ticks, function(i) as.expression(bquote(10^ .(i))))
axis(2, at=c(0.000001,0.00001,0.0001,0.001,0.01,0.1,1), labels=labels)
dev.off()


### 128 sec 
### before protocol
x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
min(x$METIME) # 128245
old_xmin <- 120000
max(x$METIME) #163913
old_xmax <- 170000
mean(x$METIME)
y <- subset(x, x$METIME < 160000) 
max(y$METIME)
#x <- subset(x, x$ITERNUM != 90 & x$ITERNUM != 202) 
sd(x$METIME)/mean(x$METIME)
setEPS()
postscript("128_sec_et_old.eps")
plot(x$METIME, xlim=c(0,max(x$ITERNUM)), ylim=c(old_xmin, old_xmax), 
	pch=1, main='', 
	xlab='Iteration', ylab='Elapsed Time (msec)')
dev.off()

x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
min(x$METIME)
old_xmin <- 126000
max(x$METIME)
old_xmax <- 166000
mean(x$METIME)
setEPS()
postscript("128_sec_et_old_hist.eps")
binsize=1000
max(x$METIME) #533145 
min(x$METIME) #512998
par(ylog=TRUE)
nbins <- ceiling((old_xmax-old_xmin) / binsize)
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
h$counts[h$counts == 0] <- NA
#plot(h$counts, log="xy", pch=20, col="blue", 
 #   main="Log-normal distribution", 
  #  xlab="Value", ylab="Frequency") 
#plot(h, ylim=c(0,800), xaxt='n',freq=TRUE,xlim=c(old_xmin,old_xmax),col="green", 
#plot(mydata_hist$count, log="y", type='h', lwd=10, lend=2)
#plot(h$counts,log="y", type='h',xaxt='n',xlim=c(old_xmin,old_xmax),col="green", 
#plot(h$breaks[-1], h$counts, log='xy', lwd=10, lend=2,type='h',xaxt='n',xlim=c(old_xmin,old_xmax),col="green", 
plot(h$mids[-37], h$counts, log='xy', lwd=13, lend=2,type='h',xaxt='n',xlim=c(old_xmin,old_xmax),col="green", 
main='', sub=paste("(n=",nrow(x),", bin_size=1,000 msec)",sep=""), 
xlab='Elapsed Time (ET) (msec)', ylab=expression('Frequency'))
legend(140000, 730, c(as.expression(bquote("standard deviation = 1,730 msec")), 
		      as.expression(bquote("relative error = 0.01"))
))
xaxtl <- seq(old_xmin,old_xmax,by=1000)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

#text(150000, 730, "std. dev.=1,730.3 msec",adj = 0)
#text(150000, 700, c("rel. err.=1.3",exp({^(-2)}),adj = 0)
min(x$METIME)
max(x$METIME)
mean(x$METIME)
sd(x$METIME)
sd(x$METIME)/mean(x$METIME)

expression())
### after protocol on PT
x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
x <- subset(x, 
x$ITERNUM != 75 & x$ITERNUM != 104 & x$ITERNUM != 186 & x$ITERNUM != 216 &  
x$ITERNUM != 298 & x$ITERNUM != 328 & x$ITERNUM != 366 & x$ITERNUM != 410 & 
x$ITERNUM != 439 & x$ITERNUM != 522 & x$ITERNUM != 551 & 
x$ITERNUM != 634 & x$ITERNUM != 663 & x$ITERNUM != 746 & x$ITERNUM != 775
### x$ITERNUM != 451 
#---------- --------------- ---------- ----------
#     10774 proc_monitor 	  451	     202
#     12646 sshd 		  451	      13
#     12655 sshd 		  451	      12
#     12648 grep 		  451	       6
#     12657 grep 		  451	       5
#     10804 java 		  451	       3
#     12647 sshd 		  451	       3
#     12656 sshd 		  451	       3
#     12661 grep 		  451	       1
#     12652 grep 		  451	       1
#     12658 bash 		  451	       1
#)
min(x$PRTIME)
old_xmin <- 128240
max(x$PRTIME)
old_xmax <- 128260
mean(x$PRTIME)
min(x$PRTIME)
max(x$PRTIME)
mean(x$PRTIME)
sd(x$PRTIME)## 2.6
sd(x$PRTIME)/mean(x$PRTIME)### 2.061408e-05
setEPS()
postscript("128_sec_pt_new_hist.eps")
binsize=2
par(ylog=TRUE)
nbins <- ceiling((old_xmax-old_xmin) / binsize)
h = hist(x$PRTIME, breaks=nbins, plot=F)
h$counts[h$counts == 0] <- NA
h$mids[h$mids == 128257.5] <- 128258.5
#plot(h$breaks[-1], h$counts, log='xy', ylim=c(1,200), lwd=22, lend=2,type='h',xaxt='n',xlim=c(old_xmin,old_xmax),col="blue", 
plot(h$mids, h$counts, log='xy', ylim=c(1,200), lwd=23, lend=2,type='h',xaxt='n',xlim=c(old_xmin,old_xmax),col="blue", 
main='', sub=paste("(n=",nrow(x),", bin_size=",binsize," msec)",sep=""), 
xlab='Process Time (PT) (msec)', ylab=expression('Frequency'))
legend(128253.5, 190, c(as.expression(bquote("std. dev. = 2.6 msec")), 
		      as.expression(bquote("rel. err. = 0.00002"))
))
xaxtl <- seq(old_xmin,old_xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


### after protocol on ET
x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
x <- subset(x, 
x$ITERNUM != 75 & x$ITERNUM != 104 & x$ITERNUM != 186 & x$ITERNUM != 216 &  
x$ITERNUM != 298 & x$ITERNUM != 328 & x$ITERNUM != 366 & x$ITERNUM != 410 & 
x$ITERNUM != 439 & x$ITERNUM != 522 & x$ITERNUM != 551 & 
x$ITERNUM != 634 & x$ITERNUM != 663 & x$ITERNUM != 746 & x$ITERNUM != 775
)
min(x$METIME)
old_xmin <- 128240
max(x$METIME)
old_xmax <- 128320
mean(x$METIME)
min(x$METIME)
max(x$METIME)
mean(x$METIME)
round(sd(x$METIME),1)## 3.2
sd(x$METIME)/mean(x$METIME)### 2.473316e-05
setEPS()
postscript("128_sec_et_new_hist.eps")
binsize=2
par(ylog=TRUE)
nbins <- ceiling((old_xmax-old_xmin) / binsize)
h = hist(x$METIME, breaks=nbins, plot=F)
h$counts[h$counts == 0] <- NA
h$mids[h$mids == 128303] <- 128305
plot(h$mids, h$counts, log='xy', ylim=c(1,250), lwd=11, lend=2,type='h',xaxt='n',xlim=c(old_xmin,old_xmax),col="blue", 
main='', sub=paste("(n=",nrow(x),", bin_size=",binsize," msec)",sep=""), 
xlab='Elapsed Time (ET) (msec)', ylab=expression('Frequency'))
legend(128280, 195, c(as.expression(bquote("standard deviation = 3 msec")), 
		      as.expression(bquote("relative error = 0.00002"))
))
xaxtl <- seq(old_xmin,old_xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

## 512 sec
x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_et_hist_old.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=500
max(x$METIME) #533145 
old_xmax <- 533500
min(x$METIME) #512998
old_xmin <- 512500
nbins <- ceiling((old_xmax-old_xmin)) / binsize
h = hist(x$METIME, right=F, breaks=nbins,plot=F)
plot(h, ylim=c(0,300), xaxt='n',freq=TRUE,xlim=c(512500,533500),
col="green", main='', sub=paste("(n=",nrow(x),", bin_size=",binsize,"msec)",sep=""), 
xlab='Elapsed Time (msec)', ylab=expression('Frequency'))
xaxtl <- seq(510000,540000,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
min(x$METIME)
old_xmin <- 510000
max(x$METIME)
old_xmax <- 540000
setEPS()
postscript("512_sec_et_old.eps")
plot(x$METIME, xlim=c(0,max(x$ITERNUM)), ylim=c(old_xmin, old_xmax), 
	pch=1, main='', 
	xlab='Iteration', ylab='Elapsed Time (msec)')
dev.off()

x <- subset(x, 
x$ITERNUM != 16 & x$ITERNUM != 44 & x$ITERNUM != 72 & x$ITERNUM != 100 & x$ITERNUM != 128 & x$ITERNUM != 156 & 
x$ITERNUM != 184 & x$ITERNUM != 212 & x$ITERNUM != 240 & x$ITERNUM != 268 & x$ITERNUM != 296 & x$ITERNUM != 297 
) 



x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
min(x$METIME)
old_xmin <- 510000
max(x$METIME)
old_xmax <- 540000
setEPS()
postscript("512_sec_pt_old.eps")
plot(x$PRTIME, xlim=c(0,max(x$ITERNUM)), ylim=c(old_xmin, old_xmax), 
	pch=1, main='', 
	xlab='Iterations', ylab='Process Time (msec)')
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("512_sec_pt_hist.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=5
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
plot(h, ylim=c(0,200), xaxt='n',freq=TRUE,xlim=c(min(x$PRTIME)-15,max(x$PRTIME)+28),col="blue", main='', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"msec)",sep=""), xlab='Process Time (msec)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-15,max(x$PRTIME)+28,by=15)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 300)
min(x$METIME)
max(x$METIME)
mean(x$METIME)
round(sd(x$METIME),1)
sd(x$METIME)/mean(x$METIME)
x <- subset(x, 
x$ITERNUM != 16 & x$ITERNUM != 44 & x$ITERNUM != 72 & x$ITERNUM != 100 & x$ITERNUM != 128 & x$ITERNUM != 156 & 
x$ITERNUM != 184 & x$ITERNUM != 212 & x$ITERNUM != 240 & x$ITERNUM != 268 & x$ITERNUM != 296 & x$ITERNUM != 297 
) 
x.sub <- subset(x, x$ITERNUM <= 300)
uol = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
dol = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x.ref = subset(x.sub, x.sub$METIME <= uol & x.sub$METIME >= dol)
nrow(x.sub)
nrow(x.ref)
min(x.ref$METIME)
max(x.ref$METIME)
mean(x.ref$METIME)
round(sd(x.ref$METIME),1)
sd(x.ref$METIME)/mean(x.ref$METIME)

## 1024 sec
x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
min(x$METIME)
max(x$METIME)
mean(x$METIME)
round(sd(x$METIME),1)
sd(x$METIME)/mean(x$METIME)
#x <- subset(x, 
#x$ITERNUM != 13 & x$ITERNUM != 27 & x$ITERNUM != 41 & x$ITERNUM != 55 & x$ITERNUM != 69 & 
#x$ITERNUM != 83 & x$ITERNUM != 88 & x$ITERNUM != 97 & x$ITERNUM != 111 & x$ITERNUM != 125 & 
#x$ITERNUM != 135 & x$ITERNUM != 149 & x$ITERNUM != 163 & x$ITERNUM != 177 & x$ITERNUM != 191 & 
#x$ITERNUM != 205 & x$ITERNUM != 219 & x$ITERNUM != 233 & x$ITERNUM != 247 & x$ITERNUM != 252 &
#x$ITERNUM != 261 & x$ITERNUM != 276 & x$ITERNUM != 290 & x$ITERNUM != 298
#)
x <- subset(x, 
x$ITERNUM != 27 & x$ITERNUM != 88 & x$ITERNUM != 252 & x$ITERNUM != 276)  
x.sub <- subset(x, x$ITERNUM <= 300)
uol = mean(x.sub$METIME) + 2*sd(x.sub$METIME)
dol = mean(x.sub$METIME) - 2*sd(x.sub$METIME)
x.ref = subset(x.sub, x.sub$METIME <= uol & x.sub$METIME >= dol)
nrow(x.sub)
nrow(x.ref)
min(x.ref$METIME)
max(x.ref$METIME)
mean(x.ref$METIME)
round(sd(x.ref$METIME),1)
sd(x.ref$METIME)/mean(x.ref$METIME)

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1024_sec_pt_hist.eps")
x <- subset(x, x$ITERNUM <= 300)
binsize=5
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, right=F, breaks=nbins,plot=F)
xmin <-min(x$PRTIME)-16
xmax <-max(x$PRTIME)+19
plot(h, ylim=c(0,140), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on PUT1024', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=20)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


######## find vs. raw #####
x = read.csv(file="all_spec_before.dat",head=TRUE,sep="\t", row.names=NULL)


plot(h, ylim=c(0,140), xaxt='n',freq=TRUE,xlim=c(xmin,xmax),col="green", main='PT frequency on PUT1024', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), xlab='PT (ms)', ylab=expression('Frequency'))

b <- barplot(t(specCpu.std[1:31,]), log="y", yaxt="n", main="", beside=TRUE, 
names.arg=c("400","401","403","410","416","429","433","434","435","436","437","444", "445","447","450","453","454","456","458","459","462","464","465","470","471","473","481","482","483","998","999"), 
las=2,xlab="SPEC CPU2006",ylab="Standard deviation in log scale (msec)", ylim=c(0.1,100000), col=c("tan2","blue"))
legend(x=1,y=35000, c("ET", "PT"),cex=.8, col=c("tan2","blue"),pch=c(22,0,0))


b <- barplot(t(specCpu.std[1:31,]), log="y", yaxt="n", main="", beside=TRUE, 
names.arg=c("400","401","403","410","416","429","433","434","435","436","437","444", "445","447","450","453","454","456","458","459","462","464","465","470","471","473","481","482","483","998","999"), 
las=2,xlab="SPEC CPU2006",ylab="Standard deviation in log scale (msec)", ylim=c(0.1,100000), col=c("tan2","blue"))
legend(x=1,y=35000, c("ET", "PT"),cex=.8, col=c("tan2","blue"),pch=c(22,0,0))
#ticks <- seq(-1, 16, by=1)
#labels <- sapply(ticks, function(i) as.expression(bquote(2^ .(i))))
#axis(2, at=c(-1, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536), labels=labels)
axis(2, at=c(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536))
dev.off()

