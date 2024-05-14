package algorithms

// When can froggy jump to the other side of the river?
//
// Froggy needs 1 to `jumps` leaves.
// `leaves` is a slice of flowing leaves where each index is a second of time
func FrogRiverJump(jumps int, leaves []int) (int, bool) {
	required := make(map[int]struct{}, jumps)
	for i := 1; i <= jumps; i++ {
		required[i] = struct{}{}
	}

	for time, leaf := range leaves {
		delete(required, leaf)
		if len(required) == 0 {
			return time, true
		}
	}

	var nope int
	return nope, false
}
