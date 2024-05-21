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
#include <unistd.h>
#include <string.h>
#include <sys/queue.h>
#include <time.h>


// Mandelbrot set parameters
// #define WIDTH 1024
// #define HEIGHT 512

// #define MAX_ITER 16384

// #define X_MIN -2.0
// #define X_MAX 2.0
// #define Y_MIN -2.0
// #define Y_MAX 2.0


// OpenMP parameters
#define OMP_CHUNK_SIZE 4
// #define OMP_NUM_THREADS 6

// MPI parameters
#define MPI_ROOT_PROCESS 0
// #define MPI_CHUNK_SIZE 131072
#define MPI_CHUNK_SIZE 4096

#define TAG 0
#define MPI_STARTIDX_TAG 1
#define MPI_ENDIDX_TAG 2



// typedef uint8_t image_t;
typedef uint16_t image_t;


// Queue structures
/**
 *  @brief Work item
 */
typedef struct WorkItem{
    uint32_t start_idx;
    uint32_t end_idx;
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
int mandelbrot(const Complex c, const uint32_t max_iter){
    uint32_t n = 0;
    Complex z = {0, 0};
    while ((z.x * z.x + z.y * z.y) < 4 && n < max_iter) {
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
void mandelbrot_set(
    image_t *image,
    const int start_idx,
    const int end_idx,
    const uint32_t max_iter,
    const uint32_t width,
    const uint32_t height,
    const double x_min,
    const double x_max,
    const double y_min,
    const double y_max
){
    const double dx = (x_max - x_min) / width;
    const double dy = (y_max - y_min) / height;

    #pragma omp parallel for schedule(dynamic, OMP_CHUNK_SIZE)
    for (int i = start_idx; i < end_idx; ++i) {
        // get x and y coordinates
        const int x = i % width;
        const int y = i / width;

        // get complex point
        Complex c = {x_min + x * dx, y_min + y * dy};
        
        // compute mandelbrot set in the point
        int iter = mandelbrot(c, max_iter) % max_iter;
        
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
void save_image(const char *filename, const image_t *image, const int width, const int height)
{
    FILE *fp;
    fp = fopen(filename, "wb");
    if (fp == NULL) {
        fprintf(stderr, "Error opening file\n");
        return;
    }
    const uint8_t n_bits = 8 * sizeof(image_t);
    const uint16_t max_value = (1 << n_bits) - 1;
    fprintf(fp, "P5\n%d %d\n%d\n", width, height, max_value);
    fwrite(image, sizeof(image_t), width * height, fp);
    fclose(fp);
}

/**
 * @brief Main function.
 * 
 * @param argc The number of command-line arguments.
 * @param argv The command-line arguments.
 * @return The exit status.
*/
int main(int argc, char *argv[])
{
    /**
     * Parse the command-line arguments.
     * 1 - Width of the image
     * 2 - Height of the image
     * 3 - X-axis lower bound
     * 4 - Y-axis lower bound
     * 5 - X-axis upper bound
     * 6 - Y-axis upper bound
     * 7 - Maximum number of iterations
    */
    uint32_t WIDTH, HEIGHT, MAX_ITER;
    double X_MIN, Y_MIN, X_MAX, Y_MAX;
    if (argc != 8) {
        fprintf(stderr, "Usage: %s <width> <height> <x_min> <y_min> <x_max> <y_max> <max_iter>\n", argv[0]);
        return 1;
    } else {
        WIDTH = atoi(argv[1]);
        HEIGHT = atoi(argv[2]);
        X_MIN = atof(argv[3]);
        Y_MIN = atof(argv[4]);
        X_MAX = atof(argv[5]);
        Y_MAX = atof(argv[6]);
        MAX_ITER = atoi(argv[7]);
    }

    // Set the number of threads for OpenMP
    // omp_set_num_threads(OMP_NUM_THREADS);
    

    // First thing to do is to calculate the total size of the image
    const uint32_t total_size = WIDTH * HEIGHT;

    // Initialize MPI
    int32_t rank, size;
    MPI_Init(&argc, &argv, MPI_THREAD_FUNNELED);

    MPI_Datatype MPI_IMAGE_T;
    if (sizeof(image_t) == 1) {
        MPI_Type_contiguous(1, MPI_UINT8_T, &MPI_IMAGE_T);
    } else if (sizeof(image_t) == 2) {
        MPI_Type_contiguous(1, MPI_UINT16_T, &MPI_IMAGE_T); 
    }
    MPI_Type_commit(&MPI_IMAGE_T);

    // Get the rank and the number of processes in the MPI_COMM_WORLD communicator
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Set the number of threads
    // omp_set_num_threads(OMP_NUM_THREADS);

    // Print args
    if (rank == MPI_ROOT_PROCESS) {
        // printf("Number of threads: %d\n", OMP_NUM_THREADS);
        printf("Rank: %d, Size: %d\n", rank, size);
        printf("Width: %d, Height: %d, Max Iter: %d\n", WIDTH, HEIGHT, MAX_ITER);
        printf("X_MIN: %f, Y_MIN: %f, X_MAX: %f, Y_MAX: %f\n", X_MIN, Y_MIN, X_MAX, Y_MAX);
    }


    // Memory Variables
    const uint32_t n_chunks = (total_size + MPI_CHUNK_SIZE - 1) / MPI_CHUNK_SIZE;
    uint32_t completed_chunks = 0;
    uint32_t available_chunks = n_chunks;
    uint8_t* processes_status = NULL;
    image_t* image = NULL;
    WorkQueue* work_queue = NULL;
    


    // Initialize memory for the processes status and the image
    if (rank == MPI_ROOT_PROCESS) {
        processes_status = (uint8_t *)calloc(size, sizeof(uint8_t));
        image = (image_t *)malloc(total_size * sizeof(image_t));
    }

    // Create the work queue
    if (rank == MPI_ROOT_PROCESS) {
        work_queue = (WorkQueue *)malloc(sizeof(WorkQueue));
        TAILQ_INIT(work_queue);
        // Add work items to the queue
        for (uint32_t i = 0; i < n_chunks; ++i) {
            WorkItem *item = (WorkItem *)malloc(sizeof(WorkItem));
            item->start_idx = i * MPI_CHUNK_SIZE;
            item->end_idx = (i + 1) * MPI_CHUNK_SIZE;
            if (item->end_idx > total_size) {
                item->end_idx = total_size;
            }
            TAILQ_INSERT_TAIL(work_queue, item, entries);
        }
    }

    // Barrier to synchronize all processes
    MPI_Barrier(MPI_COMM_WORLD);
    // Overall computation time
    double before_entire_computation = MPI_Wtime();


    // Main loop
    if (rank == MPI_ROOT_PROCESS) {
        while (completed_chunks < n_chunks) {
            // Send work to idle processes
            // Notice that we start from 1 because the root process is not a worker
            for (uint16_t i = 1; i < size; ++i) {
                if (processes_status[i] == 1){
                    // Check for incoming messages
                    MPI_Status status;
                    int32_t flag;
                    MPI_Iprobe(i, MPI_STARTIDX_TAG, MPI_COMM_WORLD, &flag, &status);
                    if (flag) {
                        uint32_t start_idx, end_idx;
                        // Receive the data
                        MPI_Recv(&start_idx, 1, MPI_INT, i, MPI_STARTIDX_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                        MPI_Recv(&end_idx, 1, MPI_INT, i, MPI_ENDIDX_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                        MPI_Recv(
                            image + start_idx, // Here we are using the pointer arithmetic to get the correct position in the image buffer
                            end_idx - start_idx,
                            MPI_IMAGE_T,
                            i,
                            TAG,
                            MPI_COMM_WORLD,
                            MPI_STATUS_IGNORE
                        );
                        processes_status[i] = 0;
                        ++completed_chunks;
                    }
                }
                if (processes_status[i] == 0) {
                    WorkItem *item = TAILQ_FIRST(work_queue);
                    if (item != NULL) {
                        TAILQ_REMOVE(work_queue, item, entries);

                        MPI_Send(&item->start_idx, 1, MPI_INT, i, MPI_STARTIDX_TAG, MPI_COMM_WORLD);
                        MPI_Send(&item->end_idx, 1, MPI_INT, i, MPI_ENDIDX_TAG, MPI_COMM_WORLD);

                        --available_chunks;
                        processes_status[i] = 1;
                        free(item);
                    }else{
                        int end_idx = -1;
                        MPI_Send(&end_idx, 1, MPI_INT, i, MPI_STARTIDX_TAG, MPI_COMM_WORLD);
                        MPI_Send(&end_idx, 1, MPI_INT, i, MPI_ENDIDX_TAG, MPI_COMM_WORLD);
                    }
                }
            }

            // The master also needs to do some work
            if (available_chunks > 0)
            {
                double before_computation = MPI_Wtime();
                WorkItem *item = TAILQ_FIRST(work_queue);
                image_t *buffer = (image_t *)calloc(item->end_idx - item->start_idx, sizeof(image_t));
                if (item != NULL) {
                    TAILQ_REMOVE(work_queue, item, entries);
                    mandelbrot_set(buffer, item->start_idx, item->end_idx, MAX_ITER, WIDTH, HEIGHT, X_MIN, X_MAX, Y_MIN, Y_MAX);
                    memcpy(image + item->start_idx, buffer, (item->end_idx - item->start_idx) * sizeof(image_t));
                    free(item);
                    ++completed_chunks;
                }
                --available_chunks;
                double after_computation = MPI_Wtime();
                printf("Process %d: Computation time: %f\n", rank, after_computation - before_computation);
            }
            

            // Wait 1ms before checking again 
            // nanosleep((const struct timespec[]){{0, 1000000L}}, NULL);
        }
    } else {
        while (1) {
            // Receive the work item
            int start_idx, end_idx;
            MPI_Recv(&start_idx, 1, MPI_INT, MPI_ROOT_PROCESS, MPI_STARTIDX_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            MPI_Recv(&end_idx, 1, MPI_INT, MPI_ROOT_PROCESS, MPI_ENDIDX_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

            // Check for termination
            if (start_idx == -1 || end_idx == -1) {
                break;
            }

            // Allocate memory for the buffer
            image_t *buffer = (image_t *)calloc(end_idx - start_idx, sizeof(image_t));

            // Generate the Mandelbrot set
            double before_computation = MPI_Wtime();
            mandelbrot_set(buffer, start_idx, end_idx, MAX_ITER, WIDTH, HEIGHT, X_MIN, X_MAX, Y_MIN, Y_MAX);
            double after_computation = MPI_Wtime();
            printf("Process %d: Computation time: %f\n", rank, after_computation - before_computation);

            // Send the data back to the root process
            MPI_Send(&start_idx, 1, MPI_INT, MPI_ROOT_PROCESS, MPI_STARTIDX_TAG, MPI_COMM_WORLD);
            MPI_Send(&end_idx, 1, MPI_INT, MPI_ROOT_PROCESS, MPI_ENDIDX_TAG, MPI_COMM_WORLD);
            MPI_Send(buffer, end_idx-start_idx, MPI_IMAGE_T, MPI_ROOT_PROCESS, TAG, MPI_COMM_WORLD);
            
            free(buffer);
        }
    }
    
    // Overall computation time
    double after_entire_computation = MPI_Wtime();
    double entire_computation_time = after_entire_computation - before_entire_computation;
    printf("Process %d: Entire computation time: %f\n", rank, entire_computation_time);


    // Save the image to a PGM file
    if (rank == MPI_ROOT_PROCESS) {
        free(work_queue);
        // filename
        char filename[100];
        sprintf(filename, "mandelbrot_%dx%d_%d.pgm", WIDTH, HEIGHT, size);
        save_image(filename, image, WIDTH, HEIGHT);
        free(image);
    }

    // Finalize MPI
    MPI_Finalize();


    return 0;
}




