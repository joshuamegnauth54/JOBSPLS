#ifndef JOSH_GROUP_ANAGRAMS
#define JOSH_GROUP_ANAGRAMS

#include <span>
#include <string>
#include <string_view>
#include <vector>

// Group ASCII words into anagrams.
// WARNING: Not Unicode aware
std::vector<std::vector<std::string_view>>
group_anagrams(std::span<const std::string> words);

#endif
