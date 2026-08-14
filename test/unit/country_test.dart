import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Country', () {
    test('stores all provided fields', () {
      const country = Country(
        name: 'Testland',
        flag: 'assets/flags/test.png',
        countryCode: CountryCode.us,
        callCode: '+1',
      );

      expect(country.name, 'Testland');
      expect(country.flag, 'assets/flags/test.png');
      expect(country.countryCode, CountryCode.us);
      expect(country.callCode, '+1');
    });
  });

  group('CountryCode.toString', () {
    test('returns the plain enum name for a code with no keyword conflict', () {
      expect(CountryCode.us.toString(), 'us');
      expect(CountryCode.gb.toString(), 'gb');
      expect(CountryCode.af.toString(), 'af');
    });

    test('strips the trailing underscore for keyword-conflicting codes', () {
      expect(CountryCode.do_.toString(), 'do');
      expect(CountryCode.is_.toString(), 'is');
      expect(CountryCode.in_.toString(), 'in');
    });
  });

  group('CountryCode.fromString', () {
    test('matches an exact lower-case code', () {
      expect(CountryCode.fromString('us'), CountryCode.us);
      expect(CountryCode.fromString('fr'), CountryCode.fr);
    });

    test('matches case-insensitively', () {
      expect(CountryCode.fromString('US'), CountryCode.us);
      expect(CountryCode.fromString('gB'), CountryCode.gb);
    });

    test('matches keyword-conflicting codes by their stripped form', () {
      expect(CountryCode.fromString('do'), CountryCode.do_);
      expect(CountryCode.fromString('IS'), CountryCode.is_);
      expect(CountryCode.fromString('In'), CountryCode.in_);
    });

    test('falls back to the first enum value when value is null', () {
      expect(CountryCode.fromString(null), CountryCode.values.first);
    });

    test('falls back to the first enum value for an empty string', () {
      expect(CountryCode.fromString(''), CountryCode.values.first);
    });

    test('falls back to the first enum value when no match is found', () {
      expect(CountryCode.fromString('zz-unknown'), CountryCode.values.first);
    });
  });
}
