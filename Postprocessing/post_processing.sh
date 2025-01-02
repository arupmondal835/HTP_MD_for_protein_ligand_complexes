for i in base*
do 
	cd $i 
	for j in rank1_mod rank2_mod rank3_mod
	do
		cd $j
		cpptraj -i ../../Postprocessing/cpptraj_strip.in
		for k in trial_1 trial_2 trial_3
		do
			cd $k
		        cpptraj -i ../../../Postprocessing/cpptraj_strip_traj.in
			cpptraj -i ../../../Postprocessing/cpptraj_rmsd.in
                        cpptraj -i ../../../Postprocessing/cpptraj_rmsf.in
			cd ..
		done
		cd ..
	done
	cd .. 
done


