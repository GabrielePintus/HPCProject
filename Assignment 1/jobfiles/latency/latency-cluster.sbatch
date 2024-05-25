#!/bin/bash
#SBATCH --job-name=lat-cluster
#SBATCH --nodes=2
#SBATCH --time=60
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=latency-cluster-job.out

#for core in $(seq 0 1)
#do
	mpirun --rankfile rankfiles/rankfile-cluster.txt -np 2 ../../osu-benchmark-tools/osu_latency --tail-lat --iterations 100 --warmup 10 --message-size 1:1048576 >> ../../output_data/latency/cluster/latency_cluster_010110.csv
#done
