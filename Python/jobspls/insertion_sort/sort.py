cabinet: list[int] = [1, 2, 3, 3, 4, 6, 13, 14]
unsorted: list[int] = [14, 7, 32, 1, 14, 28, 42, 9]

insert: int = 5

def insertion_idx(nums: list[int], insert: int) -> int | None:
    # Starting from the back
    check_loc: int = len(nums) - 1

    while check_loc >= 0:
        # If the item is larger than the variant at the current
        # index, then it should be placed behind the current item
        if insert > nums[check_loc]:
            check_loc = check_loc + 1
            break
        check_loc = check_loc - 1
    # Zero. The length of the collection is 0 or the item is the smallest
    return check_loc


def insertion_sort(unsorted: list[int]) -> list[int]:
    sort: list[int] = []
    for num in unsorted:
        index: int | None = insertion_idx(sort, num)
        assert index is not None
        sort.insert(index, num)
    return sort

print(insertion_sort(unsorted))
