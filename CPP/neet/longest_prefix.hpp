#ifndef JOSH_LONGEST_PREFIX_HPP
#define JOSH_LONGEST_PREFIX_HPP

#include <span>
#include <string>

std::string_view longest_prefix(const std::span<const std::string> words);

#endif
