from typing import Any

"""Rotate an array."""
def rotate(array: list[Any], by: int) -> list[Any]:
    rotated: list[Any] = [None] * len(array)

    for i, value in enumerate(rotated):
        j: int = (i + by) % len(array)
        rotated[j] = value

    return rotated
