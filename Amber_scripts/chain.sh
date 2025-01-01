#!/bin/bash

mkdir trial_1 trial_2 trial_3

script=../../Amebr_scirpts/min.sh

PID0=$(sbatch $script|awk '{print $NF}')
echo $PID0



for i in trial_1 trial_2 trial_3
do
cd $i

script=../../../Amebr_scirpts/heat.sh

PID_1=$(sbatch --dependency=afterany:$PID0  $script| awk '{print $NF}')
echo $PID_1

script=../../../Amebr_scirpts/npt_cpu.sh

PID_2=$(sbatch --dependency=afterany:$PID_1  $script| awk '{print $NF}')
echo $PID_2

script=../../../Amebr_scirpts/md.sh

PID_3=$(sbatch --dependency=afterany:$PID_2  $script| awk '{print $NF}')
echo $PID_3

cd ..
done

