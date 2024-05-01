package algorithms

import "fmt"

func BinaryGap(i int) int {
	binary := fmt.Sprintf("%b", i)
	gap := 0
	current := 0

	for _, n := range binary {
		if n == '1' {
			if current > gap {
				gap = current
			}
			current = 0
		} else {
			current++
		}
	}

	return gap
}
