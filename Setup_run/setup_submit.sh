for i in base*
do 
	cd $i 
	for j in rank*_mod
	do 
		cd $j
		tleap -f ../../Setup_run/tleap_0.in 
		parmed -i ../../Setup_run/hmass.in 
		bash -i ../../Amber_scripts/chain.sh 
		cd ..
	done
	cd .. 
done


