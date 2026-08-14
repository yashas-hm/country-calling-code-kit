import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('countries', () {
    test('is not empty', () {
      expect(countries, isNotEmpty);
    });

    test('contains an entry for every CountryCode enum value', () {
      final codesInList = countries.map((c) => c.countryCode).toSet();
      final missing = CountryCode.values.where(
        (code) => !codesInList.contains(code),
      );
      expect(missing, isEmpty);
    });

    test('has a unique entry per CountryCode', () {
      final codes = countries.map((c) => c.countryCode).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('every country has a non-empty name', () {
      for (final country in countries) {
        expect(
          country.name.trim(),
          isNotEmpty,
          reason: 'Empty name for ${country.countryCode}',
        );
      }
    });

    test('every country has a calling code prefixed with +', () {
      for (final country in countries) {
        expect(
          country.callCode.startsWith('+'),
          isTrue,
          reason:
              'Bad callCode "${country.callCode}" for ${country.countryCode}',
        );
      }
    });

    test('every country has a flag asset scoped to this package', () {
      for (final country in countries) {
        expect(
          country.flag,
          startsWith('packages/country_calling_code_kit/assets/flags/'),
          reason: 'Bad flag path for ${country.countryCode}',
        );
        expect(
          country.flag,
          endsWith('.png'),
          reason: 'Bad flag extension for ${country.countryCode}',
        );
      }
    });

    test('spot check well known countries', () {
      final us = getCountryByCountryCode(CountryCode.us);
      expect(us?.name, 'United States of America');
      expect(us?.callCode, '+1');

      final india = getCountryByCountryCode(CountryCode.in_);
      expect(india?.name, 'India');
      expect(india?.callCode, '+91');

      final uk = getCountryByCountryCode(CountryCode.gb);
      expect(uk?.callCode, '+44');
    });
  });
}
