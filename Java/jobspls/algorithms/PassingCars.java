package jobspls.algorithms;

public class PassingCars {
    public static int passing_cars(int[] cars) {
        var west = 0;
        var total = 0;

        for (var car : cars) {
            if (car == 0) {
                west++;
            } else {
                // One eastbound car will pass `west` westbound cars
                total += west;
            }
        }

        return total;
    }
}
