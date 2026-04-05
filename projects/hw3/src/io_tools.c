#include "io_tools.h"
#include <stdio.h>

void exit_error(EXIT_STATUS status, const char *msg) {
  fprintf(stderr, "[ERROR:%d] %s\n", status, msg);
  exit(status);
}

void print(int file_descriptor, const char *str) {
  write_safe(file_descriptor, str, string_len(str));
}

ssize_t write_safe(int file_descriptor, const void *buffer,
                   size_t buffer_size) {
  ssize_t result = write(file_descriptor, buffer, buffer_size);
  if (result == -1) {
    char error_msg[] = "Could not write to file_descriptor";
    exit_error(READ_ERROR, error_msg);
  }
  return result;
}

ssize_t read_safe(int file_descriptor, void *buffer, size_t num_bytes) {
  ssize_t result = read(file_descriptor, buffer, num_bytes);

  if (result == -1) {
    exit_error(READ_ERROR, "Could not read from file_descriptor");
  }
  return result;
}
