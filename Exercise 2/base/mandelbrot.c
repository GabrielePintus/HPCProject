#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <omp.h>



// Mandelbrot set parameters
#define WIDTH 2048
#define HEIGHT 2048
#define MAX_ITER 65535
#define X_MIN -2.0
#define X_MAX 2.0
#define Y_MIN -2.0
#define Y_MAX 2.0


// OpenMP parameters
#define CHUNK_SIZE 4  // cache miss rate 0.6
// #define OMP_NUM_THREADS 4



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
void mandelbrot_set(uint8_t *image) {
    double dx = (X_MAX - X_MIN) / WIDTH;
    double dy = (Y_MAX - Y_MIN) / HEIGHT;

    const int total_size = WIDTH * HEIGHT;

    #pragma omp parallel for schedule(dynamic, CHUNK_SIZE)
    for (int i = 0; i < total_size; ++i) {
        // get row and col
        int x = i / HEIGHT; // int x = i >> WIDTH_EXP; 
        int y = i % HEIGHT; // int y = i & (HEIGHT-1); 

        // get complex point
        Complex c = {X_MIN + x * dx, Y_MIN + y * dy};

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

void save_image_as_text(const char *filename, const uint8_t *image, const int width, const int height)
{
    FILE *fp;
    fp = fopen(filename, "w");
    if (fp == NULL) {
        fprintf(stderr, "Error opening file\n");
        return;
    }
    // fprintf(fp, "P2\n%d %d\n255\n", width, height);
    for (int i = 0; i < width * height; i++) {
        fprintf(fp, "%d,", image[i]);
        if ((i + 1) % width == 0) {
            fprintf(fp, "\n");
        }
    }
    fclose(fp);
}





int main()
{
    // Set the number of threads
    // omp_set_num_threads(OMP_NUM_THREADS);

    // Allocate memory for the image
    uint8_t *image = allocate_image(WIDTH, HEIGHT);

    // Generate the Mandelbrot set
    mandelbrot_set(image);

    // Save the image to a PGM file
    save_image("mandelbrot.pgm", image, WIDTH, HEIGHT);

    // Free the memory allocated for the image
    free_image(image);


    return 0;
}

