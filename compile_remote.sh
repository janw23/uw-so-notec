printf "notec.asm size in bytes: "
wc -c < notec.asm

N=5
echo "Compiling example on remote for N = ${N}"

echo "Removing files on remote"
ssh students rm -rf MIMUW/SO/uw-so-notec

echo "Copying local repo to remote"
scp -q -r ~/Workspace/MIMUW/uw-so-notec/ students:~/MIMUW/SO/

echo "Compiling files on remote"
ssh students "cd MIMUW/SO/uw-so-notec && \
  nasm -DN=$N -f elf64 -w+all -w+error -o notec.o notec.asm && \
  gcc -DN=$N -c -Wall -Wextra -O2 -std=c11 -o example.o example.c && \
  gcc notec.o example.o -lpthread -o example"

echo "Running notec on remote"
ssh students "cd MIMUW/SO/uw-so-notec && ./example 2>&1"
