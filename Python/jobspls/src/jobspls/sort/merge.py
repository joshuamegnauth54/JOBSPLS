from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from collections.abc import Sequence

    from _typeshed import SupportsAllComparisons


def merge(left, right):
    merged: Sequence[SupportsAllComparisons] = []

    # Indices and lengths
    # The book uses an ugly solution with side effects (list.pop)
    lidx: int = 0
    ridx: int = 0
    llen: int = len(left)
    rlen: int = len(right)

    while lidx < llen and ridx < rlen:
        litem: SupportsAllComparisons = left[lidx]
        ritem: SupportsAllComparisons = right[ridx]

        if litem <= ritem:
            merged.append(litem)
            lidx += 1
        elif litem > ritem:
            merged.append(ritem)
            ridx += 1

    # Append remaining numbers
    # NOTE: invariants
    # Both left and right are already sorted
    # At least one of left/right is exhausted
    merged.extend(left[lidx:])
    merged.extend(right[ridx:])

    return merged

def merge_sort(vec):
    pivot: int = len(vec) // 2

    left: Sequence[SupportsAllComparisons] = merge_sort(vec[:pivot])
    right: Sequence[SupportsAllComparisons] = merge_sort(vec[pivot:])

    return merge(left, right)
