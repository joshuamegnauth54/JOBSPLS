#include "valid_palindrome.hpp"

#include <string_view>

bool valid_palindrome(std::string_view word) {
    if (word.size() < 2) {
        return false;
    }

    size_t left = 0;
    size_t right = word.size();

    while (left < right) {
        if (word[left] != word[right]) {
            return false;
        }

        ++left;
        ++right;
    }

    return true;
}
