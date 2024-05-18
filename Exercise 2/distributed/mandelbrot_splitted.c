#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <omp.h>
#include <mpi.h>
#include <string.h>


// Mandelbrot set parameters
#define WIDTH 256
#define HEIGHT 512

#define MAX_ITER 65535

#define X_MIN -2.0
#define X_MAX 2.0
#define Y_MIN -2.0
#define Y_MAX 2.0


// OpenMP parameters
#define CHUNK_SIZE 4  // cache miss rate 0.6




/**
 * @brief A complex number.
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
void mandelbrot_set(uint8_t *image, const int start_idx, const int end_idx)
{
    const double dx = (X_MAX - X_MIN) / WIDTH;
    const double dy = (Y_MAX - Y_MIN) / HEIGHT;

    #pragma omp parallel for schedule(dynamic, CHUNK_SIZE)
    for (int i = start_idx; i < end_idx; ++i) {
        // get x and y coordinates
        const int x = i % WIDTH;
        const int y = i / WIDTH;

        // get complex point
        Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
        
        // compute mandelbrot set in the point
        int iter = mandelbrot(c) % MAX_ITER;
        // iter = iter % MAX_ITER;
        
        // store the value
        image[i - start_idx] = iter;
    }
}


/**
 * @brief Allocate memory for the image.
 *
 * @param width The width of the image.
 * @param height The height of the image.
 * @return A pointer to the image data.
 */
// uint8_t* allocate_image(const int width, const int height)
// {
//     uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
//     return image;
// }
uint8_t* allocate_image(const int size)
{
    uint8_t *image = (uint8_t *)calloc(size, sizeof(uint8_t));
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

    // First thing to do is to calculate the total size of the image
    const int total_size = WIDTH * HEIGHT;

    // Initialize MPI
    int rank, size;
    MPI_Init(&argc, &argv);

    // Get the rank and the number of processes in the MPI_COMM_WORLD communicator
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    printf("Rank: %d, Size: %d\n", rank, size);

    // Memory Variables
    int task_size = total_size / size;
    int remainder = total_size % size;
    task_size += (rank < remainder) ? 1 : 0; // Distribute the remainder among the first processes

    // Compute the index range assigned to each process
    int start_idx = rank * task_size;
    int end_idx = start_idx + task_size;

    // Allocate memory for the image in each process
    puts("Allocating memory for the buffer");
    uint8_t *buffer = NULL;
    if (rank == 0) {
        buffer = (uint8_t *)calloc(total_size, sizeof(uint8_t));
    } else {
        buffer = (uint8_t *)calloc(task_size, sizeof(uint8_t));
    }
    printf("Rank: %d, buffer size: %lu bytes\n", rank, sizeof(buffer));

    // Generate the Mandelbrot set
    puts("Generating the Mandelbrot set");
    mandelbrot_set(buffer, start_idx, end_idx);

    // Compute the recvcounts and displs arrays for MPI_Gatherv
    puts("Computing the recvcounts and displs arrays");
    int *recvcounts = (int *)calloc(size, sizeof(int));
    int *displs     = (int *)calloc(size, sizeof(int));
    int sum = 0;
    for (int i = 0; i < size; ++i) {
        recvcounts[i] = task_size;
        displs[i] = sum;
        sum += recvcounts[i];
    }


    // Gather the image data from all processes
    puts("Allocating memory for the image");
    // uint8_t *image = NULL;
    // if (rank == 0) {
    //     image = (uint8_t *)calloc(total_size, sizeof(uint8_t));
    // }
    uint8_t *image = NULL;
    if (rank == 0) {
        image = buffer;
    }

    // Gather the image data from all processes
    puts("Gathering the image data from all processes");
    MPI_Gatherv(buffer, task_size, MPI_UNSIGNED_CHAR, image, recvcounts, displs, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);

    // Free the memory allocated for the image buffer
    free_image(buffer);
    // Free the memory allocated for the sendcounts and displs arrays
    free(recvcounts);
    free(displs);

    // Save the image to a PGM file
    if (rank == 0) {
        save_image("mandelbrot.pgm", image, WIDTH, HEIGHT);
    }

    // Free the memory allocated for the image
    // free_image(image);

    // Finalize MPI
    MPI_Finalize();


    return 0;
}




