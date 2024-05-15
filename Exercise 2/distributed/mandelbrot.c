#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <omp.h>
#include <mpi.h>


// Mandelbrot set parameters
#define WIDTH 513
// #define WIDTH_EXP 12
#define HEIGHT 512
// #define HEIGHT_EXP 12

#define MAX_ITER 65535

#define X_MIN -2.0
#define X_MAX 2.0
#define Y_MIN -2.0
#define Y_MAX 2.0


// OpenMP parameters
#define CHUNK_SIZE 1  // cache miss rate 0.6




/**
 * @brief The width of the image.
 */
typedef struct {
    double x;
    double y;
} Complex;


/**
 * @brief Calculate the Mandelbrot set.
 *
 * @param c A complex number.
 * @return The number of iterations before the sequence escapes.
 */
int mandelbrot(const Complex c) {
    int n = 0;
    Complex z = {0, 0};
    // while (n < MAX_ITER && (z.x * z.x + z.y * z.y) < 4) {
    while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
        double temp = z.x * z.x - z.y * z.y + c.x;
        z.y = 2 * z.x * z.y + c.y;
        z.x = temp;
        ++n;
    }
    return n;
}

/**
 * @brief Generate the Mandelbrot set.
 *
 * @param image A pointer to the image data.
 */
void mandelbrot_set(uint8_t *image, const int start_row, const int end_row)
{
    const double dx = (X_MAX - X_MIN) / WIDTH;
    const double dy = (Y_MAX - Y_MIN) / HEIGHT;
    const int total_size = (end_row - start_row)*WIDTH;

    // #pragma omp parallel for schedule(dynamic, CHUNK_SIZE)
    // for (int i = start_row; i < end_row; i++) {
    //     for (int j = 0; j < WIDTH; j++) {
    //         Complex c = {X_MIN + i * dx, Y_MIN + j * dy};
    //         int iter = mandelbrot(c);
    //         iter = iter % MAX_ITER;
    //         image[(i - start_row) * WIDTH + j] = iter;
    //     }
    // }
    #pragma omp parallel for schedule(dynamic, CHUNK_SIZE)
    for(int i=0; i<total_size; ++i){
        // get row and col
        int x = i / HEIGHT;
        // int x = i >> WIDTH_EXP; 
        int y = i % HEIGHT;
        // int y = i & (HEIGHT-1); 

        // get complex point
        Complex c = {X_MIN + (x + start_row) * dx, Y_MIN + y * dy};
        
        // compute mandelbrot set in the point
        int iter = mandelbrot(c);
        iter = iter % MAX_ITER;
        
        // store the value
        image[i] = iter;
    }


}





/**
 * @brief Allocate memory for the image.
 *
 * @param width The width of the image.
 * @param height The height of the image.
 * @return A pointer to the image data.
 */
uint8_t* allocate_image(const int width, const int height)
{
    uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
    return image;
}

/**
 * @brief Free the memory allocated for the image.
 *
 * @param image A pointer to the image data.
 */
void free_image(uint8_t *image)
{
    free(image);
}

/**
 * @brief Save the image data to a PGM file using 1D array.
 *
 * @param filename The name of the output file.
 * @param image A pointer to the image data.
 * @param width The width of the image.
 * @param height The height of the image.
 */
void save_image(const char *filename, const uint8_t *image, const int width, const int height)
{
    FILE *fp;
    fp = fopen(filename, "wb");
    if (fp == NULL) {
        fprintf(stderr, "Error opening file\n");
        return;
    }
    fprintf(fp, "P5\n%d %d\n255\n", width, height);
    fwrite(image, sizeof(uint8_t), width * height, fp);
    fclose(fp);
}





int main(int argc, char *argv[])
{
    #ifdef _OPENMP
    #define NUM_THREADS 2
    omp_set_num_threads(NUM_THREADS);
    printf("Number of threads: %d\n", NUM_THREADS);
    #endif
    // Memory Variables
    const int total_size = WIDTH * HEIGHT;
    const int task_size = total_size / NUM_THREADS;
    const int remainder = total_size % NUM_THREADS;


    // Initialize MPI
    int rank, size;
    MPI_Init(&argc, &argv);

    // Get the rank and the number of processes in the MPI_COMM_WORLD communicator
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    printf("Rank: %d, Size: %d\n", rank, size);

    // Compute the rows assigned to each process
    puts("Computing rows assigned to each process...");
    const int start_row = rank * task_size;
    const int end_row = start_row + task_size + (rank < remainder ? 1 : 0);
    const int task_mem = (end_row - start_row) * WIDTH;
    printf("Rank: %d, Task memory: %d\n", rank, task_mem);
    // Allocate memory for the task
    puts("Allocating memory...");
    uint8_t *buffer = (uint8_t *)calloc(task_mem, sizeof(uint8_t));


    // Compute Mandelbrot set for assigned rows
    puts("Computing Mandelbrot set...");
    mandelbrot_set(buffer, start_row, end_row);

    uint8_t *final_image = NULL;
    // Gather results from all processes
    if (rank == 0) {    
        // This is executed by the root process
        puts("Gathering results...");

        final_image = (uint8_t *)calloc(WIDTH * HEIGHT, sizeof(uint8_t));
        
        if (final_image == NULL) {
            fprintf(stderr, "Memory allocation failed for the final image\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
    }

    int *recvcounts = (int *)malloc(size * sizeof(int));
    int *displs = (int *)malloc(size * sizeof(int));
    int sum = 0;
    for (int i = 0; i < size; i++) {
        recvcounts[i] = (total_size / size) + (i < (total_size % size) ? 1 : 0);
        displs[i] = sum;
        sum += recvcounts[i];
    }

    // Gather the results
    MPI_Gatherv(buffer, task_mem, MPI_UNSIGNED_CHAR, final_image, recvcounts, displs, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);
    

    // Free the memory allocated for the task
    free(buffer);



    // Finalize MPI
    MPI_Finalize();


    // Save the image to a file
    puts("Saving image...");
    if (rank == 0) {
        save_image("mandelbrot.pgm", final_image, WIDTH, HEIGHT);
        free(final_image);
    }

    // Free the image memory
    // puts("Freeing memory...");
    // free(buffer);

    return 0;
}




