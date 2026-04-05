#include "io_tools.h"
#include "string_tools.h"
#include <fcntl.h>
#include <pthread.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

const size_t BUFFER_SIZE = 32;

void copy_char(int input_fd, int output_fd);
void copy_chunk(int input_fd, int output_fd);

int main() {
  char buffer[BUFFER_SIZE];
  char *source_filename, *target_filename;
  int source_fd, target_fd;

  puts("Enter the filename to open for reading: ");
  read_safe(STDIN_FILENO, buffer, BUFFER_SIZE);

  source_filename = string_strip(buffer);
  printf("string is: %s\n", source_filename);

  // Attempt to open file for reading
  source_fd = open(source_filename, O_RDONLY);
  free(source_filename);
  if (source_fd == -1) {
    exit_error(OPEN_ERROR, "Could not open file for reading");
  }

  puts("Enter the filename to open for writing: ");
  read_safe(STDIN_FILENO, buffer, BUFFER_SIZE);

  target_filename = string_strip(buffer);
  printf("string is: %s\n", target_filename);

  // Attempt to open file for writing
  target_fd = open(target_filename, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
  free(target_filename);
  if (target_fd == -1) {
    exit_error(OPEN_ERROR, "Could not open file for writing");
  }

  // Time the copy function
  clock_t start = clock(), duration;
#ifdef CHUNKED
  copy_chunk(source_fd, target_fd);
#else
  copy_char(source_fd, target_fd);
#endif
  puts("Contents copied!\n");
  close(source_fd);
  close(target_fd);

  duration = clock() - start;
  double duration_sec = (double)duration / CLOCKS_PER_SEC;
  printf("Copying took about %lu cycles, or %f seconds\n", duration,
         duration_sec);

  return 0;
}

void copy_char(int source_fd, int target_fd) {
  char c;
  while (read_safe(source_fd, &c, sizeof(char))) {
    write_safe(target_fd, &c, sizeof(char));
  }
}

void copy_chunk(int source_fd, int target_fd) {
#ifdef CHUNK_SIZE
  const size_t chunk_size = CHUNK_SIZE;
#else
  const size_t chunk_size = 1 << 6;
#endif
  char c[chunk_size];
  ssize_t read_size;
  while ((read_size = read_safe(source_fd, &c, chunk_size))) {
    write_safe(target_fd, &c, read_size * sizeof(char));
  }
}
