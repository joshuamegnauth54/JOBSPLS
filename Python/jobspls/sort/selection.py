from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from _typeshed import SupportsRichComparison

def select(seq, offset):
    minimum: SupportsRichComparison = seq[offset]
    min_idx: int = offset

    # Select the index of the smallest element from the unsorted
    # half of the sequence
    for i, val in enumerate(seq[offset + 1:]):
        if minimum > val:
            minimum = val
            min_idx = i + offset + 1

    return min_idx

def selection_sort(seq):
    for i in range(len(seq)):
        minimum: int = select(seq, i)
        seq[i], seq[minimum] = seq[minimum], seq[i]

    return seq
