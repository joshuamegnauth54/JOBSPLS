#include <cstdlib>
#include <iterator>
#include <list>
#include <numeric>
#include <optional>

using std::advance;
using std::iota;
using std::list;
using std::make_optional;
using std::nullopt;
using std::optional;

optional<size_t> josephus(size_t participants, size_t elim) {
    if (participants == 0) {
        return nullopt;
    }
    if (elim == 0) {
        // Return participants rather than participants - 1 because we're 1 indexed
        return participants;
    }

    // Fill the linked list with monotonically increasing numbers.
    // A linked list is totally wasteful here but it's a straightforward solution.
    list<size_t> living(participants);
    iota(living.begin(), living.end(), 1);

    auto current = living.begin();
    size_t index = 0;
    while (living.size() > 1) {
        index = (index + elim) % living.size();
        current = living.begin();
        advance(current, index);

        current = living.erase(current);
    }
    
    return *living.cbegin();
}
