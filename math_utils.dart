// lib/utils/math_utils.dart

extension MinMax on num {
  num clamp(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}