package algorithms

import "math"

// A.k.a tape equilibrium
func LeftRightMinSum(values []int) int {
	// `right` is the sum of everything to the right of `left`
	// The base case is the total sum as `left` is 0
	right := 0
	for _, v := range values {
		right += v
	}

	left := 0
	minDiff := math.MaxInt
	for _, v := range values {
		// Slide a window through the array.
		left += v
		right -= v
		diff := int(math.Abs(float64(right) - float64(left)))
		minDiff = min(minDiff, diff)
	}

	return minDiff
}
