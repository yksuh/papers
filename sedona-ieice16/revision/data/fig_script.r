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
re <- sd(x$METIME)/mean(x$METIME)
setEPS()
postscript("128_sec_et_old.eps")
plot(x$METIME, xlim=c(0,max(x$ITERNUM)), ylim=c(old_xmin, old_xmax), 
	pch=1, main='', 
	xlab='Iteration', ylab='Elapsed Time (msec)')
options(scipen = 999)
legend(380, 171500, c(as.expression(paste("# of total samples = ",nrow(x))), 
		    as.expression(paste("standard deviation = ",round(sd(x$METIME),1),"msec")), 
		    as.expression(paste("relative error = ",round(re,5)))
))
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
#
)
min(x$PRTIME)
old_xmin <- 120000
max(x$PRTIME)
old_xmax <- 170000
mean(x$PRTIME)
min(x$PRTIME)
max(x$PRTIME)
mean(x$PRTIME)
sd(x$PRTIME)## 2.6
re <- sd(x$PRTIME)/mean(x$PRTIME)### 2.061408e-05
postscript("128_sec_pt_new.eps")
plot(x$PRTIME, xlim=c(0,max(x$ITERNUM)), ylim=c(old_xmin, old_xmax), 
	pch=1, main='', 
	xlab='Iteration', ylab='Process Time (msec)'
)
options(scipen = 999)
legend(380, 171500, c(as.expression(paste("# of retained samples = ",nrow(x))), 
		    as.expression(paste("standard deviation = ",round(sd(x$PRTIME),1),"msec")), 
		    as.expression(paste("relative error = ",round(re,5)))
))
dev.off()

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

### Fig. 4(b)
x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
x.sub <- subset(x, x$ITERNUM <= 800)
uol = mean(x.sub$PRTIME) + 2*sd(x.sub$PRTIME)
dol = mean(x.sub$PRTIME) - 2*sd(x.sub$PRTIME)
x.ol = subset(x, x.sub$PRTIME > uol | x.sub$PRTIME < dol)
x.ref = subset(x, x.sub$PRTIME <= uol & x.sub$PRTIME >= dol)
nrow(x)-nrow(x.ref)
min(x.ref$PRTIME)
max(x.ref$PRTIME)
mean(x.ref$PRTIME)
sd(x.ref$PRTIME)
sd(x.ref$PRTIME)/mean(x.ref$PRTIME) 
setEPS()
postscript("dual_et_put256_empv4.eps")
min(x$METIME)#128247
max(x$METIME)#128811
x1 <- subset(x, x$ITERNUM %% 2 == 1)
x2 <- subset(x, x$ITERNUM %% 2 == 0)
x1$ITERNUM <- round(x1$ITERNUM/2)
x2$ITERNUM <- x2$ITERNUM/2
median(x1$METIME)#128250
min_val <- 120000
max_val <- 170000
#plot(x1$METIME, x2$METIME, xlim=c(min_val, max_val), ylim=c(min_val, max_val), xlab='1st Half\'s ET (ms)', main='ETs of dual-PUT256 (simulated using PUT128 with 800 samples)', ylab='2nd Half\'s ET (ms)')
plot(x1$METIME, x2$METIME, xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
xlab='Odd Sample\'s ET (ms)', main='', ylab='Even Sample\'s ET (ms)')
#text(128251, 128811, label="rhn_check, rhnsd captured", pos = 4)#85
#text(128250, 128634, label="rhn_check, rhnsd captured", pos = 4)#89
dev.off()

### Fig. 4(c)
x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM != 75 & x$ITERNUM != 634)
min(x$METIME)
max(x$METIME)
min_val <- 128200
max_val <- 129500
setEPS()
postscript("zooming_in_dual_et_put256_empv4.eps")
x1 <- subset(x, x$ITERNUM %% 2 == 1)
x2 <- subset(x, x$ITERNUM %% 2 == 0)
x1$ITERNUM <- round(x1$ITERNUM/2)
x2$ITERNUM <- x2$ITERNUM/2;
plot(x1$METIME, x2$METIME, 
 xlim=c(min_val, max_val), 
 ylim=c(min_val, max_val), 
xlab='Odd Sample\'s ET (ms)', main='', ylab='Even Sample\'s ET (ms)')
dev.off()

## Fig. 4 (d)
x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM != 75 & x$ITERNUM != 634)
min(x$METIME)
median(x$METIME)
max(x$METIME)
min_val <- 128240
max_val <- 128260
setEPS()
postscript("dual_et_clump_put256_empv4.eps")
x1 <- subset(x, x$ITERNUM %% 2 == 1)
x2 <- subset(x, x$ITERNUM %% 2 == 0)
x1$ITERNUM <- round(x1$ITERNUM/2)
x2$ITERNUM <- x2$ITERNUM/2;
plot(x1$METIME, x2$METIME, 
 xlim=c(min_val, max_val), 
 ylim=c(min_val, max_val), 
xlab='Odd Sample\'s ET (ms)', main='', ylab='Even Sample\'s ET (ms)')
dev.off()
