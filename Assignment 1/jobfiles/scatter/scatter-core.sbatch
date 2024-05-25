#!/bin/bash

#SBATCH --job-name=scat-core
#SBATCH --nodes=2
#SBATCH --time=120
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --exclusive
#SBATCH --output=scatter-core-job.out


for algorithm in 1 2
do
    for np in $(seq 2 2 48)
    do
        mpirun -np $np --map-by core --mca coll_tuned_use_dynamic_rules true --mca coll_tuned_scatter_algorithm $algorithm ../../osu-benchmark-tools/osu_scatter --full --tail-lat --iterations 7000 --warmup 700 --message-size 5242880:5242880 -f csv >> ../../output_data/scatter/scat_core_{$np}_{$algorithm}.csv
    done
done


