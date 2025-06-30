#!/bin/bash
MOLEKUL=$1
FILE="FINAL_RESULTS_MMPBSA.dat"
echo "cd $MOLEKUL/08_gbsa" 
cd $MOLEKUL/08_gbsa
echo "Processing GBSA ....... "
if [ ! -f "$FILE" ]
then
    echo "File $MOLEKUL/08_gbsa/$FILE does not exist"
	touch $FILE
	source /usr/local/amber22/amber.sh
	$AMBERHOME/bin/MMPBSA.py -O -i ../../in/mmpbgbsa.in -o $FILE -sp ../../MD/complex-solvated.prmtop -cp ../../MD/complex.prmtop -rp ../../MD/rec.prmtop -lp ../../MD/ligand.prmtop -y ../00.SUM/summd.mdcrd
	tail -f $MOLEKUL/$FILE	
	cd ../../
else
	source /usr/local/amber22/amber.sh
	$AMBERHOME/bin/MMPBSA.py -O -i ../../in/mmpbgbsa.in -o $FILE -sp ../../MD/complex-solvated.prmtop -cp ../../MD/complex.prmtop -rp ../../MD/rec.prmtop -lp ../../MD/ligand.prmtop -y ../00.SUM/summd.mdcrd
	tail -f $MOLEKUL/$FILE
fi	
	cd ../../


