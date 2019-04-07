setwd("~/Desktop/MEGA/8sem/comparada/final/Watanabe/trees//")
library(ape)
library(phytools)
library(phangorn)
library(ggplot2)

#árboles de referencia
morfo <- read.tree("watanabe-morfo.tree")
geo <- read.tree("watanabe-geo.tree")
comb <- read.tree("watanabe-0001-prior.tree")

RF.dist(comb,geo)
#plot
assoc <- cbind(morfo$tip.label, morfo$tip.label)
obj <- cophylo(morfo, geo, assoc = assoc, rotate = T, print = T)

svg("watanabe.svg")
plot(obj,link.type="curved",link.lwd=3,link.lty="solid",
     link.col=make.transparent("blue",0.25),fsize=0.8)
dev.off()

#crear listas
list_piwe <- list.files(pattern = "piwe")
list_prior <- list.files(pattern = "prior.tree")

#leer los arboles, quedan en multiphylo
piwe <- lapply(list_piwe, read.tree)
prior <- lapply(list_prior, read.tree)

#volverlos multiphylo y binarios
class(piwe) <- "multiPhylo"
piwe <- multi2di(piwe)
class(prior) <- "multiPhylo"
prior <- multi2di(prior)

#RF
comparar <- function(multiphylo, ref.tre) {
  
  numT <- length(multiphylo)
  dist_RF <- vector("numeric", numT)
  for (i in 1:numT){
    dist_RF[i]<- RF.dist(multiphylo[[i]],
                         ref.tre)
  }
  return(dist_RF)
}


h <- comparar(multiphylo = prior,ref.tre = morfo)

#######################################################

morfo_geo <- RF.dist(morfo, geo)

#morfo partition comparation
morfo_piwe <- comparar(multiphylo = piwe, ref.tre = morfo)

morfo_prior <- comparar(multiphylo = prior, ref.tre = morfo)

#geometrical partition comparation
geo_piwe <- comparar(multiphylo = piwe, ref.tre = geo)
geo_piwe <- as.data.frame(geo_piwe)
piwe <- c(0.5, 3, 6, 10, 14, 16, 20)
p <- ggplot(geo_piwe, aes(x=piwe, y=geo_piwe)) + geom_smooth(color="gray") + geom_point() + ylab("RF distance") + xlab("k value")
svg("geo_piwe")
plot(p)
dev.off()

geo_prior <- comparar(multiphylo = prior, ref.tre = geo)
geo_prior <- as.data.frame(geo_prior)
prior <- c(132, 264, 396, 528)
p <- ggplot(geo_prior, aes(x=prior, y=geo_prior)) + geom_smooth(color="red", linetype="dotted") + geom_point(size=3) + ylab("RF distance") + xlab("Weight of GM partition") + theme(axis.text=element_text(size=23), axis.title=element_text(size=23))
png("geo_prior.png")
plot(p)
dev.off()

#morfo
plot(geo_piwe, main = "piwe")

plot(geo_prior, main="priori")
