
x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_pt_all.eps")
plot(x$PRTIME, xlim=c(0,1000), ylim=c(1020, 1100), pch=1, main='', xlab='# of executions', ylab='PT (msec)')
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_pt_all.eps")
plot(x$PRTIME, xlim=c(0,1000), ylim=c(2060, 2160), pch=1, main='', xlab='# of executions', ylab='PT (msec)')
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_pt_all.eps")
plot(x$PRTIME, xlim=c(0,1000), ylim=c(4120, 4260), pch=1, main='', xlab='# of executions', ylab='PT (msec)')
dev.off()
