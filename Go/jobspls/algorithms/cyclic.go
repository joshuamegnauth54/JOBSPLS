package algorithms

// Rotate an array 
func Rotate[T any](values []T, by int) []T {
	shifted := make([]T, len(values))

	for i, v := range values {
		j := (i + by) % len(values)
		shifted[j] = v
	}

	return shifted
}

