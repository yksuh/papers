x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("PUT1_pt.eps")
ymin<- min(x$PRTIME)
ymax <- max(x$PRTIME)
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT1_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymax <- max(x$TPRTIME-x$PRTIME)
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
postscript("PUT2_pt.eps")
ymin<- min(x$PRTIME)
ymax <- max(x$PRTIME)
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin, ymax+1), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT2_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymax <- max(x$TPRTIME-x$PRTIME)
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
postscript("PUT4_pt.eps")
ymin<- min(x$PRTIME)
ymax <- max(x$PRTIME)
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT4_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymax <- max(x$TPRTIME-x$PRTIME)
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
postscript("PUT8_pt.eps")
ymin<- min(x$PRTIME)
ymax <- max(x$PRTIME)
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin, ymax+2), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT8_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymax <- max(x$TPRTIME-x$PRTIME)
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
postscript("PUT16_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-1, ymax+1), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT16_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin, ymax+53), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
postscript("PUT32_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-4, ymax+6), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT32_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-15, ymax+59), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
postscript("PUT64_pt.eps")
ymin<- min(x$PRTIME)
ymax <- max(x$PRTIME)
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-3, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT64_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymax <- max(x$TPRTIME-x$PRTIME)
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin, ymax+100), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)


x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
postscript("PUT128_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-4, ymax), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT128_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-61, ymax+90), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
postscript("PUT256_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-14, ymax+17), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT256_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-60, ymax+71), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
postscript("PUT512_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-45, ymax+48), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT512_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-68, ymax+4738), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
postscript("PUT1024_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-66, ymax+19), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT1024_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-62, ymax+4825), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TPRTIME-x$PRTIME, x$PRTIME)

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
postscript("PUT2048_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-31, ymax+44), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT2048_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-28, ymax+4807), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
postscript("PUT4096_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-1, ymax+21), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT4096_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-2820, ymax+4472), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

x = read.csv(file="8192_sec1.dat",head=TRUE,sep="\t")
postscript("PUT8192_pt1.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-20, ymax+33), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()
postscript("PUT8192_daemon_pt1.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-15, ymax+294), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

x = read.csv(file="8192_sec2.dat",head=TRUE,sep="\t")
postscript("PUT8192_pt2.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, xlim=c(0, 300), ylim=c(ymin-40, ymax+4), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT8192_daemon_pt2.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-5829, ymax+2312), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

#x = read.csv(file="8192_sec1.dat",head=TRUE,sep="\t")
#r1 <- x
#x = read.csv(file="8192_sec2.dat",head=TRUE,sep="\t")
#r2 <- x
#r2$ITERNUM <- r2$ITERNUM+nrow(r1)
#total <- rbind(r1,r2)
#write.table(total, "8192_sec.dat", append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 

x = read.csv(file="8192_sec.dat",head=TRUE,sep="\t")
postscript("PUT8192_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-870, ymax+1004), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT8192_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-15, ymax+42312), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

x = read.csv(file="16384_sec1.dat",head=TRUE,sep="\t")
postscript("PUT16384_pt1.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-57, ymax+33), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT16384_daemon_pt1.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-70, ymax+2815), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

x = read.csv(file="16384_sec2.dat",head=TRUE,sep="\t")
postscript("PUT16384_pt2.eps")
ymin<- min(x$PRTIME)
ymin#16422028
ymax <- max(x$PRTIME)
ymax#16422389
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-28, ymax+11), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT16384_daemon_pt2.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin#252434
ymax <- max(x$TPRTIME-x$PRTIME)
ymax#284733
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(ymin-2434, ymax+5267), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)

#x = read.csv(file="16384_sec1.dat",head=TRUE,sep="\t")
#r1 <- x
#x = read.csv(file="16384_sec2.dat",head=TRUE,sep="\t")
#r2 <- x
#r2$ITERNUM <- r2$ITERNUM+nrow(r1)
#total <- rbind(r1,r2)
#write.table(total, "16384_sec.dat", append=FALSE, sep="\t", row.names=FALSE, col.names=TRUE) 

x = read.csv(file="16384_sec.dat",head=TRUE,sep="\t")
postscript("PUT16384_pt.eps")
ymin<- min(x$PRTIME)
ymin
ymax <- max(x$PRTIME)
ymax
plot(x$ITERNUM, x$PRTIME, ylim=c(ymin-1757, ymax+1611), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

postscript("PUT16384_daemon_pt.eps")
ymin<- min(x$TPRTIME-x$PRTIME)
ymin
ymax <- max(x$TPRTIME-x$PRTIME)
ymax
plot(x$ITERNUM, x$TPRTIME-x$PRTIME, ylim=c(0, ymax+15267), 
xlab='Iterations', ylab=expression('Process Time (ms)'))
dev.off()

cor(x$TDIFF, x$PRTIME)



