"""Longest sequence of zeroes in base 2 integer"""
def binary_gap(i: int) -> int:
    binary: str = bin(i)[2:]
    gap: int = 0
    current: int = 0

    for b in binary:
        if b == "1":
            if current > gap:
                gap = current
            current = 0
        else:
            current += 1

    return gap
