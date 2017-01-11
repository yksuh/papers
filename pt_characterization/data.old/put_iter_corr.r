x = read.csv(file="dual1_PUT2.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <=10)
y = read.csv(file="dual2_PUT2.dat",head=TRUE,sep="\t")
#y <- subset(y, y$ITERNUM <=10)
total <- c("ITER_PAIR", "CORR_VAL")
max <- 1000
for(i in 2:max)
{
	x1 <- subset(x, x$ITERNUM == i-1)
	x2 <- subset(x, x$ITERNUM == i)
	y1 <- subset(y, y$ITERNUM == i-1)
	y2 <- subset(y, y$ITERNUM == i)
	first <- rbind(x1, x2)
	second <- rbind(y1, y2)
	c <- cor(first$METIME, second$METIME)
	if(is.na(c)){
	  c <- 0
	}
	total <- rbind(total, c(i-1, c))
}
nrow(total)
write.table(total, "2_sec_ip_cor.dat", sep="\t", row.names=FALSE, col.names=FALSE) 

x = read.csv(file="2_sec_ip_cor.dat",head=TRUE,sep="\t")
postscript("2_sec_ip_cor.eps")
plot(x$ITER_PAIR, x$CORR_VAL, xlim=c(0, 1000), ylim=c(-2, 2), 
xlab='Iteration Pair', main='Iteration Dependency of dual PUT2', ylab=expression('Correlation Efficient (-1 ~ 1)'))
dev.off()


x = read.csv(file="dual1_PUT16.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <=10)
y = read.csv(file="dual2_PUT16.dat",head=TRUE,sep="\t")
#y <- subset(y, y$ITERNUM <=10)
total <- c("ITER_PAIR", "CORR_VAL")
max <- 1000
for(i in 2:max)
{
	x1 <- subset(x, x$ITERNUM == i-1)
	x2 <- subset(x, x$ITERNUM == i)
	y1 <- subset(y, y$ITERNUM == i-1)
	y2 <- subset(y, y$ITERNUM == i)
	first <- rbind(x1, x2)
	second <- rbind(y1, y2)
	c <- cor(first$METIME, second$METIME)
	if(is.na(c)){
	  c <- 0
	}
	total <- rbind(total, c(i-1, c))
}
nrow(total)
write.table(total, "16_sec_ip_cor.dat", sep="\t", row.names=FALSE, col.names=FALSE) 

x = read.csv(file="16_sec_ip_cor.dat",head=TRUE,sep="\t")
postscript("16_sec_ip_cor.eps")
plot(x$ITER_PAIR, x$CORR_VAL, xlim=c(0, 1000), ylim=c(-2, 2), 
xlab='Iteration Pair', main='Iteration Dependency of dual PUT16', ylab=expression('Correlation Efficient (-1 ~ 1)'))
dev.off()

x = read.csv(file="dual1_PUT8.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <=10)
y = read.csv(file="dual2_PUT8.dat",head=TRUE,sep="\t")
#y <- subset(y, y$ITERNUM <=10)
total <- c("ITER_PAIR", "CORR_VAL")
max <- 1000
for(i in 2:max)
{
	x1 <- subset(x, x$ITERNUM == i-1)
	x2 <- subset(x, x$ITERNUM == i)
	y1 <- subset(y, y$ITERNUM == i-1)
	y2 <- subset(y, y$ITERNUM == i)
	first <- rbind(x1, x2)
	second <- rbind(y1, y2)
	c <- cor(first$METIME, second$METIME)
	if(is.na(c)){
	  c <- 0
	}
	total <- rbind(total, c(i-1, c))
}
nrow(total)
write.table(total, "8_sec_ip_cor.dat", sep="\t", row.names=FALSE, col.names=FALSE) 

x = read.csv(file="8_sec_ip_cor.dat",head=TRUE,sep="\t")
postscript("8_sec_ip_cor.eps")
plot(x$ITER_PAIR, x$CORR_VAL, xlim=c(0, 1000), ylim=c(-2, 2), 
xlab='Iteration Pair', main='Iteration Dependency of dual PUT8', ylab=expression('Correlation Efficient (-1 ~ 1)'))
dev.off()

x = read.csv(file="dual1_PUT32.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <=10)
y = read.csv(file="dual2_PUT32.dat",head=TRUE,sep="\t")
#y <- subset(y, y$ITERNUM <=10)
total <- c("ITER_PAIR", "CORR_VAL")
max <- 1000
for(i in 2:max)
{
	x1 <- subset(x, x$ITERNUM == i-1)
	x2 <- subset(x, x$ITERNUM == i)
	y1 <- subset(y, y$ITERNUM == i-1)
	y2 <- subset(y, y$ITERNUM == i)
	first <- rbind(x1, x2)
	second <- rbind(y1, y2)
	c <- cor(first$METIME, second$METIME)
	if(is.na(c)){
	  c <- 0
	}
	total <- rbind(total, c(i-1, c))
}
nrow(total)
write.table(total, "32_sec_ip_cor.dat", sep="\t", row.names=FALSE, col.names=FALSE) 

x = read.csv(file="32_sec_ip_cor.dat",head=TRUE,sep="\t")
postscript("32_sec_ip_cor.eps")
plot(x$ITER_PAIR, x$CORR_VAL, xlim=c(0, 1000), ylim=c(-2, 2), 
xlab='Iteration Pair', main='Iteration Dependency of dual PUT32', ylab=expression('Correlation Efficient (-1 ~ 1)'))
dev.off()


#In cor(first$METIME, second$METIME) : the standard deviation is zero	
total <- c("ITER_PAIR", "CORR_VAL")
x = read.csv(file="dual1_PUT2.dat",head=TRUE,sep="\t")
y = read.csv(file="dual2_PUT2.dat",head=TRUE,sep="\t")
x1 <- subset(x, x$ITERNUM == 1)
y1 <- subset(y, y$ITERNUM == 1)
x2 <- subset(x, x$ITERNUM == 2)
y2 <- subset(y, y$ITERNUM == 2)
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

x = read.csv(file="dual1_PUT2.dat",head=TRUE,sep="\t")
#x <- subset(x, x$ITERNUM <=10)
y = read.csv(file="dual2_PUT2.dat",head=TRUE,sep="\t")
x1 <- subset(x, x$ITERNUM == 974)
y1 <- subset(y, y$ITERNUM == 974)
x2 <- subset(x, x$ITERNUM == 975)
y2 <- subset(y, y$ITERNUM == 975)
first <- rbind(x1, y1)
second <- rbind(x2, y2)
c <- cor(first$METIME, second$METIME)


x1 <- subset(x, x$ITERNUM == 965)
y1 <- subset(y, y$ITERNUM == 965)
x2 <- subset(x, x$ITERNUM == 966)
y2 <- subset(y, y$ITERNUM == 966)
first <- rbind(x1, y1)
second <- rbind(x2, y2)
c <- cor(first$METIME, second$METIME)

x1 <- subset(x, x$ITERNUM == 965)
x2 <- subset(x, x$ITERNUM == 966)
y1 <- subset(y, y$ITERNUM == 965)
y2 <- subset(y, y$ITERNUM == 966)
first <- rbind(x1, y2)
second <- rbind(y1, y2)
c <- cor(first$METIME, second$METIME)

x1 <- subset(x, x$ITERNUM == 102)
y1 <- subset(y, y$ITERNUM == 102)
x2 <- subset(x, x$ITERNUM == 103)
y2 <- subset(y, y$ITERNUM == 103)
first <- rbind(x1, y1)
second <- rbind(x2, y2)
c <- cor(first$METIME, second$METIME)
