from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from collections.abc import Callable, Sequence

    from _typeshed import SupportsAllComparisons

# TODO: Simplify
def insertion_idx_bk(vec, insert):
    # Starting from the back
    check_loc: int = len(vec) - 1

    while check_loc >= 0:
        # If the item is larger than the variant at the current
        # index, then it should be placed behind the current item
        if insert > vec[check_loc]:
            check_loc = check_loc + 1
            break
        check_loc = check_loc - 1
    # If Zero. The length of the collection is 0 or the item is the smallest
    return check_loc

def insertion_idx_fwd(vec, insert):
    # Loop till an element > insert is found
    for i, elem in enumerate(vec):
        if insert < elem:
            return i

    # If `insert` is greater than every element then it logically belongs at the end
    # This also handles the case where len(vec) == 0
    return len(vec)


def insertion_sort(unsorted, direction):
    insertion_idx: Callable[[Sequence[SupportsAllComparisons], SupportsAllComparisons], int]

    match direction:
        case "forward":
            insertion_idx = insertion_idx_fwd
        case "backward":
            insertion_idx = insertion_idx_bk
        case invalid:
            raise ValueError(f"expected `backward` or `forward` for insertion_sort direction; got {invalid}")

    sort: list[SupportsAllComparisons] = []
    for num in unsorted:
        index: int = insertion_idx(sort, num)
        sort.insert(index, num)
    return sort
