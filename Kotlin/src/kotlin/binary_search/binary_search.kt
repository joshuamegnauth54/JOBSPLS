package jobspls.binary_search

fun <T : Comparable<T>> List<T>.binary_search(find: T): Int? {
    var lower = 0
    var upper = this.size - 1
    var index: Int = 0

    while (lower <= upper) {
        index = (lower + upper).floorDiv(2)
        val atIndex = this[index]

        when {
            atIndex < find -> lower = index + 1
            atIndex > find -> upper = index - 1
            else -> return index
        }
    }

    index
}
