x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("16_sec_ect.eps")
plot(x$METIME, xlim=c(0,1000), pch=19, main='', xlab='# of executions', ylab='ET (ms)')
dev.off()
setEPS()

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
setEPS()
postscript("32_sec_ect.eps")
plot(x$METIME, xlim=c(0,1000), pch=19, main='', xlab='# of executions', ylab='ET (ms)')
dev.off()
setEPS()

setEPS()
postscript("16_sec_pt.eps")
plot(x$PRTIME, xlim=c(0,100), pch=19, main='PT on 16-second task', xlab='# of executions', ylab='PT (ms)')
dev.off()

