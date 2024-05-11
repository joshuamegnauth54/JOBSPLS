package main

import (
	"fmt"
	"math"
)

// How many jumps does it take to reach dest by dist?
func FrogJump(start, dest, dist uint) (uint, error) {
	if start > dest {
		return 0, fmt.Errorf("start > dest")
	}

	diff := dest - start
	jumps := uint(diff/dist) + uint(math.Min(1.0, float64(diff%dist)))

	return jumps, nil
}
