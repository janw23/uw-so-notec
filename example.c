#include <assert.h>
#include <pthread.h>
#include <stdint.h>

#include <stdio.h> // TODO RT
#include <unistd.h> // TODO RT

// Interfejs między C a Asemblerem
uint64_t notec(uint32_t n, char const *calc);
int64_t debug(uint32_t n, uint64_t *stack_pointer);

// Chcemy wystartować wszystkie obliczenia możliwie jednocześnie.
volatile unsigned wait = 1;

// Startujemy co najwyżej jedno obliczenie calc_1
// i parzystą liczbę obliczeń calc_2.
static const char calc_1[] = "ng";// todo "6N8ZXab=12-+3*~FFF&cDe09|g";
static const char calc_2[] = "5=6+";// TODO "nY1^W";
static const uint64_t result_1 = (~((0xab - 0x12) * 3) & 0xfff) | 0xcde09;

// Ta funkcja jest wywoływana tylko w obliczeniu calc_1
// w celu sprawdzenia jego poprawności.
int64_t debug(uint32_t n, uint64_t *stack_pointer) {
//  assert(n == N - 1 && (n & 1) == 0);
//  assert(*stack_pointer == result_1);
//
//  // Usuwamy wynik ze stosu.
//  return 1;
    fprintf(stderr, "called debug\n"); // todo RT
    for (int i = 0; i < 5; i++) {   // todo RT
        fprintf(stderr, "stack[%d] = %lu\n", i, stack_pointer[i]);
    }

    return 0;
}

void* thread_routine(void *data) {
  uint32_t n = *(uint32_t*)data;
  const char *calc;

  if (n == N - 1 && (n & 1) == 0)
    calc = calc_1; // To obliczenie jest uruchamiane co najwyżej w jednym wątku.
  else
    calc = calc_2; // To obliczenie jest uruchamiane w parzystej liczbie wątków.

  while (wait);

    fprintf(stderr,"here %d\n", n); // TODO RT

  uint64_t result = notec(n, calc);

  if (n == N - 1 && (n & 1) == 0)
    assert(result == 5);// TODO 6);
  else
    assert(result == 11); // TODO (n ^ 1));

  return NULL;
}

int main () {
    fprintf(stderr, "here\n"); // TODO RT
  pthread_t tid[N];
  uint32_t i, n[N];

  for (i = 0; i < N; ++i) {
    n[i] = i;
    assert(0 == pthread_create(&tid[i], NULL, &thread_routine, (void*)&n[i]));
  }

  wait = 0;

  for (i = 0; i < N; ++i)
    assert(0 == pthread_join(tid[i], NULL));

  fprintf(stderr, "goodbye\n"); // todo RT

  return 0;
}
