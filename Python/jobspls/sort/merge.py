from typing import TYPE_CHECKING, Sequence 

if TYPE_CHECKING:
    from _typeshed import SupportsRichComparison


def merge(left: Sequence[int], right: Sequence[int]) -> Sequence[SupportsRichComparison]:
    merged: Sequence[SupportsRichComparison] = []

    # Indices and lengths
    # The book uses an ugly solution with side effects (list.pop)
    lidx: int = 0
    ridx: int = 0
    llen: int = len(left)
    rlen: int = len(right)

    while lidx < llen and ridx < rlen:
        litem: SupportsRichComparison = left[lidx]
        ritem: SupportsRichComparison = right[ridx]

        if litem <= ritem:
            merged.append(litem)
            lidx += 1
        elif litem > ritem:
            merged.append(ritem)
            ridx += 1

    # Append remaining numbers
    # The halves should already be sorted so this is safe
    merged.extend(left[lidx:])
    merged.extend(right[ridx:])

    return merged

