#!/bin/bash

#SBATCH --job-name=broadcast
#SBATCH --nodes=2
#SBATCH --time=60
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=scatter-job.out


for core in $(seq 0 23 1)
do
    mpirun -np 2 --map-by core --cpu-list 0,$core ./osu-benchmark-tools/osu_scatter --full --tail-lat --iterations 1000 --warmup 100 --message-size 1:1048576 -f csv >> output_data/latency/scat_{$core}.csv
done


