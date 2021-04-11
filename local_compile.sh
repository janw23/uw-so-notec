N=5

gcc -DN=$N -c -Wall -Wextra -O2 -std=c11 -o example.o example.c
gcc -c -Wall -Wextra -O2 -std=c11 -o notec.o notec.c
gcc notec.o example.o -lpthread -o example
