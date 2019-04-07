setwd("~/Desktop/MEGA/8sem/comparada/final/rosacea/trees/")
library(ape)
library(phytools)
library(phangorn)
library(ggplot2)

#árboles de referencia
adn <- read.tree("rosa-dna.tree")
geo <- read.tree("rosa-geo.tree")
comb <- read.tree("rosa-01-prior.tree")

RF.dist(geo,comb)

#plot
assoc <- cbind(adn$tip.label, adn$tip.label)
obj <- cophylo(adn, geo, assoc = assoc, rotate = T, print = T)

svg("rosacea.svg")
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

adn_geo <- RF.dist(adn, geo)

#adn partition comparation
adn_piwe <- comparar(multiphylo = piwe, ref.tre = adn)

adn_prior <- comparar(multiphylo = prior, ref.tre = adn)

#geometrical partition comparation
geo_piwe <- comparar(multiphylo = piwe, ref.tre = geo)
geo_piwe <- as.data.frame(geo_piwe)
piwe <- c(0.5, 3, 6, 10, 14, 16, 20)
p <- ggplot(geo_piwe, aes(x=piwe, y=geo_piwe)) + geom_smooth(color="grey", linetype="dotted") + geom_point(size=2) + ylab("RF distance") + xlab("k value")
svg("geo_piwe")
plot(p)
dev.off()
#
geo_prior <- comparar(multiphylo = prior, ref.tre = geo)
geo_prior <- as.data.frame(geo_prior)
prior <- c(268, 536, 804, 1000)
p <- ggplot(geo_prior, aes(x=prior, y=geo_prior)) + geom_smooth(color="red", linetype="dotted") + geom_point(size=3) + ylab("RF distance") + xlab("Weight of GM partition") + theme(axis.text=element_text(size=23), axis.title=element_text(size=23))
png("geo_prior.png")
plot(p)
dev.off()
