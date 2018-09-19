#!/usr/bin/R
pdf("length.pdf")
lens <- read.table("scaf_len.txt")
pdata <- cumsum(lens[,2])
plot(pdata,type="l",ylab='Total length',xlab = 'Seq num')
dev.off()
