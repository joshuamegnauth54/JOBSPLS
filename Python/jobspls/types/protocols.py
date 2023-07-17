"""Protocols (interfaces)"""

from typing import Protocol, Self

# T must support comparisons (similar to PartialOrd in Rust parlance)
class PartialOrd(Protocol):
    def __gt__(self, other: Self) -> bool:
        ...

    def __lt__(self, other: Self) -> bool:
        ...

    def __eq__(self, other: Self) -> bool:
        ...

    def __ne__(self, other: Self) -> bool:
        ...

    def __le__(self, other: Self) -> bool:
        ...

    def __ge__(self, other: Self) -> bool:
        ...


class Hashable(Protocol):
    def __hash__(self) -> int:
        ...
