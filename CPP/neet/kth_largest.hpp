#ifndef JOSH_KTH_LARGEST_HPP
#define JOSH_KTH_LARGEST_HPP

#include <optional>
#include <span>

template <typename T>
std::optional<T> kth_largest(std::span<T> haystack, size_t k);

#endif
