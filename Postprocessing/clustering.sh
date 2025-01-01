#!/bin/bash
#SBATCH --account=brave
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=shared
#SBATCH --time=4:00:00
#SBATCH --job-name=min
#SBATCH --out=slurm%j.out
#SBATCH --mem-per-cpu=10GB


module purge
module load mamba cuda/12.2
source /projects/robustmicrob/jlaw/tools/amber24/amber.sh

mkdir Clustering
cd Clustering


#cluster
cpptraj ../rank1_mod/trial_1/protein.top
cat<<EFO>cpptraj.in

trajin ../rank1_mod/trial_1/protein.nc 1 10000 
trajin ../rank1_mod/trial_2/protein.nc 1 10000 
trajin ../rank1_mod/trial_3/protein.nc 1 10000 
trajin ../rank2_mod/trial_1/protein.nc 1 10000 
trajin ../rank2_mod/trial_2/protein.nc 1 10000 
trajin ../rank2_mod/trial_3/protein.nc 1 10000 
trajin ../rank3_mod/trial_1/protein.nc 1 10000 
trajin ../rank3_mod/trial_2/protein.nc 1 10000 
trajin ../rank3_mod/trial_3/protein.nc 1 10000 

rms first :1-167@CA,CB  out trajrmsd.dat

cluster hieragglo epsilon 2.0 linkage rms :168 nofit sieve 10 summary summary singlerepout representative repout unique repfmt pdb clusterout clusttraj clusterfmt netcdf avgout avg avgfmt pdb out frame_vs_cluster.txt
go
EFO

cpptraj -p ../rank1_mod/trial_1/protein.top -i cpptraj.in
cd ../



