#include <gtest/gtest.h>

#include "neet.hpp"

namespace {
TEST(SubstringTest, FoundSubstring) {
  const auto s = "Emi is purrfect, nya";
  const auto sub = "purrnya";
  EXPECT_TRUE(contains_substring(s, sub));
}
} // namespace
