"""Binary search."""

from jobspls.types import IndexCollection, PartialOrd


def binary_search(vec: IndexCollection[PartialOrd], find: PartialOrd) -> int | None:
    """Binary search."""
    lower: int = 0
    upper: int = len(vec) - 1

    while lower <= upper:
        index: int = (lower + upper) // 2

        if vec[index] < find:
            lower = index + 1
        elif vec[index] > find:
            upper = index - 1
        else:
            return index

    return None
