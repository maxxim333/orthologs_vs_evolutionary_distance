#Distribution of distances VS number of orthologous genes
data <- read.table("species_distances_occurrence.txt" , header = FALSE, dec = ".", fill=TRUE)
na.omit(data)
plot(data$V2, data$V3, xlab = "Evolutionary Distance", ylab = "Number of orthologues")

datafr<-as.data.frame(data)
x<-as.data.frame(datafr$V2)
y<-x<100 

for (specie in datafr$V2)
  if(specie < 900 && specie>800){
    print(specie)
  }

#There are many species with the distance exactly equal to 870.6481
#Also many of those are around 192

datafr2 <- as.data.frame(datafr[datafr$V2 <= 900, ]) 
datafr2
datafr3 <- as.data.frame(datafr2[datafr2$V2 >= 800, ]) 
datafr3


datafr2 <- as.data.frame(datafr[datafr$V2 <= 200, ]) 
datafr2
datafr3 <- as.data.frame(datafr2[datafr2$V2 >= 190, ]) 
datafr3

distance=datafr$V2
number=datafr$V3
#Is there correlation?

plot(data$V2, data$V3, xlab = "Evolutionary Distance", ylab = "Number of orthologues")
abline(lm(data$V2~data$V3),col="red",lwd=1.5)
