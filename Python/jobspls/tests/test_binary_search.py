import pytest
from jobspls.search.binary import binary_search


def test_numbers():
    nums: list[int] = list(range(100))
    found: None | int = binary_search(nums, 69)
    assert found == 69

def test_empty():
    nums: list[int] = []
    found: None | int = binary_search(nums, 69)
    assert not found
