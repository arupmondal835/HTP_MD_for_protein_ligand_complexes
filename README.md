
This repo has all the files needed for HTP MD for protein ligand complexes. As for example, we have top 10 ligand poses in ```base2042-iso0``` directory and the ```receptor.pdb``` is the receptor. Use ```grep "^ATOM" *.pdb >initial.pdb ; cd ..; done``` command to cleanup the receptor and then use the proper histidine state (if hidrogens are present in the receptor) using ```his_state.py```. 

Step1. Preprocess and parametrize the ligands:
----------------------------------------------

We need to first activate AMBER environment. Then run ```bash Preprocess/preprocess.sh``` followed by ```bash Preprocess/parameter.sh```. This will convert the ligand to the correct format and create parameters for them in the ```rank1_mod```, ```rank2_mod```, and ```rank3_mod``` directories. 

Step2. Generation input files and submit jobs:
----------------------------------------------

At this stage, we can run ```bash Setup_run/setup_submit.sh```. This will first use the ```Setup_run/tleap_0.in``` file to generate initial coordinates and parameter files for the protein-ligand complexes solvated in a waterbox. Then it will run ```parmed -i ../../Setup_run/hmass.in``` to perform hydrogen mass repartition that allows  to use a timestep of 4fs in amber simulations. Finally, it will run ```bash -i ../../Amber_scripts/chain.sh```, where it launch a chain jobs involving four different jobs: minimization (```min.sh```), heating (```heat.sh```), equilibration with CPU (```npt_cpu.sh```), and finally equilibation with GPU and production stage (```md.sh```). Notice that all the required input and submission files are in the ```Amber_scripts``` directory. After minimization, the minimized coordinates and the topologies are copied in 3 directories: ```trial_1```, ```trial_2```, and ```trial_3``` for running the simulations in triplicate.

Step3. Post-analysis:
--------------------

Once the simulations are done, we can run ```bash Postprocessing/post_processing.sh``` to do the postprocessing and analysis of the generated trajectories. First, this will run ```cpptraj -i ../../Postprocessing/cpptraj_strip.in``` to strip of the waters and ions from the initial tleap generated files to get initial protein-ligand docked complex that will be used as reference. ```cpptraj -i ../../../Postprocessing/cpptraj_strip_traj.in``` command will do the same stripping for the production trajectories and the topology generating ```protein.nc``` and ```protein.top```. ```cpptraj -i ../../../Postprocessing/cpptraj_rmsd.in``` will calulate the ligand RMSD of the trajectory taking the docked pose as the reference and ```cpptraj -i ../../../Postprocessing/cpptraj_rmsf.in``` will do the RMSF calculation for the CA atoms of the receptor. 

We can then use ```Postprocessing/rmsd_plot.py``` to plot the calculated RMSD values. We can modify it accordingly to plot the RMSD values. 

```Postprocessing/clustering.sh``` can be used to do the clustering combining all the poses and trials for a systems. This is generate ```Clustering``` directory where we have the top clusters as ```clusttraj*``` and the centroid of the clusters as ```unique.c*.pdb```. 







