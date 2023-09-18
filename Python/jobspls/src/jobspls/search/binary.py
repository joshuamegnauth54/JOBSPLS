"""Binary search."""

def binary_search(vec, find):
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
