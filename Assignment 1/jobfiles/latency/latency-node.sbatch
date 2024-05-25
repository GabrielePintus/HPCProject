#!/bin/bash
#SBATCH --job-name=lat-node
#SBATCH --nodes=1
#SBATCH --time=60
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=latency-node-job.out

#for core in $(seq 0 1)
#do
	mpirun --rankfile rankfiles/rankfile-node.txt -np 2 ../../osu-benchmark-tools/osu_latency --tail-lat --iterations 100 --warmup 10 --message-size 1:1048576 >> ../../output_data/latency/node/latency_node_00110.csv
#done
