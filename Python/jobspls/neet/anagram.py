from collections import defaultdict


def fill_dict(d: defaultdict[str, int], s: str):
    for c in s:
        d[c] += 1

def anagram(s1: str, s2: str) -> bool:
    s1_count: defaultdict[str, int] = defaultdict(int)
    s2_count: defaultdict[str, int] = defaultdict(int)

    fill_dict(s1_count, s1)
    fill_dict(s2_count, s2)

    return all(s1_count[key] == s2_count.get(key) for key in s1_count.keys())
