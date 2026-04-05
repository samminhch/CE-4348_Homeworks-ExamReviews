#include <pthread.h>
#include <stddef.h>
#include <stdio.h>

double average;
int minimum, maximum;

typedef struct {
        const int *data;
        const size_t size;
} vec_t;

void *calc_avg(void *params);
void *calc_min(void *params);
void *calc_max(void *params);

int main() {
    const int nums[] = {90, 81, 78, 95, 79, 72, 85};
    const vec_t data = {.data = nums, .size = sizeof(nums) / sizeof(nums[0])};
    // Create the threads
    pthread_t avg_thread, min_thread, max_thread;
    pthread_create(&avg_thread, NULL, calc_avg, (void *) &data);
    pthread_create(&min_thread, NULL, calc_min, (void *) &data);
    pthread_create(&max_thread, NULL, calc_max, (void *) &data);

    // Wait for threads to finish
    pthread_join(avg_thread, NULL);
    pthread_join(min_thread, NULL);
    pthread_join(max_thread, NULL);

    // Print out results!
    printf("The average value is %.2f\n", average);
    printf("The minimum value is %d\n", minimum);
    printf("The maximum value is %d\n", maximum);
    return 0;
}

void *calc_avg(void *params) {
    vec_t *vec = (vec_t *) params;

    float sum = 0;
    for (size_t i = 0; i < vec->size; i++) {
        sum += vec->data[i];
    }
    average = sum / vec->size;
    return NULL;
}

void *calc_min(void *params) {
    vec_t *vec = (vec_t *) params;

    if (vec->size == 0) {
        return NULL;
    }

    int min = vec->data[0];
    for (size_t i = 1; i < vec->size; i++) {
        if (vec->data[i] < min) {
            min = vec->data[i];
        }
    }
    minimum = min;
    return NULL;
}

void *calc_max(void *params) {
    vec_t *vec = (vec_t *) params;

    if (vec->size == 0) {
        return NULL;
    }

    int max = vec->data[0];
    for (size_t i = 1; i < vec->size; i++) {
        if (vec->data[i] > max) {
            max = vec->data[i];
        }
    }
    maximum = max;
    return NULL;
}
