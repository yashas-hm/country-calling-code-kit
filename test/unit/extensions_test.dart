import 'package:country_calling_code_kit/src/core/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('firstWhereOrNull', () {
    test('returns the first matching element', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.firstWhereOrNull((e) => e > 3), 4);
    });

    test('returns null when no element matches', () {
      final list = [1, 2, 3];
      expect(list.firstWhereOrNull((e) => e > 10), isNull);
    });

    test('returns null for an empty list', () {
      final list = <int>[];
      expect(list.firstWhereOrNull((e) => true), isNull);
    });

    test('preserves list order, returning the earliest match', () {
      final list = ['a', 'bb', 'ccc', 'dddd'];
      expect(list.firstWhereOrNull((e) => e.length >= 2), 'bb');
    });

    test('works with nullable-typed elements', () {
      final list = <String?>[null, null, 'x'];
      expect(list.firstWhereOrNull((e) => e != null), 'x');
    });
  });
}
