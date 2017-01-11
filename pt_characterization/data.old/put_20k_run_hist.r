x = read.csv(file="put1_20k.txt",head=TRUE,sep="\t")
setEPS()
postscript("put1_20k_hist.eps")
h = hist(x$PRTIME, right=F,breaks=max(x$PRTIME)-min(x$PRTIME)+1,plot=F)
binsize=1
plot(h, axes = TRUE,freq=TRUE,ylim=c(0,12000),xlim=c(min(x$PRTIME)-1,max(x$PRTIME)+1),col="green", main='PT frequency on PUT1_20K', 
sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""), 
xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(min(x$PRTIME)-1,max(x$PRTIME)+1,by=5)
axis(side=1, at=xaxtl, labels=xaxtl)
#axis(side=1, at=seq(min(h$mids)-1,max(h$mids)+1,1), labels=seq(min(x$PRTIME),max(x$PRTIME)+1,by=1))
dev.off()

x = read.csv(file="put1_20k.txt",head=TRUE,sep="\t")
setEPS()
postscript("put1_20k_hist2.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=1
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,12000),xlim=c(xmin,xmax),col="blue", main='PT frequency on PUT1_20K', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

x = read.csv(file="put2_20k.txt",head=TRUE,sep="\t")
#x = subset(org, org$PRTIME >= 2000)
#y = subset(org, org$PRTIME < 2000)
#x = subset(x, x$PRTIME < 2023)
nrow(x)
setEPS()
postscript("put2_20k_hist.eps")
binsize=2
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+2
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,14000),xlim=c(xmin,xmax),col="green", main='PT frequency on PUT1_20K', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="put2_20k.txt",head=TRUE,sep="\t")
setEPS()
postscript("put2_20k_hist2.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=1
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+3
h = hist(x$PRTIME, breaks=seq(xmin,xmax),right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,14000),xlim=c(xmin,xmax),col="blue", 
main='PT frequency on PUT2_20K', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=1)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

org = read.csv(file="put2_20k.dat",head=TRUE,sep="\t")
c0 <- cbind("SAMPLE_SIZE","STD")
x_1k = subset(org, org$ITERNUM <= 1000) 
x1k_std <- sd(x_1k$PRTIME)
c1 <- cbind(1000, x1k_std)
x_2k = subset(org, org$ITERNUM <= 2000) 
x2k_std <- sd(x_2k$PRTIME)
c2 <- cbind(2000, x2k_std)
x_3k = subset(org, org$ITERNUM <= 3000) 
x3k_std <- sd(x_3k$PRTIME)
c3 <- cbind(3000, x3k_std)
x_4k = subset(org, org$ITERNUM <= 4000) 
x4k_std <- sd(x_4k$PRTIME)
c4 <- cbind(4000, x4k_std)
x_5k = subset(org, org$ITERNUM <= 5000) 
x5k_std <- sd(x_5k$PRTIME)
c5 <- cbind(5000, x5k_std)
x_6k = subset(org, org$ITERNUM <= 6000) 
x6k_std <- sd(x_6k$PRTIME)
c6 <- cbind(6000, x6k_std)
x_7k = subset(org, org$ITERNUM <= 7000) 
x7k_std <- sd(x_7k$PRTIME)
c7 <- cbind(7000, x7k_std)
x_7k = subset(org, org$ITERNUM <= 7000) 
x7k_std <- sd(x_7k$PRTIME)
c7 <- cbind(7000, x7k_std)
x_8k = subset(org, org$ITERNUM <= 8000) 
x8k_std <- sd(x_8k$PRTIME)
c8 <- cbind(8000, x8k_std)
x_9k = subset(org, org$ITERNUM <= 9000) 
x9k_std <- sd(x_9k$PRTIME)
c9 <- cbind(9000, x9k_std)
x_10k = subset(org, org$ITERNUM <= 10000) 
x10k_std <- sd(x_10k$PRTIME)
c10 <- cbind(10000, x10k_std)
x_11k = subset(org, org$ITERNUM <= 11000) 
x11k_std <- sd(x_11k$PRTIME)
c11 <- cbind(11000, x11k_std)
x_12k = subset(org, org$ITERNUM <= 12000) 
x12k_std <- sd(x_12k$PRTIME)
c12 <- cbind(12000, x12k_std)
x_13k = subset(org, org$ITERNUM <= 13000) 
x13k_std <- sd(x_13k$PRTIME)
c13 <- cbind(13000, x13k_std)
x_14k = subset(org, org$ITERNUM <= 14000) 
x14k_std <- sd(x_14k$PRTIME)
c14 <- cbind(14000, x14k_std)
x_15k = subset(org, org$ITERNUM <= 15000) 
x15k_std <- sd(x_15k$PRTIME)
c15 <- cbind(15000, x15k_std)
x_16k = subset(org, org$ITERNUM <= 16000) 
x16k_std <- sd(x_16k$PRTIME)
c16 <- cbind(16000, x16k_std)
x_17k = subset(org, org$ITERNUM <= 17000) 
x17k_std <- sd(x_17k$PRTIME)
c17 <- cbind(17000, x17k_std)
x_18k = subset(org, org$ITERNUM <= 18000) 
x18k_std <- sd(x_18k$PRTIME)
c18 <- cbind(18000, x18k_std)
x_19k = subset(org, org$ITERNUM <= 19000) 
x19k_std <- sd(x_19k$PRTIME)
c19 <- cbind(19000, x19k_std)
x_20k = subset(org, org$ITERNUM <= 20000) 
x20k_std <- sd(x_20k$PRTIME)
c20 <- cbind(20000, x20k_std)
total <- rbind(c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20)
write.table(total, "put2_20k_std.dat", append=TRUE, sep="\t", row.names=FALSE, col.names=FALSE) 


x_2k = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_3k = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_4k = mean(x$PRTIME) + 2*sd(x$PRTIME)

write.table(x, "put2_20k_std.dat", sep="\t", row.names=FALSE, col.names=FALSE) 

#x = read.csv(file="4_sec_20k.dat",head=TRUE,sep="\t")
#x <- x$ITERNUM
#write.table(x, "put4_iter.dat", sep="\t", row.names=FALSE, col.names=FALSE) 
#x = read.csv(file="8_sec_20k.dat",head=TRUE,sep="\t")
#x <- x$ITERNUM
#write.table(x, "put8_iter.dat", sep="\t", row.names=FALSE, col.names=FALSE) 

----
x = read.csv(file="4_sec_20k.dat",head=TRUE,sep="\t")
setEPS()
postscript("put4_20k_hist.eps")
binsize=2
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+3
nbins = (xmax-xmin+1)/binsize
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,10000),xlim=c(xmin,xmax),col="green", main='PT frequency on PUT4_20K by EMPv4', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="4_sec_20k.dat",head=TRUE,sep="\t")
setEPS()
postscript("put4_20k_hist2.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=2
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-4
xmax <-max(x$PRTIME)+7
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,10000),xlim=c(xmin,xmax),col="blue", 
main='PT frequency on PUT4_20K by EMPv5', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()

-----

x = read.csv(file="8_sec_20k.dat",head=TRUE,sep="\t")
setEPS()
postscript("put8_20k_hist.eps")
binsize=2
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-2
xmax <-max(x$PRTIME)+3
nbins = (xmax-xmin+1)/binsize
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,10000),xlim=c(xmin,xmax),col="green", main='PT frequency on PUT8_20K by EMPv4', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()


x = read.csv(file="8_sec_20k.dat",head=TRUE,sep="\t")
setEPS()
postscript("put8_20k_hist2.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
binsize=2
min(x$PRTIME)
max(x$PRTIME)
xmin <-min(x$PRTIME)-3
xmax <-max(x$PRTIME)+7
nbins <- ceiling((max(x$PRTIME)-min(x$PRTIME)) / binsize)
h = hist(x$PRTIME, breaks=nbins,right=F,plot=F)
max(h$counts)
plot(h, xaxt='n', freq=TRUE,ylim=c(0,10000),xlim=c(xmin,xmax),col="blue", 
main='PT frequency on PUT8_20K by EMPv5', sub=paste("(n=",nrow(x),", bin_size=",binsize,"ms)",sep=""),   xlab='PT (ms)', ylab=expression('Frequency'))
xaxtl <- seq(xmin,xmax,by=binsize)
axis(side=1, at=xaxtl, labels=xaxtl)
dev.off()
