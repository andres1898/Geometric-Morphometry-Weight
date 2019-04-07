for  i in 0 5 10 15 20
do
./tnt macro= \; log piwe-$i-ospina.log \; proc ospina_comb.tnt \; piwe = $i \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -ospina-$i-piweK.boot.tre \; zzz
done

for i in 250 500 750 1000
do
tnt macro= \; log prior-1000-ospina.log \; proc ospina_comb.tnt \; cc /$i 0 \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -ospina-$i-prior.boot.tre \; zzz
done

#geo
./tnt macro= \; log $i_ospina-geo.log \; proc ospina_geo.tnt \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -ospina-geo.boot.tre \; zzz

#morfo
./tnt macro= \; log $i-ospina-morfo.log \; proc ospina_morpho.tnt \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -ospina-adn.boot.tre \; zzz

mkdir trees
mkdir logs
mkdir boot_trees
mkdir trees

for i in *.tre
do
awk '(NR==7) {print};' "$i" >> "${i%.boot.tre}.tree"
done

mv *.tree ./trees/
mv *.log ./logs/
mv *.boot.tre ./boots/
mv *.tree ./trees/
