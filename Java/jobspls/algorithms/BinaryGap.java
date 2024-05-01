package jobspls.algorithms;

public class BinaryGap {
    public static int binary_gap(int i) {
        var binary = Integer.toBinaryString(i);
        var gap = 0;
        var current = 0;

        for (var b : binary.toCharArray()) {
            if (b == '1') {
                if (current > gap) {
                    gap = current;
                }
                current = 0;
            } else {
                ++current;
            }
        }

        return gap;
    }
}
