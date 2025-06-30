#!/bin/bash
#
#$ -q all.q
#$ -pe mpi 4
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -l gpu=1
#
#module load amber/18

pmemd.cuda -O -i 1-min1.in -o min1.out -p complex-solvated.prmtop -c complex-solvated.inpcrd -r min1.crd -ref complex-solvated.inpcrd
wait
pmemd.cuda -O -i 2-min2.in -o min2.out -p complex-solvated.prmtop -c min1.crd -r min2.crd -ref min1.crd
wait
pmemd.cuda -O -i 3-min3.in -o min3.out -p complex-solvated.prmtop -c min2.crd -r min3.crd -ref min2.crd
wait
pmemd.cuda -O -i 4-md1-Heat.in -o md1.out -p complex-solvated.prmtop -c min3.crd -ref min3.crd -r md1.restrt -x md1.nc -v mdvel
pmemd.cuda -O -i 5-md2-Density.in -o md2.out -p complex-solvated.prmtop -c md1.restrt -ref md1.restrt -r md2.restrt -x md2.nc -v mdvel
pmemd.cuda -O -i 6-md3-Equil-1.in -o md3.out -p complex-solvated.prmtop -c md2.restrt -ref md2.restrt -r md3.restrt -x md3.nc -v mdvel
pmemd.cuda -O -i 7-md4-Equil-2.in -o md4.out -p complex-solvated.prmtop -c md3.restrt -ref md3.restrt -r md4.restrt -x md4.nc -v mdvel
pmemd.cuda -O -i 8-md5-Equil-3.in -o md5.out -p complex-solvated.prmtop -c md4.restrt -ref md4.restrt -r md5.restrt -x md5.nc -v mdvel
pmemd.cuda -O -i 9-md6-Prod-1.in -o md6.out -p complex-solvated.prmtop -c md5.restrt -ref md5.restrt -r md6.restrt -x md6.nc -v mdvel

for ((i=7;i<=106;i++)); do
        j=$((i-1))
        pmemd.cuda -O -i 10-md7-Prod-2.in -o md${i}.out -p complex-solvated.prmtop -c md${j}.restrt -ref md${j}.restrt -r md${i}.restrt -x md${i}.nc -v mdvel
done
