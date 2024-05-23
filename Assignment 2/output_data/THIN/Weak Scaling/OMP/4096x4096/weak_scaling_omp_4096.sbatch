#!/bin/bash
#SBATCH --job-name=mandelbrot_distributed_thin
#SBATCH --account=dssc
#SBATCH --partition=THIN
#SBATCH --nodes=1
#SBATCH --time=120
#SBATCH --output=mandelbrot_mpi_%j.txt
#SBATCH --exclusive

# Load architecture
module load "architecture/Intel"

# Load OpenMPI module
module load "openMPI/4.1.5/gnu/12.2.1"

# Run the program
export OMP_NUM_THREADS=1

counter=1
values=(4096 5793 7094 8192 9159 10033 10837 11585 12288 12953 13585 14189 14768 15326 15864 16384 16888 17378 17854 18318 18770 19212 19644 20066)

for value in "${values[@]}"
do
    export OMP_NUM_THREADS=$counter
    mpiexec -np 1 --map-by socket --bind-to socket ./mandelbrot $value $value -2 -2 2 2 65535 >> mandelbrot_weak_omp_4096_$counter.log
    ((counter++))
done

