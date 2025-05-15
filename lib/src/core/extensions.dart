/// Extension methods for [List] class.
extension ListExt<T> on List<T> {
  /// Returns the first element that satisfies the given predicate [test], or `null` if none is found.
  ///
  /// This method is similar to [List.firstWhere], but instead of throwing a [StateError]
  /// when no element satisfies the predicate, it returns `null`.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// final result = list.firstWhereOrNull((e) => e > 10); // Returns null
  /// final found = list.firstWhereOrNull((e) => e > 3);   // Returns 4
  /// ```
  ///
  /// @param test A function that returns true if the element matches the condition
  /// @return The first matching element or null if no element matches
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
