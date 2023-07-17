import pytest


@pytest.fixture
def unsorted_strings() -> list[str]:
    pass


@pytest.fixture
def sorted_strings() -> list[str]:
    return sorted(unsorted_strings())
