#!/bin/bash

#SBATCH --job-name=bcast-core
#SBATCH --nodes=2
#SBATCH --time=120
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=broadcast-core-job.out



for np in $(seq 2 2 48)
do
    for algorithm in 1 2 5 6
    do
        mpirun -np $np --map-by core --mca coll_tuned_use_dynamic_rules true --mca coll_tuned_bcast_algorithm $algorithm ../../osu-benchmark-tools/osu_bcast --full --tail-lat --iterations 10000 --warmup 1000 --message-size 1:1048576 -f csv >> ../../output_data/broadcast/bcast_core_{$np}_{$algorithm}.csv

    done
done


