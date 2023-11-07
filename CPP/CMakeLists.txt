cmake_minimum_required(VERSION 3.26)
project(jobspls)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wold-style-cast -Wctor-dtor-privacy -Wswitch-default -g")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(
    jobspls_tests
    tests/containsdupe_test.cpp
)
target_link_libraries(
    jobspls_tests
    gtest
    gtest_main
)

include(GoogleTest)
gtest_discover_tests(jobspls_tests)
