package jobspls.algorithms;

import java.lang.Math;
import java.util.OptionalInt;

public class FrogJump {
    public static OptionalInt frog_jump(int start, int dest, int dist) {
        if (
            start > dest ||
            start < 0 ||
            dest < 0 ||
            dist <= 0
        ) {
            return OptionalInt.empty();
        }

        var diff = dest - start;
        var jumps = (int)(diff/dist) + (int)(Math.min(1.0, diff%dist));

        return OptionalInt.of(jumps);
    }
}
