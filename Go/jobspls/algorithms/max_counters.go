package algorithms

func MaxCounters(n_counters int, operations []int) []int {
	counters := make([]int, n_counters)
	cur_max := 0
	last_max := 0

	for _, op := range operations {
		if op < n_counters+1 {
			// Increase counter operation
			current := counters[op-1]

			// If current is smaller than last_max, the value at this index
			// hasn't been updated to last_max yet
			if current < last_max {
				current = last_max
			}
			current += 1

			counters[op-1] = current
			if current > cur_max {
				cur_max = current
			}
		} else {
			last_max = cur_max
		}
	}

	// Update any counter values that should be set to the maximum
	for i, counter := range counters {
		if counter < last_max {
			counters[i] = last_max
		}
	}

	return counters
}
