#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
  char *data;
  int magic;

  sscanf(argv[1], "%s", data);
  sscanf(argv[2], "%d", &magic);

  if (magic == 0x31337987) {
    puts("Found VERY specific magic number");
  }

  if (magic < 100 && magic % 15 == 2 && magic % 11 == 6) {
    puts("Found convoluted magic number");
  }

  int count = 0;
  for (int i = 0; i < 100; i++) {
    if (data[i] == 'Z') {
      count++;
    }
  }

  if (count >= 8 && count <= 16) {
    puts("Found correct range of Zs");
  }

  return 0;
}
