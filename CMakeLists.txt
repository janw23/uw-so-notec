cmake_minimum_required(VERSION 3.17)
project(uw_so_notec C)

set(CMAKE_C_STANDARD 11)

add_executable(uw_so_notec
        example.c
        notec.c
        test_notec.c notec_sim.c notec_sim.h)
