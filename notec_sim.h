// Symulator działania noteci na danych obliczeniach

#ifndef NOTEC_SIM_H
#define NOTEC_SIM_H

#include <stdint.h>

typedef struct {
    uint64_t *stack_base_ptr; // początek stosu danego notecia
    uint64_t elem_count;      // liczba elementów na stosie
} sim_stack_t;

// Symuluje [N] noteci na obliczeniach [calcs]
// calcs[i] jest traktowane jako obliczenie dla notecia i.
// Zwraca tablicę ze stosami wynikowymi poszczególnych noteci od 0 do N-1
// Zwraca NULL, jeśli któreś z obliczeń jest niepoprawne.
sim_stack_t *simulate(uint32_t N, char** calcs);

void destroy_sim_stacks(sim_stack_t *sim_stacks);

#endif //NOTEC_SIM_H
