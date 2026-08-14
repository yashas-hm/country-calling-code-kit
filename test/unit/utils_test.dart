import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('device_region');

  void mockSimCountryCode(Object? Function(MethodCall call) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => handler(call));
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
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
    test('returns the matching country for a valid SIM country code', () async {
      mockSimCountryCode((_) => 'fr');

      final result = await getDefaultCountry();

      expect(result?.countryCode, CountryCode.fr);
    });

    test('matches the SIM country code case-insensitively', () async {
      mockSimCountryCode((_) => 'GB');

      final result = await getDefaultCountry();

      expect(result?.countryCode, CountryCode.gb);
    });

    test('falls back to the first country when the SIM country code is null',
        () async {
      mockSimCountryCode((_) => null);

      final result = await getDefaultCountry();

      expect(result?.countryCode, CountryCode.values.first);
    });

    test(
        'falls back to the first country when the SIM country code is unrecognized',
        () async {
      mockSimCountryCode((_) => 'zz-unknown');

      final result = await getDefaultCountry();

      expect(result?.countryCode, CountryCode.values.first);
    });

    test('returns null when the platform channel throws', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'UNAVAILABLE');
      });

      final result = await getDefaultCountry();

      expect(result, isNull);
    });

    test('returns null when no platform implementation is registered',
        () async {
      // No mock handler installed for this test: invoking the channel
      // throws a MissingPluginException, which getDefaultCountry should
      // swallow and translate into a null result.
      final result = await getDefaultCountry();

      expect(result, isNull);
    });
  });
}
