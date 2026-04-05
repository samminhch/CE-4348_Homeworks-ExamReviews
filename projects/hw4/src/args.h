#ifndef ARGS_H_
#define ARGS_H_
#include <stdbool.h>
#include <stddef.h>
typedef struct {
  bool show_pids;
  bool show_args;
} PSTREE_FLAGS;

PSTREE_FLAGS process_args(size_t argc, char **argv);
#endif
