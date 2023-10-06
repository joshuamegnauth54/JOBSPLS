#ifndef JOSH_CONCAT_HPP
#define JOSH_CONCAT_HPP

#include <array>
#include <span>
#include <vector>

// NOTE: I'm implementing this the correct way using a vector

template <typename T>
std::vector<T> repeat_array(const std::span<const T> values, size_t const amount);

#endif
