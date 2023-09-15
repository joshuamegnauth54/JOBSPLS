package search

import (
	"errors"
	"golang.org/x/exp/constraints"
	"math"
)

func binary[T constraints.Ordered](vec []T, find T) (int, error) {
	var lower int
	upper := len(vec)

	for lower <= upper {
		index := int(math.Floor((float64(lower) + float64(upper)) / 2))
		element := vec[index]

		if element < find {
			lower = index + 1
		} else if element > find {
			upper = index - 1
		} else {
			return index, nil
		}
	}

	return -1, errors.New("Value not found")
}
