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

#define MAX_ITER 65535

#define X_MIN -2.0
#define X_MAX 2.0
#define Y_MIN -2.0
#define Y_MAX 2.0


// OpenMP parameters
#define OMP_CHUNK_SIZE 4  // cache miss rate 0.6
#define OMP_NUM_THREADS 2

// MPI parameters
#define MPI_ROOT_PROCESS 0
#define MPI_CHUNK_SIZE 131072
#define TAG 0
#define MPI_STOP_TAG 1


/**
 * @brief Buffer type.
*/
typedef uint8_t buffer_t;

/**
 * @brief A complex number.
 */
typedef struct {
    double x;
    double y;
} Complex;

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
        // iter = iter % MAX_ITER;
        
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






int distribution_loop(uint8_t *processes_status, const int size, WorkQueue *work_queue){
    if (TAILQ_EMPTY(work_queue)) {
        // Send stop signal to ended processes
        // Notice that the root process is not included
        for (int i = 1; i < size; ++i) {
            if (processes_status[i] == 1) {
                printf("Sending stop signal to process %d\n", i);
            }
        }
    }else{
        // Send work items to free processes
        // Notice that the root process is not included
        for (int i = 1; i < size; ++i) {
            if (processes_status[i] == 0) {
                // Get the first work item from the queue
                WorkItem *work_item = TAILQ_FIRST(work_queue);
                TAILQ_REMOVE(work_queue, work_item, entries);

                // Send the work item to the process
                MPI_Send(work_item, sizeof(WorkItem), MPI_BYTE, i, TAG, MPI_COMM_WORLD);

                // Free the memory allocated for the work item
                free(work_item);

                // Set the process to busy
                processes_status[i] = 1;
            }
        }
    }

    // Else 
}


void handle_work_item(const int rank, const int size, WorkQueue *work_queue, int8_t *processes_status){
    // Receive the work item
    WorkItem* work_item = (WorkItem *)malloc(sizeof(WorkItem));
    MPI_Recv(work_item, sizeof(WorkItem), MPI_BYTE, MPI_ROOT_PROCESS, TAG, MPI_COMM_WORLD, &status);

    printf("Process %d received work item: %d - %d\n", rank, work_item.start_idx, work_item.end_idx);

    // Check if stop signal
    if(work_item->start_idx == -1 && work_item->end_idx == -1){
        // Stop signal
        puts("Received stop signal");
        return;
    }

    // Process the work item
    mandelbrot_set(buffer, work_item->start_idx, work_item->end_idx);

    // Send the result back to the root process
    MPI_Send(work_item, sizeof(WorkItem), MPI_BYTE, MPI_ROOT_PROCESS, TAG, MPI_COMM_WORLD);

    // Set the process to free
    processes_status[rank] = 0;
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

    // Array that track the status of the processes
    // 0 - free
    // 1 - busy
    int8_t *processes_status = (int *)calloc(size, sizeof(int8_t));

    // Every process will have a buffer to receive the data
    buffer_t *buffer = (buffer_t *)calloc(MPI_CHUNK_SIZE, sizeof(buffer_t));
    


    // Allocate memory for the image buffer in the root process
    uint8_t *image = NULL;
    if (rank == MPI_ROOT_PROCESS) {
        image = (uint8_t *)malloc(total_size * sizeof(uint8_t));
        if (image == NULL) {
            fprintf(stderr, "Error allocating memory for the image\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
    }


    // Build the work queue
    WorkQueue work_queue;
    if (rank == MPI_ROOT_PROCESS) {
        // Initialize the work queue
        TAILQ_INIT(&work_queue);

        // Add work items to the queue
        for (int i = 0; i < total_size; i += MPI_CHUNK_SIZE) {
            // Allocate memory for the work item
            WorkItem *work_item = (WorkItem *)malloc(sizeof(WorkItem));
            
            // Set the start and end indices for the work item
            work_item->start_idx = i;
            work_item->end_idx = work_item->start_idx + MPI_CHUNK_SIZE;

            // Insert the work item into the queue
            TAILQ_INSERT_TAIL(&work_queue, work_item, entries);
        }
    }

    /**
     *  Here we start distributing the work items to the processes with a 
     *  master-slave approach. The root process will distribute the work items
     *  to the other processes with a simple round-robin strategy.
    */
    int completed_processes = 0;
    if (rank == MPI_ROOT_PROCESS) {
        while (completed_processes < size - 1) {
            distribution_loop(processes_status, size, &work_queue);
            
            // Receive the result from the processes
            MPI_Status status;
            WorkItem *work_item = (WorkItem *)malloc(sizeof(WorkItem));
            MPI_Recv(work_item, sizeof(WorkItem), MPI_BYTE, MPI_ANY_SOURCE, TAG, MPI_COMM_WORLD, &status);

            // Set the process to free
            processes_status[status.MPI_SOURCE] = 0;

            // Check if the process has finished
            if (work_item->start_idx == -1 && work_item->end_idx == -1) {
                ++completed_processes;
            }

            // Free the memory allocated for the work item
            free(work_item);

            
        }
    }

    


    // Free the memory allocated for the image buffer in each process
    puts("Freeing the memory allocated for the buffer");
    free(buffer);
    
    // The root process save the final image    
    if (rank == MPI_ROOT_PROCESS) {
        puts("Saving the image to a PGM file");
        save_image("mandelbrot.pgm", image, WIDTH, HEIGHT);
        free(image);
    }
    
    // Finalize MPI
    puts("Finalizing MPI");
    MPI_Finalize();


    return 0;
}




