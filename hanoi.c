// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

struct tower {
  int *stack;
  int size;
};

void init_tower(struct tower *tower, int cap) {
  tower->stack = calloc(cap + 1, sizeof(int));
  tower->size = 0;
}

void print_tower(struct tower *tower, char name) {
  putchar(name);
  putchar(':');
  putchar(' ');
  for (int i = 0; i < tower->size; i++) {
    putchar(tower->stack[i] + '0');
    putchar(' ');
  }
  putchar('\n');
}

// return the value of the top ring
int peek(struct tower *tower) {
  if (tower->size) {
    return tower->stack[tower->size - 1];
  }
  return INT_MAX;
}

// remove the top ring and return its value
int pop(struct tower *tower) {
  assert(tower->size);
  int val = tower->stack[tower->size - 1];
  tower->stack[tower->size - 1] = 0;
  tower->size--;
  return val;
}

// push a new ring (without error checking)
void push(struct tower *tower, int val) {
  tower->stack[tower->size] = val;
  tower->size++;
}

// make the only valid move between a/b
void move(struct tower *a, struct tower *b) {
  if (peek(a) > peek(b)) {
    push(a, pop(b));
  } else {
    push(b, pop(a));
  }
}

void print_all(struct tower *a, struct tower *b, struct tower *c, int n) {
  print_tower(a, 'A');
  if ((n % 2) == 0) {
    print_tower(b, 'B');
    print_tower(c, 'C');
  } else {
    print_tower(c, 'B');
    print_tower(b, 'C');
  }
  putchar('\n');
}

int solve(int n) {
  struct tower s, a, d;
  init_tower(&s, n);
  init_tower(&a, n);
  init_tower(&d, n);

  int i;
  for (i = 0; i < n; i++) {
    push(&s, n - i);
  }

  i = 0;
  int total_moves = (1 << n) - 1;
  for (;;) {
    print_all(&s, &a, &d, n);
    move(&s, &d);
    if (++i == total_moves) {
      break;
    }
    print_all(&s, &a, &d, n);
    move(&s, &a);
    if (++i == total_moves) {
      break;
    }
    print_all(&s, &a, &d, n);
    move(&a, &d);
    if (++i == total_moves) {
      break;
    }
  }
  print_all(&s, &a, &d, n);
  return 0;
}

int main(int argc, char **argv) {
  int size;
  if (argc <= 1) {
    size = 3;
  } else {
    size = argv[1][0] - '0';
  }
  return solve(size);
}
