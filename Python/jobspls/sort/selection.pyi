from collections.abc import MutableSequence

from _typeshed import SupportsRichComparison

def select(seq: MutableSequence[SupportsRichComparison], offset: int) -> int: ...

def selection_sort(seq: MutableSequence[SupportsRichComparison]) -> list[SupportsRichComparison]: ...
