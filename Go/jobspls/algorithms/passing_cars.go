package algorithms

func PassingCars(cars []int) int {
	west := 0
	total := 0

	for _, car := range cars {
		switch car {
		case 0:
			west += 1
		case 1:
			total += west
		}
	}

	return total
}
