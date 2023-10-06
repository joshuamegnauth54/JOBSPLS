#include "neet.hpp"
#include <vector>
#include <array>
#include <span>

int main() {
    std::vector a = {14, 28, 42};
    /* auto sp = std::span(a.begin(), a.end()); */
    std::span<const int> sp = std::span(a);

    auto out = repeat_array(sp, 5);

    return 0;
}
