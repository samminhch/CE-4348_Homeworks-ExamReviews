#include "string_tools.h"
#include <stdlib.h>

size_t string_len(const char *str) {
  size_t size = 0;
  while (str[size] != '\0') {
    size++;
  }
  return size;
}

char *string_strip(const char *str) {
  size_t size = 0;
  while (str[size] != '\0' && str[size] != '\n') {
    size++;
  }
  char *stripped = (char *)calloc(size + 1, sizeof(char));

  for (size_t idx = 0; idx < size; idx++) {
    stripped[idx] = str[idx];
  }
  stripped[size] = '\0';

  return stripped;
}
