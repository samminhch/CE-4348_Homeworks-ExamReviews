#include <stdio.h>
#include <unistd.h>
#include "args.h"
#define bool_to_str(b) (b ? "true" : "false")

int main(int argc, char **argv) {
  PSTREE_FLAGS flags = process_args(argc, argv);

  // Go to the top process
  pid_t root = getppid();
  while (root != 1) {
    root = getppid();
    printf("root=%d\n", root);
  }
  return 0;
}
