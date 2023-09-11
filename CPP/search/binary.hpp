#ifndef JOSH_SEARCH_BINARY_HPP
#define JOSH_SEARCH_BINARY_HPP

#include <expected>
#include <iterator>

template <typename T, std::random_access_iterator RAIter>
auto binary(RAIter haystack, const T needle) -> std::expected<size_t, size_t>;

template <typename T, std::random_access_iterator RAIter>
auto binary_range(RAIter haystack, T const needle, size_t const lower,
                  size_t const upper) -> std::expected<size_t, size_t>;

#endif
