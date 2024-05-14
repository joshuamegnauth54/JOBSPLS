package jobspls.algorithms;

import java.util.Arrays;

public class LeftRightMinSum {
    public static int min_sum(int[] values) {
        var right = Arrays.stream(values).sum();
        var left = 0;
        var min_diff = Integer.MAX_VALUE;

        for (var n : values) {
            left += n;
            right -= n;
            var diff = Math.abs(right - left);
            min_diff = Math.min(diff, min_diff);
        }

        return min_diff;
    }
}
