package jobspls.algorithms;

public class CountDiv {
    public static int count_div(int low, int high, int k) {
        if (low > high || k == 0) {
            return 0;
        }
        int extra = (low % k == 0) ? 1 : 0;
        return Math.floorDiv(high, k) - Math.floorDiv(low, k) + extra;
    }
}
