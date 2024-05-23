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
values=(512 724 887 1024 1145 1254 1354 1447 1535 1618 1697 1772 1844 1914 1981 2046 2109 2170 2229 2287 2343 2398 2452 2505)

for value in "${values[@]}"
do
    export OMP_NUM_THREADS=$counter

    mpiexec -np 1 --map-by socket --bind-to socket ./mandelbrot $value $value -2 -2 2 2 65535 >> mandelbrot_weak_omp_512_$counter.log

    ((counter++))
done

