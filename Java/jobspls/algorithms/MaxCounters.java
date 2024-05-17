package jobspls.algorithms;

public class MaxCounters {
    public static int[] max_counters(int n_counters, int[] operations) {
        var counters = new int[n_counters];
        int cur_max = 0;
        int last_max = 0;

        for (var i = 0; i < operations.length; i++) {
            var op = operations[i];
            if (op < n_counters + 1) {
                var current = counters[op - 1];
                if (current < last_max) {
                    current = last_max;
                }
                current++;

                if (current > cur_max) {
                    cur_max = current;
                }
                
                counters[op - 1] = current;
            } else {
                last_max = cur_max;
            }
        }

        for (var i = 0; i < n_counters; i++) {
            if (counters[i] < last_max) {
                counters[i] = last_max;
            }
        }

        return counters;
    }
}
