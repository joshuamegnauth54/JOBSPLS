package algorithms

func PermCheck(haystack []int) bool {
	numbers := make(map[int]struct{})
	for _, v := range haystack {
		numbers[v] = struct{}{}
	}

	for i := 1; i < len(haystack)+1; i++ {
		if _, found := numbers[i]; !found {
			return false
		}
	}

	return true
}
