x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
total <- NULL
max <- 1000
for(i in 2:max)
{
	x1 <- subset(x, x$ITERNUM == i-1)
	x2 <- subset(x, x$ITERNUM == i)
	c <- x2$METIME-x1$METIME
	total <- rbind(total, c(i-1, c))
}
cols <- c("ITER_PAIR","DIFF")
colnames(total) <- cols
nrow(total)
postscript("16_sec_ip_diff.eps")
#write.table(total, "16_sec_iter_diff.dat", sep="\t", row.names=FALSE, col.names=FALSE) 
plot(total,  
main='Iteration Dependency of PUT2', 
xlim=c(1, 999), 
ylim=c(-550, 550), 
xlab='Iteration Pair', 
ylab=expression('Program time difference (ms)'))
dev.off()



x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
total <- c("ITER_PAIR", "CORR_VAL")
max <- 10
for(i in 2:max)
{
	x1 <- subset(x, x$ITERNUM == i-1)
	x2 <- subset(x, x$ITERNUM == i)
	c <- cor(x1$METIME, x2$METIME)
	if(is.na(c)){
	  c <- 0
	}
	total <- rbind(total, c(i-1, c))
}
nrow(total)
write.table(total, "16_sec_ip_cor.dat", sep="\t", row.names=FALSE, col.names=FALSE) 
#In cor(first$METIME, second$METIME) : the standard deviation is zero	

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
x1 <- subset(x, x$ITERNUM == 2)
x2 <- subset(x, x$ITERNUM == 3)
c <- cor(x1$METIME, x2$METIME)

x1 <- subset(x, x$ITERNUM == 84)
y1 <- subset(y, y$ITERNUM == 84)
x2 <- subset(x, x$ITERNUM == 85)
y2 <- subset(y, y$ITERNUM == 85)
first <- rbind(x1, y1)
second <- rbind(x2, y2)
c <- cor(first$METIME, second$METIME)
> first
    ITERNUM METIME
84       84   8019
841      84   8019
    ITERNUM METIME
85       85   8015
851      85   8019

