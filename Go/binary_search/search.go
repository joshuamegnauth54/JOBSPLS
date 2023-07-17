package binary_search

import (
	"golang.org/x/exp/constraints"
	"math"
)

func binary_search[T constraints.Ordered](vec []T, find T) *int {
	var lower int
	upper := len(vec) - 1

	for lower <= upper {
		index := int(math.Floor((float64(lower) + float64(upper)) / 2))
		element := vec[index]

		if element < find {
			lower = index + 1
		} else if element > find {
			upper = index - 1

		} else {
			return &index
		}

	}

	return nil
}
