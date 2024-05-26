gcc -c -S mandelbrot.c -o mandelbrot_3.s -fopenmp -lmath -O3
gcc -c -S mandelbrot.c -o mandelbrot_none.s -fopenmp -lmath

