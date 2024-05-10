package algorithms

func unpaired_value[T comparable](haystack []T) (bool, T) {
	occur := make(map[T]int, len(haystack))
	for _, v := range haystack {
		occur[v] += 1
	}

	for key, count := range occur {
		if count%2 != 0 {
			return true, key
		}
	}

	return false, *new(T)
}
