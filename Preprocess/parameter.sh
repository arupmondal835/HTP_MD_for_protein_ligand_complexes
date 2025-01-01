for j in base*
do
	cd $j

        for i in rank1_mod rank2_mod rank3_mod
	do
		mkdir $i
		cd $i
		antechamber -i ../${i}.pdb -fi pdb -o ligand.mol2 -fo mol2 -c bcc -s 2 -at gaff2
        	parmchk2 -i ligand.mol2 -f mol2 -o ligand.frcmod
        	tleap -f ../../Preprocess/tleap.in
		cd ..
	done
	cd ..
done
