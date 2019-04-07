#Concavidad
for  i in 0 5 10 15 20
do
./tnt macro= \; log piwe-$i-rosa.log \; proc rosa_comb.tnt \; piwe = $i \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -rosa-$i-piweK.boot.tre \; zzz
done

#pesos priori
for i in 268 536 804 1000
do
./tnt macro= \; log prior-$i-rosa.log \; proc rosa_comb.tnt \; cc /$i 0 \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -rosa-$i-prior.boot.tre \; zzz
done

#normal geo
./tnt macro= \; log rosa-geo.log \; proc rosa_geo.tnt \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -rosa-geo.boot.tre \; zzz

#normal dna
./tnt macro= \; log rosa-dna.log \; proc rosa_DNA.tnt \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -rosa-dna.boot.tre \; zzz

mkdir trees
mkdir logs
mkdir boot_trees
mkdir trees

for i in *.tre
do
awk '(NR==7) {print};' "$i" >> "${i%.boot.tre}.tree"
done

mv *.tree ./trees
mv *.log ./logs
mv *.boot.tre ./boot_trees
mv *.trees ./trees/


