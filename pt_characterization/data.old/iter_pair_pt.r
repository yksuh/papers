x = read.csv(file="1_sec.dat",head=TRUE,sep="\t")
postscript("1_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
min_val <- min(min(odd_x$PRTIME), min(even_x$PRTIME)) - 1
max_val <- max(max(odd_x$PRTIME), max(even_x$PRTIME)) + 1
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
main='Iteration Dependency of PUT1', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="2_sec.dat",head=TRUE,sep="\t")
postscript("2_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
min_val <- min(min(odd_x$PRTIME), min(even_x$PRTIME)) - 4
max_val <- max(max(odd_x$PRTIME), max(even_x$PRTIME)) + 4
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
main='Iteration Dependency of PUT2', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="4_sec.dat",head=TRUE,sep="\t")
postscript("4_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
min_val <- min(min(odd_x$PRTIME), min(even_x$PRTIME)) - 2
max_val <- max(max(odd_x$PRTIME), max(even_x$PRTIME)) + 2
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
main='Iteration Dependency of PUT4', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="8_sec.dat",head=TRUE,sep="\t")
postscript("8_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
min_val <- min(min(odd_x$PRTIME), min(even_x$PRTIME)) - 2
max_val <- max(max(odd_x$PRTIME), max(even_x$PRTIME)) + 2
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
main='Iteration Dependency of PUT8', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="16_sec.dat",head=TRUE,sep="\t")
postscript("16_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-4
pt_max <- max(x$PRTIME)+5
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT16', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="32_sec.dat",head=TRUE,sep="\t")
postscript("32_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- 32060
pt_max <- 32090
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT32', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="64_sec.dat",head=TRUE,sep="\t")
postscript("64_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
min_val <- min(min(odd_x$PRTIME), min(even_x$PRTIME)) - 5
max_val <- max(max(odd_x$PRTIME), max(even_x$PRTIME)) + 5
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
#pt_min <- min(x$PRTIME)-5
#pt_max <- max(x$PRTIME)
#plot(odd_x$PRTIME, even_x$PRTIME, 
#xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT64', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()


x = read.csv(file="128_sec.dat",head=TRUE,sep="\t")
postscript("128_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-5
pt_max <- max(x$PRTIME)
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT128', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="256_sec.dat",head=TRUE,sep="\t")
postscript("256_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
min_val <- min(min(odd_x$PRTIME), min(even_x$PRTIME)) - 10
max_val <- max(max(odd_x$PRTIME), max(even_x$PRTIME)) + 10
#pt_min <- min(x$PRTIME)
#pt_max <- max(x$PRTIME)+5
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(min_val, max_val), ylim=c(min_val, max_val), 
main='Iteration Dependency of PUT256', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
postscript("512_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_max <- max(x$PRTIME)+50
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT512', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="512_sec.dat",head=TRUE,sep="\t")
postscript("512_sec_ip_pt_trimmed.eps")
x_up = mean(x$PRTIME) + 1.5*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 1.5*sd(x$PRTIME)
y = subset(x, x$PRTIME < x_dn | x$PRTIME > x_up)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
odd_x <- subset(x, (x$ITERNUM %% 2 == 1))
even_x <- subset(x, (x$ITERNUM %% 2 == 0))
for(i in y$ITERNUM){
	if(i %% 2 == 1){
		odd_x <- subset(odd_x, odd_x$ITERNUM != i)
		even_x <- subset(even_x, even_x$ITERNUM != i+1)
	}
	else{
		even_x <- subset(even_x, even_x$ITERNUM != i)
		odd_x <- subset(odd_x, odd_x$ITERNUM != i-1)
	}
}
nrow(odd_x)
nrow(even_x)
pt_min <- min(odd_x$PRTIME, even_x$PRTIME)
pt_min
pt_max <- max(odd_x$PRTIME, even_x$PRTIME)
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT512', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
postscript("1024_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT1024', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="1024_sec.dat",head=TRUE,sep="\t")
postscript("1024_sec_ip_pt_trimmed.eps")
x_up = mean(x$PRTIME) + 1.4*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 1.4*sd(x$PRTIME)
y = subset(x, x$PRTIME < x_dn | x$PRTIME > x_up)
nrow(y)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmin <- min(x$PRTIME)
xmin
xmax <- max(x$PRTIME)
xmax
nrow(x)
odd_x <- subset(x, (x$ITERNUM %% 2 == 1))
even_x <- subset(x, (x$ITERNUM %% 2 == 0))
for(i in y$ITERNUM){
	if(i %% 2 == 1){
		odd_x <- subset(odd_x, odd_x$ITERNUM != i)
		#print(nrow(odd_x))
		even_x <- subset(even_x, even_x$ITERNUM != i+1)
		#print(nrow(even_x))
	}
	else{
		even_x <- subset(even_x, even_x$ITERNUM != i)
		#print(nrow(even_x))
		odd_x <- subset(odd_x, odd_x$ITERNUM != i-1)
		#print(nrow(odd_x))
	}
}
nrow(odd_x)
nrow(even_x)
pt_min <- min(odd_x$PRTIME, even_x$PRTIME)
pt_min
pt_max <- max(odd_x$PRTIME, even_x$PRTIME)+5
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT1024', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
postscript("2048_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT2048', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="2048_sec.dat",head=TRUE,sep="\t")
postscript("2048_sec_ip_pt_trimmed.eps")
x_up = mean(x$PRTIME) + 2*sd(x$PRTIME)
x_dn = mean(x$PRTIME) - 2*sd(x$PRTIME)
y = subset(x, x$PRTIME < x_dn | x$PRTIME > x_up)
nrow(y)
x = subset(x, x$PRTIME >= x_dn & x$PRTIME <= x_up)
xmin <- min(x$PRTIME)
xmin
xmax <- max(x$PRTIME)
xmax
nrow(x)
odd_x <- subset(x, (x$ITERNUM %% 2 == 1))
even_x <- subset(x, (x$ITERNUM %% 2 == 0))
for(i in y$ITERNUM){
	if(i %% 2 == 1){
		odd_x <- subset(odd_x, odd_x$ITERNUM != i)
		#print(nrow(odd_x))
		even_x <- subset(even_x, even_x$ITERNUM != i+1)
		#print(nrow(even_x))
	}
	else{
		even_x <- subset(even_x, even_x$ITERNUM != i)
		#print(nrow(even_x))
		odd_x <- subset(odd_x, odd_x$ITERNUM != i-1)
		#print(nrow(odd_x))
	}
}
nrow(odd_x)
nrow(even_x)
pt_min <- min(odd_x$PRTIME, even_x$PRTIME)
pt_min
pt_max <- max(odd_x$PRTIME, even_x$PRTIME)
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT2048', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="4096_sec.dat",head=TRUE,sep="\t")
postscript("4096_sec_ip_pt.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT4096', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="8192_sec1.dat",head=TRUE,sep="\t")
postscript("8192_sec_ip_pt1.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT8192 in Apr 2015', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="8192_sec2.dat",head=TRUE,sep="\t")
postscript("8192_sec_ip_pt2.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT8192 in Nov 2015', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="16384_sec1.dat",head=TRUE,sep="\t")
postscript("16384_sec_ip_pt1.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT16384 in Apr 2015', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()

x = read.csv(file="16384_sec2.dat",head=TRUE,sep="\t")
postscript("16384_sec_ip_pt2.eps")
odd_x <- subset(x, x$ITERNUM %% 2 == 1)
even_x <- subset(x, x$ITERNUM %% 2 == 0)
pt_min <- min(x$PRTIME)-50
pt_min
pt_max <- max(x$PRTIME)+50
pt_max
plot(odd_x$PRTIME, even_x$PRTIME, 
xlim=c(pt_min , pt_max), ylim=c(pt_min, pt_max), 
main='Iteration Dependency of PUT16384 in Nov 2015', 
xlab='Odd iteration\'s program time (ms)', ylab=expression('Even iteration\'s program time (ms)'))
dev.off()
