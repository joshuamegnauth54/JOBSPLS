package algorithms

func PermMissingElement(haystack []int) uint {
	hayset := make(map[int]struct{}, len(haystack))

	for _, v := range haystack {
		hayset[v] = struct{}{}
	}

	// Will always return at least element because the loop goes to 
	// one past haystack's length 
	for i := 1; i < len(haystack) + 2; i++ {
		if _, found := hayset[i]; !found {
			return uint(i)
		}
	}

	panic("Unreachable")
}

