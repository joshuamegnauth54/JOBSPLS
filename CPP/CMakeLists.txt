cmake_minimum_required(VERSION 3.26)
project(
    jobspls
    DESCRIPTION "Josh Obtains Benefits by Saliently Programming Lame Stuff"
    LANGUAGES CXX
)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wold-style-cast -Wctor-dtor-privacy -Wswitch-default -g")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(JOBSPLS_HEADERS "anagram.hpp concat.hpp consec_sequence.hpp containsduplicate.hpp group_anagrams.hpp kth_largest.hpp last_word_len.hpp longest_prefix.hpp prod_sans_self.hpp replace_vals_right.hpp substring.hpp two_sum.hpp valid_palindrome.hpp")

set(JOBSPLS_SRC "anagram.cpp concat.cpp group_anagrams.cpp kth_largest.cpp last_word_len.cpp longest_prefix.cpp replace_vals_right.cpp substring.cpp valid_palindrome.cpp")

target_include_directories(libjobspls PRIVATE neet)

add_library(
    libjobspls STATIC
    "${JOBSPLS_HEADERS}"
    "${JOBSPLS_SRC}"
)

add_executable(
    jobspls_tests
    tests/anagram_test.cpp
    tests/containsdupe_test.cpp
    tests/consec_sequence.cpp
    tests/longest_prefix_test.cpp
    tests/substring.cpp
)
target_link_libraries(
    jobspls_tests
    gtest
    gtest_main
    libjobspls
)

include(GoogleTest)
gtest_discover_tests(jobspls_tests)
