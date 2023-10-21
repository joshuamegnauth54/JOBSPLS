#ifndef JOSH_PROD_SANS_SELF_HPP
#define JOSH_PROD_SANS_SELF_HPP

#include <iterator>
#include <span>
#include <type_traits>
#include <vector>

#include <boost/range/combine.hpp>

template <typename T>
  requires(std::is_integral_v<T>)
std::vector<T> prod_sans_self(std::span<T> nums) {
  T left_product = 1;
  auto product = std::vector<T>(nums.size(), 1);

  for (auto &&[num, prod] : boost::combine(nums, product)) {
    prod = left_product;
    left_product *= num;
  }

  T right_product = 1;
  auto prod = product.rbegin();
  for (auto num = nums.rbegin(); prod < product.rend() && num < nums.rend();
       prod++, num++)

  {
    *prod *= right_product;
    right_product *= *num;
  }

  return product;
}

#endif
