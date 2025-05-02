class NumberUtils {
  static String decimalFormattedValue(double value, int afterDecimal) {
    return value % 1 == 0
        ? value.toInt().toString() // Show as "40"
        : value.toStringAsFixed(afterDecimal); //
  }
}
