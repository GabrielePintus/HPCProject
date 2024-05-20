/**
 * @file mandelbrot_distributed.c
 * @brief Mandelbrot set calculation using MPI and OpenMP.
 * 
 * This program calculates the Mandelbrot set using MPI and OpenMP. The program
 * is divided into two parts: the master process and the worker processes. The
 * master process is responsible for dividing the work into chunks and sending
 * them to the worker processes. The worker processes calculate the Mandelbrot
 * set for each chunk and send the results back to the master process.
 * Therefore the master process does not calculate the Mandelbrot set itself,
 * but it just waits for the results from the worker processes and saves the
 * final image to a PGM file.
 * 
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <omp.h>
#include <mpi.h>
#include <string.h>
#include <sys/queue.h>
#include <time.h>


// Mandelbrot set parameters
#define WIDTH 1024
#define HEIGHT 512

#define MAX_ITER 255

#define X_MIN -2.0
#define X_MAX 2.0
#define Y_MIN -2.0
#define Y_MAX 2.0


// OpenMP parameters
#define OMP_CHUNK_SIZE 4
#define OMP_NUM_THREADS 2

// MPI parameters
#define MPI_ROOT_PROCESS 0
#define MPI_CHUNK_SIZE 131072
#define TAG 0
#define MPI_STARTIDX_TAG 1



// Queue structures
/**
 *  @brief Work item
 */
typedef struct WorkItem{
    int start_idx;
    int end_idx;
    TAILQ_ENTRY(WorkItem) entries;
} WorkItem;

/**
 *  @brief Work queue
*/
typedef struct WorkQueue WorkQueue;

/**
 * @brief Queue definition.
 */
TAILQ_HEAD(WorkQueue, WorkItem);


// Mandelbrot data structures
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

    #pragma omp parallel for schedule(dynamic, OMP_CHUNK_SIZE)
    for (int i = start_idx; i < end_idx; ++i) {
        // get x and y coordinates
        const int x = i % WIDTH;
        const int y = i / WIDTH;

        // get complex point
        Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
        
        // compute mandelbrot set in the point
        int iter = mandelbrot(c) % MAX_ITER;
        
        // store the value
        image[i - start_idx] = iter;
    }
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
    // Set the number of threads for OpenMP
    omp_set_num_threads(OMP_NUM_THREADS);
    printf("Number of threads: %d\n", OMP_NUM_THREADS);

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
    const int n_chunks = (total_size + MPI_CHUNK_SIZE - 1) / MPI_CHUNK_SIZE;
    int completed_chunks = 0;
    uint8_t* processes_status = NULL;
    WorkQueue* work_queue = NULL;
    uint8_t* image = NULL;


    // Initialize memory for the processes status and the image
    if (rank == MPI_ROOT_PROCESS) {
        processes_status = (uint8_t *)calloc(size, sizeof(uint8_t));
        image = (uint8_t *)malloc(total_size * sizeof(uint8_t));
    }

    // Create the work queue
    if (rank == MPI_ROOT_PROCESS) {
        work_queue = (WorkQueue *)malloc(sizeof(WorkQueue));
        TAILQ_INIT(work_queue);

        // Add work items to the queue
        for (int i = 0; i < n_chunks; ++i) {
            WorkItem *item = (WorkItem *)malloc(sizeof(WorkItem));
            item->start_idx = i * MPI_CHUNK_SIZE;
            item->end_idx = (i + 1) * MPI_CHUNK_SIZE;
            if (item->end_idx > total_size) {
                item->end_idx = total_size;
            }
            TAILQ_INSERT_TAIL(work_queue, item, entries);
        }
    }


    // Main loop
    if (rank == MPI_ROOT_PROCESS) {
        while (completed_chunks < n_chunks) {
            // Check for incoming messages
            MPI_Status status;
            int flag;
            MPI_Iprobe(MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &flag, &status);
            if (flag) {
                // Receive the data
                int source = status.MPI_SOURCE;
                // int start_idx = status.MPI_TAG;
                int start_idx;
                MPI_Recv(&start_idx, 1, MPI_INT, source, MPI_STARTIDX_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                MPI_Recv(
                    image + start_idx, // Here we are using the pointer arithmetic to get the correct position in the image buffer
                    MPI_CHUNK_SIZE,
                    MPI_UNSIGNED_CHAR,
                    source,
                    MPI_ANY_TAG,
                    MPI_COMM_WORLD,
                    MPI_STATUS_IGNORE
                );
                processes_status[source] = 0;
                completed_chunks++;
            }

            // Send work to idle processes
            // Notice that we start from 1 because the root process is not a worker
            for (int i = 1; i < size; ++i) {
                if (processes_status[i] == 0) {
                    WorkItem *item = TAILQ_FIRST(work_queue);
                    if (item != NULL) {
                        TAILQ_REMOVE(work_queue, item, entries);
                        MPI_Send(&item->start_idx, 1, MPI_INT, i, TAG, MPI_COMM_WORLD);
                        MPI_Send(&item->end_idx, 1, MPI_INT, i, TAG, MPI_COMM_WORLD);
                        processes_status[i] = 1;
                        free(item);
                    }else{
                        int end_idx = -1;
                        MPI_Send(&end_idx, 1, MPI_INT, i, TAG, MPI_COMM_WORLD);
                        MPI_Send(&end_idx, 1, MPI_INT, i, TAG, MPI_COMM_WORLD);
                    }
                }
            }
        }
    } else {
        while (1) {
            // Receive the work item
            int start_idx, end_idx;
            MPI_Recv(&start_idx, 1, MPI_INT, MPI_ROOT_PROCESS, TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            MPI_Recv(&end_idx, 1, MPI_INT, MPI_ROOT_PROCESS, TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

            // Check for termination
            if (start_idx == -1 || end_idx == -1) {
                printf("Process %d finished\n", rank);
                break;
            }

            // Allocate memory for the buffer
            uint8_t *buffer = (uint8_t *)calloc(MPI_CHUNK_SIZE, sizeof(uint8_t));

            // Generate the Mandelbrot set
            mandelbrot_set(buffer, start_idx, end_idx);

            // Send the data back to the root process
            MPI_Send(&start_idx, 1, MPI_INT, MPI_ROOT_PROCESS, MPI_STARTIDX_TAG, MPI_COMM_WORLD);
            MPI_Send(buffer, MPI_CHUNK_SIZE, MPI_UNSIGNED_CHAR, MPI_ROOT_PROCESS, TAG, MPI_COMM_WORLD);
            free(buffer);
        }
    }
    
    

    // Save the image to a PGM file
    if (rank == MPI_ROOT_PROCESS) {
        free(work_queue);
        save_image("mandelbrot.pgm", image, WIDTH, HEIGHT);
        free(image);
    }

    // Finalize MPI
    MPI_Finalize();


    return 0;
}




