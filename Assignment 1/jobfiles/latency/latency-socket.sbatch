#!/bin/bash
#SBATCH --job-name=lat-socket
#SBATCH --nodes=1
#SBATCH --time=60
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=latency-socket-job.out

for core in $(seq 0 11)
do
	mpirun -np 2 --cpu-set 0,$core ../../osu-benchmark-tools/osu_latency --tail-lat --iterations 100 --warmup 10 --message-size 1:1048576 >> ../../output_data/latency/socket/latency_socket_$core.csv
done
