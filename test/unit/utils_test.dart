import 'dart:ui';

import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  void mockLocale(Locale locale) {
    binding.platformDispatcher.localeTestValue = locale;
  }

  tearDown(() {
    binding.platformDispatcher.clearLocaleTestValue();
  });

  group('getCountryByCountryCode', () {
    test('returns the matching country', () {
      final result = getCountryByCountryCode(CountryCode.us);
      expect(result, isNotNull);
      expect(result!.countryCode, CountryCode.us);
      expect(result.callCode, '+1');
    });

    test('returns a matching country for every enum value', () {
      for (final code in CountryCode.values) {
        expect(
          getCountryByCountryCode(code),
          isNotNull,
          reason: 'No country found for $code',
        );
      }
    });
  });

  group('getDefaultCountry', () {
    test('returns the matching country for a valid locale region', () async {
      mockLocale(const Locale('fr', 'FR'));

      final result = await getDefaultCountry();

      expect(result?.countryCode, CountryCode.fr);
    });

    test('matches the locale region case-insensitively', () async {
      mockLocale(const Locale('en', 'GB'));

      final result = await getDefaultCountry();

      expect(result?.countryCode, CountryCode.gb);
    });

    test('returns null when the locale has no region', () async {
      mockLocale(const Locale('en'));

      final result = await getDefaultCountry();

      expect(result, isNull);
    });

    test(
      'falls back to the first country when the locale region is unrecognized',
      () async {
        mockLocale(const Locale('en', 'ZZ'));

        final result = await getDefaultCountry();

        expect(result?.countryCode, CountryCode.values.first);
      },
    );
  });
}
