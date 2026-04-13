#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>

const size_t ARR_SIZE = 25;
sem_t semaphore;
void *f1(void *arg);
void *f2(void *arg);

int main() {
  // Open `datafile`
  FILE *fp1, *fp2;
  fp1 = fopen("datafile", "w");
  if (fp1 == NULL) {
    perror("[ERROR] Couldn't open file for writing");
    return 1;
  }
  fp2 = fp1;

  // Write to `datafile`
  sem_init(&semaphore, 0, 1);
  pthread_t thread_1, thread_2;

  pthread_create(&thread_1, NULL, f1, (void *) fp1);
  pthread_create(&thread_2, NULL, f2, (void *) fp2);

  pthread_join(thread_1, NULL);
  pthread_join(thread_2, NULL);

  fclose(fp1);

  // Read and print out `datafile`
  FILE *fp = fopen("datafile", "r");
  if (fp == NULL) {
    perror("[ERROR] Couldn't open file for reading");
    return 1;
  }

  int test[ARR_SIZE][ARR_SIZE];
  for (size_t r = 0; r < ARR_SIZE; r++) {
    for (size_t c = 0; c < ARR_SIZE; c++) {
      fscanf(fp, "%d", &test[r][c]);
    }
  }
  fclose(fp);

  puts("[INFO] Resulting array:");
  for (size_t r = 0; r < ARR_SIZE; r++) {
    for (size_t c = 0; c < ARR_SIZE; c++) {
      printf("%d ", test[r][c]);
    }
    printf("\n");
  }

  return 0;
}

void *f1(void *arg) {
  sem_wait(&semaphore);
  FILE *fp = (FILE *) arg;
  int arr[ARR_SIZE][ARR_SIZE];

  for (size_t r = 0; r < ARR_SIZE; r++) {
    for (size_t c = 0; c < ARR_SIZE; c++) {
      arr[r][c] = 1;
      fprintf(fp, "%d ", arr[r][c]);
    }
    fprintf(fp, "\n");
  }
  sem_post(&semaphore);
  return NULL;
}

void *f2(void *arg) {
  sem_wait(&semaphore);
  FILE *fp = (FILE *) arg;
  int arr[ARR_SIZE][ARR_SIZE];

  for (size_t r = 0; r < ARR_SIZE; r++) {
    for (size_t c = 0; c < ARR_SIZE; c++) {
      arr[r][c] = 2;
      fprintf(fp, "%d ", arr[r][c]);
    }
    fprintf(fp, "\n");
  }
  sem_post(&semaphore);
  return NULL;
}
