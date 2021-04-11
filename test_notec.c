// Plik z testami implementacji notecia

// Muszę zrozumieć:
// - co z liczbami ujemnymi w obliczeniach ->
//     operacje są mod 2^64, więc reprezentacja jest standardowa unsigned
// - jak dokładnie działa operacja W
// - po co jest debug()?
//
// Powinno być możliwe sekwencyjne symulowanie noteci
// i sprawdzania zakleszczeń oraz poprawności obliczenia.

// Mogę zasymulować wykonanie noteci i wygenerować ich docelowe stosy,
// a potem porównać je z implementacją programu.
//  czy wszystko jest deterministyczne?

// determinizm symulacji wymaga:
// - determinizmu debug(), czyli dla danego notecia w danym stanie jego stosu
//   zawsze ma te same efekty uboczne i zwraca tę samą wartość
// W jest deterministyczne

#include <stdio.h>
#include <stdint.h>
#include "notec_sim.h"

int main() {

    static const char *calc_1 = "2n+";
    static const char *calc_2 = "2n+";
    static const char *calc_3 = "2n+";
    static const char *calc_4 = "2n+";
    static const char *calc_5 = "2n+";

    return 0;
}