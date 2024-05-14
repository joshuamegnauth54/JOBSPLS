package algorithms

import "math"

func SmallestPosInt(slice []int) (int, bool) {
	valid := make(map[int]struct{}, len(slice))

	for _, i := range slice {
		valid[i] = struct{}{}
	}

	for i := 1; i < math.MaxInt; i++ {
		if _, found := valid[i]; !found {
			return i, true
		}
	}

	var no int
	return no, false
}
