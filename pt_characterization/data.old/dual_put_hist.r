x = read.csv(file="new_dual2_PUT2048.dat",head=TRUE,sep="\t")
ymax <- max(x$METIME)
ymax#1026508


x = read.csv(file="new_dual1_PUT4096.dat",head=TRUE,sep="\t")
sd(x$METIME)
setEPS()
postscript("rc_off_dual1_put4096.eps")
xmin<- min(x$METIME)
xmin#2052469
xmax<- max(x$METIME)
xmax#2052652
plot(x$ITERNUM, x$METIME, ylim=c(2052400, 2052900), 
xlab='Iterations', main='Measured times in the first half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

y = read.csv(file="new_dual2_PUT4096.dat",head=TRUE,sep="\t")
sd(y$METIME)
setEPS()
postscript("rc_off_dual2_put4096.eps")
ymin<- min(y$METIME)
ymin#2052472
ymax<- max(y$METIME)
ymax#2052818
setEPS()
plot(y$ITERNUM, y$METIME, ylim=c(2052400, 2052900), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="new_dual1_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("rc_off_dual1_put2048.eps")
ymin<- min(x$METIME)
ymin#1026254
ymax <- max(x$METIME)
ymax#1026342
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="new_dual1_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("rc_off_dual1_put2048_v2.eps")
ymin<- min(x$METIME)
ymin#1026254
ymax <- max(x$METIME)
ymax#1026342
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="new_dual2_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("rc_off_dual2_put2048.eps")
ymin<- min(x$METIME)
ymin#1026255
ymax <- max(x$METIME)
ymax#1026508
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the second half of dual PUT2048 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()


x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 100)
setEPS()
postscript("first_100_dual1_put4096.eps")
ymin<- min(x$METIME)
ymin#2051961
ymax <- max(x$METIME)
ymax#2053403
plot(x$ITERNUM, x$METIME, ylim=c(2051500, 2053500), 
xlab='Iterations', main='Measured times in the first half of dual PUT4096 w/ rhn check on', 
ylab=expression('Measured Time (ms)'))
dev.off()


x = read.csv(file="new_dual1_PUT4096.dat",head=TRUE,sep="\t")
sd(x$METIME)
setEPS()
postscript("new_dual1_put4096.eps")
xmin<- min(x$METIME)
xmin#2052469
xmax<- max(x$METIME)
xmax#2052652
plot(x$ITERNUM, x$METIME, ylim=c(2051500, 2053500), 
xlab='Iterations', main='Measured times in the first half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 100)
setEPS()
postscript("first_100_dual2_put4096.eps")
ymin<- min(x$METIME)
ymin#2051480
ymax <- max(x$METIME)
ymax#2083040
plot(x$ITERNUM, x$METIME, ylim=c(2051000, 2084000), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096 w/ rhn check on', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 100)
setEPS()
postscript("first_100_dual2_put4096_v2.eps")
ymin<- min(x$METIME)
ymin#2051480
ymax <- max(x$METIME)
ymax#2083040
plot(x$ITERNUM, x$METIME, ylim=c(2051500, 2053500), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096 w/ rhn check on', 
ylab=expression('Measured Time (ms)'))
dev.off()

y = read.csv(file="new_dual2_PUT4096.dat",head=TRUE,sep="\t")
sd(y$METIME)
setEPS()
postscript("new_dual2_put4096.eps")
ymin<- min(y$METIME)
ymin#2052472
ymax<- max(y$METIME)
ymax#2052818
setEPS()
plot(y$ITERNUM, y$METIME, ylim=c(2051000, 2084000), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

y = read.csv(file="new_dual2_PUT4096.dat",head=TRUE,sep="\t")
sd(y$METIME)
setEPS()
postscript("new_dual2_put4096_v2.eps")
ymin<- min(y$METIME)
ymin#2052472
ymax<- max(y$METIME)
ymax#2052818
setEPS()
plot(y$ITERNUM, y$METIME, ylim=c(2051500, 2053500), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()


x = read.csv(file="dual1_PUT2048.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 100)
setEPS()
postscript("first_100_dual1_put2048.eps")
ymin<- min(x$METIME)
ymin#1026253
ymax <- max(x$METIME)
ymax#1058126
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1060000), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048 w/ rhn check on', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT2048.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 100)
setEPS()
postscript("first_100_dual1_put2048_v2.eps")
ymin<- min(x$METIME)
ymin#1026253
ymax <- max(x$METIME)
ymax#1058126
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048 w/ rhn check on', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="new_dual1_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("new_dual1_put2048.eps")
ymin<- min(x$METIME)
ymin#1026254
ymax <- max(x$METIME)
ymax#1026342
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1060000), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="new_dual1_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("new_dual1_put2048_v2.eps")
ymin<- min(x$METIME)
ymin#1026254
ymax <- max(x$METIME)
ymax#1026342
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT2048.dat",head=TRUE,sep="\t")
x <- subset(x, x$ITERNUM <= 100)
setEPS()
postscript("first_100_dual2_put2048.eps")
ymin<- min(x$METIME)
ymin#1026254
ymax <- max(x$METIME)
ymax#1026513
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the second half of dual PUT2048 w/ rhn check on', 
ylab=expression('Measured Time (ms)'))
dev.off()


x = read.csv(file="new_dual2_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("new_dual2_put2048.eps")
ymin<- min(x$METIME)
ymin#1026255
ymax <- max(x$METIME)
ymax#1026508
plot(x$ITERNUM, x$METIME, ylim=c(1026250, 1026550), 
xlab='Iterations', main='Measured times in the second half of dual PUT2048 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT2048.dat",head=TRUE,sep="\t")
sd(x$METIME)
x = read.csv(file="dual2_PUT2048.dat",head=TRUE,sep="\t")
sd(x$METIME)

x = read.csv(file="new_dual1_PUT2048.dat",head=TRUE,sep="\t")
sd(x$METIME)
xmin<- min(x$METIME)
xmin#1026254
xmax<- max(x$METIME)
xmax#1026342
y = read.csv(file="new_dual2_PUT2048.dat",head=TRUE,sep="\t")
sd(y$METIME)
ymin<- min(y$METIME)
ymin#1026255
ymax<- max(y$METIME)
ymax#1026508
setEPS()
dataName = "new_dual_PUT2048.dat"
dataName1 = "new_dual1_PUT2048.dat"
dataName2 = "new_dual2_PUT2048.dat"
x = read.csv(file="new_dual1_PUT2048.dat",head=TRUE,sep="\t")
y = read.csv(file="new_dual2_PUT2048.dat",head=TRUE,sep="\t")
min_metime <- 1026250
max_metime <- 1026550
setEPS()
postscript("new_dual_put2048.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Measured times of dual PUT2048 w/ rhn check off', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-1026240
max_metime <-1026320
setEPS()
postscript("new_dual_put2048_trimmed.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT2048 w/ rhn check off', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
sd(x$METIME)
x = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
sd(x$METIME)

x = read.csv(file="new_dual1_PUT4096.dat",head=TRUE,sep="\t")
sd(x$METIME)
setEPS()
postscript("new_dual1_put4096.eps")
xmin<- min(x$METIME)
xmin#2052469
xmax<- max(x$METIME)
xmax#2052652
plot(x$ITERNUM, x$METIME, ylim=c(2052400, 2052900), 
xlab='Iterations', main='Measured times in the first half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()
y = read.csv(file="new_dual2_PUT4096.dat",head=TRUE,sep="\t")
sd(y$METIME)
setEPS()
postscript("new_dual2_put4096.eps")
ymin<- min(y$METIME)
ymin#2052472
ymax<- max(y$METIME)
ymax#2052818
setEPS()
plot(y$ITERNUM, y$METIME, ylim=c(2052400, 2052900), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096 w/ rhn check off', 
ylab=expression('Measured Time (ms)'))
dev.off()

dataName = "new_dual_PUT4096.dat"
dataName1 = "new_dual1_PUT4096.dat"
dataName2 = "new_dual2_PUT4096.dat"
x = read.csv(file="new_dual1_PUT4096.dat",head=TRUE,sep="\t")
y = read.csv(file="new_dual2_PUT4096.dat",head=TRUE,sep="\t")
min_metime <- 2052400
max_metime <- 2052900
setEPS()
postscript("new_dual_put4096.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Measured times of dual PUT4096 w/ rhn check off', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-2052450
max_metime <-2052550
setEPS()
postscript("new_dual_put4096_trimmed.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT4096 w/ rhn check off', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()


####
x = read.csv(file="dual1_PUT2.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put2.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin-18, ymax+19), 
xlab='Iterations', main='Measured times in the first half of dual PUT2', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT2.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put2.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(980, 1080), 
xlab='Iterations', main='Measured times in the second half of dual PUT2', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT2.dat",head=TRUE,sep="\t")
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT2.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
setEPS()
postscript("dual_put2_trimmed.eps")
plot(x$METIME, y$METIME, 
xlim=c(990, 1010), ylim=c(990, 1010), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT2', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual_PUT2.dat",head=TRUE,sep="\t")
min_metime <- 990
max_metime <- 1004
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
cor(x$METIME1, x$METIME2)

#x = read.csv(file="dual_PUT2.dat",head=TRUE,sep="\t")
#nrows <- nrow(x)
#x <- subset(x, x$METIME1 <= 1004)
#x <- subset(x, x$METIME2 <= 1004)
#nnormal <- nrow(x)
#nrows-nnormal
#cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT4.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_PUT4.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the first half of dual PUT4', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT4.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_PUT4.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the second half of dual PUT4', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT4.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_put4.eps")
plot(x$METIME, y$METIME, 
xlim=c(1999, 2121), ylim=c(1999, 2121), 
xlab='1st half\'s measured times (ms)', main='Measured times of dual PUT4', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT4.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_put4_trimmed.eps")
plot(x$METIME, y$METIME, 
xlim=c(1995, 2012), ylim=c(1995, 2012), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT4', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM != 211)
y = read.csv(file="dual2_PUT4.dat",head=TRUE,sep="\t")
#y <- subset(y, y$METIME < max(y$METIME))
cor(x$METIME, y$METIME)

x = read.csv(file="dual1_PUT4.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT4.dat",head=TRUE,sep="\t")
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, "dual_PUT4.dat", append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file="dual_PUT4.dat",head=TRUE,sep="\t")
nrows <- nrow(x)
x <- subset(x, x$METIME2 < 2120)
nnormal <- nrow(x)
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT8.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_PUT8.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the first half of dual PUT8', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT8.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_PUT8.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the second half of dual PUT8', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT8.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT8.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_put8.eps")
plot(x$METIME, y$METIME, 
xlim=c(4001, 4347), ylim=c(4001, 4347), 
xlab='1st half\'s measured times (ms)', main='Measured times of dual PUT8', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT8.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT8.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_put8_trimmed.eps")
plot(x$METIME, y$METIME, 
xlim=c(4000, 4015), ylim=c(4000, 4015), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT8', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT8.dat"
dataName1 = "dual1_PUT8.dat"
dataName2 = "dual2_PUT8.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
x <- subset(x, x$METIME1 < 4100)
x <- subset(x, x$METIME2 < 4100)
nnormal <- nrow(x)
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT16.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_PUT16.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(8000, ymax), 
xlab='Iterations', main='Measured times in the first half of dual PUT16', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT16.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_PUT16.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the second half of dual PUT16', 
ylab=expression('Measured Time (ms)'))
dev.off()


x = read.csv(file="dual1_PUT16.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT16.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_put16.eps")
plot(x$METIME, y$METIME, 
xlim=c(8009, 8801), ylim=c(8009, 8801), 
xlab='1st half\'s measured times (ms)', main='Measured times of dual PUT16', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT16.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT16.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_put16_trimmed.eps")
plot(x$METIME, y$METIME, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT16', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()


dataName = "dual_PUT16.dat"
dataName1 = "dual1_PUT16.dat"
dataName2 = "dual2_PUT16.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
dataName = "dual_PUT16.dat"
x = read.csv(file=dataName,head=TRUE,sep="\t")
max_metime <- 8030
x <- subset(x, x$METIME1 < max_metime)
x <- subset(x, x$METIME2 < max_metime)
nnormal <- nrow(x)
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT32.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_PUT32.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the first half of dual PUT32', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT32.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_PUT32.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax), 
xlab='Iterations', main='Measured times in the second half of dual PUT32', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT32.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT32.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
postscript("dual_PUT32.eps")
plot(x$METIME, y$METIME, 
xlim=c(16030, 16835), ylim=c(16030, 16835), 
xlab='1st half\'s measured times (ms)', main='Measured times of dual PUT32', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT32.dat",head=TRUE,sep="\t")
setEPS()
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT32.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
min_metime <- 16025
max_metime <- 16045
postscript("dual_PUT32_trimmed.eps")
plot(x$METIME, y$METIME, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT32', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT32.dat"
dataName1 = "dual1_PUT32.dat"
dataName2 = "dual2_PUT32.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
x <- subset(x, x$METIME1 < 16050)
x <- subset(x, x$METIME2 < 16050)
nnormal <- nrow(x)
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT64.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put64.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(30000, 50000), 
xlab='Iterations', main='Measured times in the first half of dual PUT64', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT64.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put64.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(30000, 50000), 
xlab='Iterations', main='Measured times in the second half of dual PUT64', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT64.dat",head=TRUE,sep="\t")
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT64.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
setEPS()
postscript("dual_put64.eps")
plot(x$METIME, y$METIME,  xlim=c(30000, 50000), ylim=c(30000, 50000), 
xlab='1st half\'s measured times (ms)', 
main='Measured times of dual PUT64', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT64.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT64.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual_put64_trimmed.eps")
min_metime <- 32000
max_metime <- 33000
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT64', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT64.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT64.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual_put64_trimmed_level1.eps")
min_metime <- 32060
max_metime <- 32080
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT64', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT64.dat"
dataName1 = "dual1_PUT64.dat"
dataName2 = "dual2_PUT64.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
x <- subset(x, x$METIME2 >= min_metime & x$METIME2 <= max_metime)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT128.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put128.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin-134, ymax+99), 
xlab='Iterations', main='Measured times in the first half of dual PUT128', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT128.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put128.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin-135, ymax+59), 
xlab='Iterations', main='Measured times in the second half of dual PUT128', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT128.dat",head=TRUE,sep="\t")
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT128.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
setEPS()
postscript("dual_put128.eps")
min_metime <- 64000
max_metime <- 67000
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', 
main='Measured times of dual PUT128', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT128.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT128.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual_put128_trimmed.eps")
min_metime <- 64000
max_metime <- 65000
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT128', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT128.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT128.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual_put128_trimmed_level1.eps")
min_metime <- 64130
max_metime <- 64155
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in measured times of dual PUT128', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT128.dat"
dataName1 = "dual1_PUT128.dat"
dataName2 = "dual2_PUT128.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
x <- subset(x, x$METIME2 >= min_metime & x$METIME2 <= max_metime)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual_PUT128.dat",head=TRUE,sep="\t")
pivot <- 64400
x <- subset(x, x$METIME1 > pivot | x$METIME2 > pivot)
nrow(x)
x

x = read.csv(file="dual1_PUT256.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put256.eps")
xmin<- min(x$METIME)
xmin
xmax <- max(x$METIME)
xmax
xmin <- xmin-77#128200
xmax <- xmax+106#129200
plot(x$ITERNUM, x$METIME, ylim=c(xmin, xmax), 
xlab='Iterations', main='Measured times in the first half of dual PUT256', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT256.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put256.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
ymin <- ymin-75#128200
ymax <- ymax+74#129200
plot(x$ITERNUM, x$METIME, ylim=c(ymin-75, ymax+74),  
xlab='Iterations', main='Measured times in the second half of dual PUT256', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT256.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT256.dat",head=TRUE,sep="\t")
min_metime <- min(xmin, ymin)
max_metime <- max(xmax, ymax)
setEPS()
postscript("dual_put256.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Measured times of dual PUT256', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-128200
max_metime <-129000
setEPS()
postscript("dual_put256_trimmed.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT256', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-128270
max_metime <-128300
setEPS()
postscript("dual_put256_trimmed_level1.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT256', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT256.dat"
dataName1 = "dual1_PUT256.dat"
dataName2 = "dual2_PUT256.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
min_metime <-128280
max_metime <-128290
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
x <- subset(x, x$METIME2 >= min_metime & x$METIME2 <= max_metime)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT256.dat.sodb12",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put256_sodb12.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(130000, 135000), 
xlab='Iterations', main='Measured times in the first half of dual PUT256 on sodb12', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT256.dat.sodb12",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put256_sodb12.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(130000, 135000),  
xlab='Iterations', main='Measured times in the second half of dual PUT256 on sodb12', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT256.dat.sodb12",head=TRUE,sep="\t")
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT256.dat.sodb12",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
setEPS()
postscript("dual_put256_sodb12.eps")
plot(x$METIME, y$METIME,  xlim=c(130000, 135000), ylim=c(130000, 135000), 
main='Measured times of dual PUT256 on sodb12', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()
setEPS()
postscript("dual_put256_trimmed_sodb12.eps")
plot(x$METIME, y$METIME,  xlim=c(130240, 130320), ylim=c(130240, 130320), 
main='Zoomed-in measured times of dual PUT256 on sodb12', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT256_sodb12.dat"
dataName1 = "dual1_PUT256.dat.sodb12"
dataName2 = "dual2_PUT256.dat.sodb12"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
x <- subset(x, x$METIME1 >= 130240 & x$METIME1 <= 130320)
x <- subset(x, x$METIME2 >= 130240 & x$METIME2 <= 130320)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT512.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put512.eps")
xmin<- min(x$METIME)
xmin
xmax <- max(x$METIME)
xmax
xmin <- xmin-161#256561
xmax <- xmax+12#257388
plot(x$ITERNUM, x$METIME, ylim=c(xmin, xmax), 
xlab='Iterations', main='Measured times in the first half of dual PUT512', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT512.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put512.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
ymin <- ymin-157#256557
ymax <- ymax+18#257382
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax),  
xlab='Iterations', main='Measured times in the second half of dual PUT512', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT512.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT512.dat",head=TRUE,sep="\t")
min_metime <- min(xmin, ymin)
max_metime <- max(xmax, ymax)
setEPS()
postscript("dual_put512.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Measured times of dual PUT512', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-256540
max_metime <-256650
setEPS()
postscript("dual_put512_trimmed.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT512', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-256550
max_metime <-256590
setEPS()
postscript("dual_put512_trimmed_level1.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT512', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT512.dat"
dataName1 = "dual1_PUT512.dat"
dataName2 = "dual2_PUT512.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
nrows <- nrow(x)
nrows
#min_metime <-256540
#max_metime <-256650
min_metime <-256560
max_metime <-256590
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
x <- subset(x, x$METIME2 >= min_metime & x$METIME2 <= max_metime)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT1024.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put1024.eps")
xmin<- min(x$METIME)
xmin
xmax <- max(x$METIME)
xmax
xmin <- xmin-3124#513124
xmax <- xmax+3217#536793
plot(x$ITERNUM, x$METIME, ylim=c(xmin, xmax), 
xlab='Iterations', main='Measured times in the first half of dual PUT1024', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT1024.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put1024.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
ymin <- ymin-3123#513123
ymax <- ymax+4547#545453
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax),  
xlab='Iterations', main='Measured times in the second half of dual PUT1024', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT1024.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT1024.dat",head=TRUE,sep="\t")
min_metime <- min(xmin, ymin)
max_metime <- max(xmax, ymax)
setEPS()
postscript("dual_put1024.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Measured times of dual PUT1024', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-513000
max_metime <-514000
setEPS()
postscript("dual_put1024_trimmed.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT1024', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-513100
max_metime <-513200
setEPS()
postscript("dual_put1024_trimmed_level1.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT1024', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT1024.dat"
dataName1 = "dual1_PUT1024.dat"
dataName2 = "dual2_PUT1024.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
min_metime <-510000
max_metime <-520000
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
x <- subset(x, x$METIME2 >= min_metime & x$METIME2 <= max_metime)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put2048.eps")
xmin<- min(x$METIME)
xmin
xmax <- max(x$METIME)
xmax
xmin <- 1025000#1026253
xmax <- 1060000#1058946
plot(x$ITERNUM, x$METIME, ylim=c(xmin, xmax), 
xlab='Iterations', main='Measured times in the first half of dual PUT2048', 
ylab=expression('Measured Time (ms)'))
dev.off()
x = read.csv(file="dual2_PUT2048.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put2048.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
ymin <- 1025000#1026250
ymax <- 1060000#1059264
plot(x$ITERNUM, x$METIME, ylim=c(ymin, ymax),  
xlab='Iterations', main='Measured times in the second half of dual PUT2048', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT2048.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT2048.dat",head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
min_metime <- 1025000
max_metime <- 1060000
setEPS()
postscript("dual_put2048.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Measured times of dual PUT2048', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-1026000
max_metime <-1027500
setEPS()
postscript("dual_put2048_trimmed.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT2048', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-1026240
max_metime <-1026320
setEPS()
postscript("dual_put2048_trimmed_level1.eps")
plot(x$METIME, y$METIME,  xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
main='Zoomed-in measured times of dual PUT2048', 
xlab='1st half\'s measured times (ms)', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT2048.dat"
dataName1 = "dual1_PUT2048.dat"
dataName2 = "dual2_PUT2048.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
min_metime <-1026000
max_metime <-1027500
x <- subset(x, x$METIME1 >= min_metime & x$METIME1 <= max_metime)
x <- subset(x, x$METIME2 >= min_metime & x$METIME2 <= max_metime)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual1_put4096.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(ymin-1888, ymax+6817), 
xlab='Iterations', main='Measured times in the first half of dual PUT4096', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual2_put4096.eps")
ymin<- min(x$METIME)
ymin
ymax <- max(x$METIME)
ymax
plot(x$ITERNUM, x$METIME, ylim=c(2050000, 2090000), 
xlab='Iterations', main='Measured times in the second half of dual PUT4096', 
ylab=expression('Measured Time (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
xmin<- min(x$METIME)
xmin
xmax<- max(x$METIME)
xmax
y = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
ymin<- min(y$METIME)
ymin
ymax<- max(y$METIME)
ymax
x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
setEPS()
postscript("dual_put4096.eps")
plot(x$METIME, y$METIME, 
xlim=c(2050000, 2085000), ylim=c(2050000, 2085000), 
xlab='1st half\'s measured times (ms)', main='Measured times of dual PUT4096', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
setEPS()
postscript("dual_put4096_trimmed.eps")
min_metime <-2052300
max_metime <-2052900
plot(x$METIME, y$METIME, 
#xlim=c(2052400, 2052600), ylim=c(2052400, 2052600), 
#xlim=c(2052400, 2052800), ylim=c(2052400, 2052800), 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in Measured times of dual PUT4096', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

x = read.csv(file="dual1_PUT4096.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT4096.dat",head=TRUE,sep="\t")
min_metime <-2052450
max_metime <-2052700
setEPS()
postscript("dual_put4096_trimmed_level1.eps")
plot(x$METIME, y$METIME, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in Measured times of dual PUT4096', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT4096.dat"
dataName1 = "dual1_PUT4096.dat"
dataName2 = "dual2_PUT4096.dat"
x = read.csv(file=dataName1,head=TRUE,sep="\t")
y = read.csv(file=dataName2,head=TRUE,sep="\t")
cor(x$METIME, y$METIME)
total <- cbind(ITERNUM=c(x$ITERNUM), METIME1=(x$METIME),METIME2=(y$METIME))
write.table(total, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 
x = read.csv(file=dataName,head=TRUE,sep="\t")
nrows <- nrow(x)
nrows
x <- subset(x, x$METIME1 >= 2050000 & x$METIME1 <= 2055000)
x <- subset(x, x$METIME2 >= 2050000 & x$METIME2 <= 2055000)
nnormal <- nrow(x)
nnormal
nrows-nnormal
cor(x$METIME1, x$METIME2)

dataName = "dual_PUT4096.dat"
setEPS()
x = read.csv(file=dataName,head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM != c(57,250,331,394,456));
#x <- x[-c(56,249,330,393,455), ]## 165: 770000
#x <- x[-c(57,250,331,394,456,123,165), ]
## 122, 159,215,229,243,250,271
## 123, 165: two outliers
x <- x[-c(57,250,331,394,456), ]
#min_metime <- min(x$METIME1, x$METIME2);
#min_metime#2051330
#min_metime <- min_metime - 1330
#max_metime <- max(x$METIME1, x$METIME2);
#max_metime#2083183
#max_metime <- max_metime + 6817
min_metime <- 2050000
max_metime <- 2085000
postscript("dual_put4096_new.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Measured times of refined dual PUT4096', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <- 2052300
max_metime <- 2052900
x <- subset(x, x$METIME1 < max_metime & x$METIME2 < max_metime)
postscript("dual_put4096_new_trimmed.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in Measured times of refined dual PUT4096', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()


dataName = "dual_PUT4096.dat"
x = read.csv(file=dataName,head=TRUE,sep="\t")
pivot = 2052575
x1 <- subset(x, x$METIME1 < pivot & x$METIME2 < pivot)
nrow(x1)
x2 <- subset(x, x$METIME1 < pivot & x$METIME2 >= pivot)
nrow(x2)
x3 <- subset(x, x$METIME1 >= pivot & x$METIME2 < pivot)
nrow(x3)
x4 <- subset(x, x$METIME1 >= pivot & x$METIME2 >= pivot)
nrow(x4)
dataName = "group1_PUT4096.dat"
write.table(x1$ITERNUM, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=FALSE) 
dataName = "group2_PUT4096.dat"
write.table(x2$ITERNUM, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=FALSE) 
dataName = "group3_PUT4096.dat"
write.table(x3$ITERNUM, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=FALSE) 
dataName = "group4_PUT4096.dat"
write.table(x4$ITERNUM, dataName, append=FALSE, sep="\t", row.names=FALSE, col.names=FALSE) 

dataName = "dual_PUT512.dat"
setEPS()
x = read.csv(file=dataName,head=TRUE,sep="\t")
#y <- x[c(5,33,61,89,117,145,173,201,229,257,285,313,341,369,370,425,453,472,500,528,556,584,612,640,668,696,724,752,780,815,843,871,899,927,955,984), ]
x <- x[-c(5,33,61,89,117,145,173,201,229,257,285,313,341,369,370,425,453,472,500,528,556,584,612,640,668,696,724,752,780,815,843,871,899,927,955,984), ]
#x <- x[-c(4,32,60,88,116,144,172,200,228,256,284,312,340,368,396,424,452,471,499,527,555,583,611,639,667,695,723,751,779,814,842,870,898,926,954,983), ]
min_metime <- min(x$METIME1, x$METIME2);
min_metime#256557
min_metime <- min_metime - 157
max_metime <- max(x$METIME1, x$METIME2);
max_metime#257138
max_metime <- max_metime + 262
postscript("dual_put512_new.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Measured times of refined dual PUT512', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <-256540
max_metime <-256650
setEPS()
x <- subset(x, x$METIME1 < max_metime & x$METIME2 < max_metime)
postscript("dual_put512_new_trimmed.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in Measured times of refined dual PUT512', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT1024.dat"
setEPS()
x = read.csv(file=dataName,head=TRUE,sep="\t")
#x <- x[-c(79,151,663,834), ]--DB
x <- x[-c(80,152,664,835), ]
#min_metime <- min(x$METIME1, x$METIME2);
#min_metime#256557
#min_metime <- min_metime - 557
#max_metime <- max(x$METIME1, x$METIME2);
#max_metime#257388
#max_metime <- max_metime + 612
min_metime <- 510000
max_metime <- 550000
postscript("dual_put1024_new.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Measured times of refined dual PUT1024', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <- 513000
max_metime <- 514000
x <- subset(x, x$METIME1 < max_metime & x$METIME2 < max_metime)
postscript("dual_put1024_new_trimmed.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in Measured times of refined dual PUT1024', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

dataName = "dual_PUT2048.dat"
setEPS()
x = read.csv(file=dataName,head=TRUE,sep="\t")
#x <- x[-c(58,101,143,178,305,353,395,436,604,943), ]--DB
x <- x[-c(59,102,144,179,306,354,396,437,605,944), ]
min_metime <- 1025000
max_metime <- 1060000
postscript("dual_put2048_new.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Measured times of refined dual PUT2048', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

min_metime <- 1026000
max_metime <- 1027500
x <- subset(x, x$METIME1 < max_metime & x$METIME2 < max_metime)
postscript("dual_put2048_new_trimmed.eps")
plot(x$METIME1, x$METIME2, 
xlim=c(min_metime, max_metime), ylim=c(min_metime, max_metime), 
xlab='1st half\'s measured times (ms)', main='Zoomed-in Measured times of refined dual PUT2048', 
ylab=expression('2nd half\'s measured times (ms)'))
dev.off()

