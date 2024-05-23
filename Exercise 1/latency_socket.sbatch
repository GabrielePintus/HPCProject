#!/bin/bash
#SBATCH --job-name=broadcast
#SBATCH --nodes=1
#SBATCH --time=60
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=latency-socket-job.out


for core in $(seq 0 23)
do
    mpirun -np 2 --cpu-list 0,$core ./osu-benchmark-tools/osu_scatter --full --tail-lat --iterations 1000 --warmup 100 --message-size 1:1048576 -f csv >> output_data/latency/latency_socket_{$core}.csv
done

