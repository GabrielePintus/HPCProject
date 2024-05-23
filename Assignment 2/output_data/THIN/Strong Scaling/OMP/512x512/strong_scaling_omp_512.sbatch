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
for i in $(seq 1 24)
do    
    # Calculate number of processes per node
    export OMP_NUM_THREADS=$i
    mpiexec -np 1 --map-by socket --bind-to socket ./mandelbrot 512 512 -2 -2 2 2 65535 >> mandelbrot_strong_omp_512_$i.log
done


