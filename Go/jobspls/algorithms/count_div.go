package algorithms

func CountDiv(low, high, k int) int {
	if low > high || k == 0 {
		return 0
	}
	// I dunno why the problem needs this
	extra := 0
	if low%k == 0 {
		extra = 1
	}
	// Intuitive
	// high/k is all of the nums in high divisible by k
	// Same for low
	// Subtracting the two yields the numbers in the range divisible by k
	return int(high/k-low/k) + extra
}
