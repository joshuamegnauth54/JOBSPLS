import random

import pytest


@pytest.fixture()
def unsorted_u8(n: int = 32) -> list[int]:
    return [random.randint(0, 255) for _ in range(n)]


@pytest.fixture()
def sorted_u8(n: int = 32) -> list[int]:
    return sorted(unsorted_u8(n))
