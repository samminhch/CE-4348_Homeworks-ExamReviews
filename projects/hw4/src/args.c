#include "args.h"
#include "exits.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ARGS 4
#define HELP_MSG                                                               \
  "pstree: a program to show process information for the UNIX or Linux "       \
  "system\n\n"                                                                 \
  "Flags:\n"                                                                   \
  "\t-h/--help: Show this help message\n"                                      \
  "\t-p: Show the Process ID next to each name\n"                              \
  "\t-a: Show the command-line arguments used to start each process\n\n"       \
  "Examples:\n"                                                                \
  "\tpstree -p: Shows the process hierarchy with PIDs next to each "           \
  "process\n"                                                                  \
  "\tpstree -a: Shows the process hierarchy with command-line arguments "      \
  "next to each process\n"                                                     \
  "\tpstree -pa: Shows the process hierarchy with PIDs and command-line "      \
  "arguments next to each process\n"                                           \
  "\tpstree -h: Shows this process\n"

bool verify_shortarg_fmt(const char *arg) {
  if (strcmp(arg, "--help") == 0) { // The only valid long argument
    return true;
  } else if (arg[0] != '-') {
    return false;
  }

  // Check the only valid short argument characters
  for (size_t idx = 1; arg[idx] != '\0'; idx++) {
    if (arg[idx] != 'h' && arg[idx] != 'p' && arg[idx] != 'a') {
      return false;
    }
  }
  return true;
}

PSTREE_FLAGS process_args(size_t argc, char **argv) {
  PSTREE_FLAGS flags = {.show_pids = false, .show_args = false};

  if (argc <= 1) {
    return flags;
  } else if (argc > MAX_ARGS) {
    fprintf(stderr,
            "[ERROR:%d] Too many arguments provided. See `pstree -h` for "
            "information on how to run this command\n",
            ILLEGAL_ARGUMENT);
    exit(ILLEGAL_ARGUMENT);
  }

  for (size_t arg_idx = 1; arg_idx < argc; arg_idx++) {
    if (strcmp("--help", argv[arg_idx]) == 0 ||
        strcmp("-h", argv[arg_idx]) == 0) {
      puts(HELP_MSG);
      exit(EXIT_SUCCESS);
    }

    if (!verify_shortarg_fmt(argv[arg_idx])) {
      fprintf(stderr, "[ERROR:%d] Illegal argument '%s' ", ILLEGAL_ARGUMENT,
              argv[arg_idx]);
      exit(ILLEGAL_ARGUMENT);
    }
    for (size_t idx = 1; idx < strlen(argv[arg_idx]); idx++) {
      switch (argv[arg_idx][idx]) {
      case 'p':
        flags.show_pids = true;
        break;
      case 'a':
        flags.show_args = true;
        break;
      }
    }
  }
  return flags;
}
