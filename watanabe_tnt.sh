for  i in 0 5 10 15 20
do
./tnt macro= \; log piwe-$i-watanabe.log \; proc watanabe_comb.tnt \; piwe = $i \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -watanabe-$i-piweK.boot.tre \; zzz
done

for i in 132 264 396 528
do
./tnt macro= \; log prior-$i-watanabe.log \; proc watanabe_comb.tnt \; cc /$i 0 \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -watanabe-$i-prior.boot.tre \; zzz
done

#geo
./tnt macro= \; log watanabe-geo.log \; proc watanabe_geo.tnt \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -watanabe-geo.boot.tre \; zzz

#morfo
./tnt macro= \; log watanabe-morfo.log \; proc watanabe_morpho.tnt \; mult=TBR replic 100 \; taxname= \; ttags= \; resample jak \; ttag \; export -watanabe-morfo.boot.tre \; zzz

mkdir trees
mkdir logs
mkdir boot_trees

for i in *.tre
do
awk '(NR==7) {print};' "$i" >> "${i%.boot.tre}.tree"
done

mv *.tree ./trees
mv *.log ./logs
mv *.boot.tre ./boots

