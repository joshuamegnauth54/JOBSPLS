"""Container types for algorithms."""

from collections.abc import Collection
from typing import TypeVar, Protocol
from jobspls.types.protocols import Hashable

T = TypeVar("T", covariant=True)


class IndexCollection(Collection[T], Protocol):
    def __getitem__(self, key: Hashable) -> T:
        ...
