
x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("1_sec_et_all.eps")
plot(x$METIME, xlim=c(0,1000), ylim=c(1100, 1300), pch=1, main='', xlab='# of executions', ylab='ET (msec)')
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("2_sec_et_all.eps")
plot(x$METIME, xlim=c(0,1000), ylim=c(2200, 2500), pch=1, main='', xlab='# of executions', ylab='ET (msec)')
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("4_sec_et_all.eps")
plot(x$METIME, xlim=c(0,1000), ylim=c(4500, 5000), pch=1, main='', xlab='# of executions', ylab='ET (msec)')
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("8_sec_et_all.eps")
plot(x$METIME, xlim=c(0,1000), ylim=c(9000, 9300), pch=1, main='', xlab='# of executions', ylab='ET (msec)')
dev.off()

#plot(x$METIME, xlim=c(0,1000), ylim=c(min(x$METIME), max(x$METIME)), pch=1, main='', xlab='# of executions', ylab='ET (msec)')
