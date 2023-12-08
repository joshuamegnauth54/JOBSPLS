#ifndef JOSH_NEET_HAPPY_PREFIX
#define JOSH_NEET_HAPPY_PREFIX

#include <cstddef>
#include <optional>
#include <string_view>

struct HappyPrefix {
  std::string_view view;
  size_t prefix_end;
  size_t suffix_start;

  std::string_view into_prefix() const;
};

std::optional<HappyPrefix> happy_prefix(std::string_view domain);

#endif
