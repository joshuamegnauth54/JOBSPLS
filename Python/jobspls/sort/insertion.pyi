from collections.abc import Iterable, Sequence
from typing import Literal

from _typeshed import SupportsAllComparisons

def insertion_idx_bk(vec: Sequence[SupportsAllComparisons], insert: SupportsAllComparisons) -> int: ...

def insertion_idx_fwd(vec: Sequence[SupportsAllComparisons], insert: SupportsAllComparisons) -> int: ...

def insertion_sort(unsorted: Iterable[SupportsAllComparisons], direction: Literal["forward", "backward"]) -> list[SupportsAllComparisons]: ...
