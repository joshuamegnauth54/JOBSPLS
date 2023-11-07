#ifndef JOSH_LONGEST_PREFIX_HPP
#define JOSH_LONGEST_PREFIX_HPP

#include <span>
#include <string_view>
#include <utility>

std::pair<size_t, size_t>
longest_prefix(const std::span<const std::span<const std::string_view>> words);

#endif
