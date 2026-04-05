#ifndef IO_TOOLS_H_
#define IO_TOOLS_H_
#include "string_tools.h"
#include <fcntl.h>
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

typedef enum { READ_ERROR = 2, WRITE_ERROR, OPEN_ERROR } EXIT_STATUS;

/**
 * @brief 
 */
void exit_error(EXIT_STATUS status, const char *msg);

/**
 * @brief Calls `write_safe` to print out a string to `file_descriptor`
 * @param file_descriptor The location and name of a file
 * @param str The string to write to `file_descriptor`
 */
void print(int file_descriptor, const char *str);

/**
 * @brief Calls `unistd::write`, but exits program on error
 * @param file_descriptor The location and name of a file
 * @param buffer Data to write to `file_descriptor`
 * @param buffer_size Size of `buffer`
 * @see <unistd>::write
 */
ssize_t write_safe(int file_descriptor, const void *buffer, size_t buffer_size);

/**
 * @brief Calls `unistd::read` from unistd.h, but exits program on error
 * @param file_descriptor The location and name of a file
 * @param buffer Where to write data from `file_descriptor` to
 * @param num_bytes The number of bytes to read from `file_descriptor` into
 * `buffer`
 * @see <unistd>::read
 */
ssize_t read_safe(int file_descriptor, void *buffer, size_t num_bytes);
#endif
