library;

import 'package:country_calling_code_kit/src/core/constants.dart';
import 'package:country_calling_code_kit/src/core/country.dart';
import 'package:country_calling_code_kit/src/core/extensions.dart';
import 'package:flutter/widgets.dart';

/// Attempts to get the default country based on the device's locale.
///
/// This function reads the region of the platform locale
/// ([WidgetsBinding.platformDispatcher]) and finds the corresponding Country
/// object. It uses no platform plugins, so it works on every supported platform
/// (including Web and WASM) without native code or permissions.
///
/// Returns a [Country] object if successful, or `null` if:
/// - The locale has no region/country component
/// - No matching country was found for the locale's country code
///
/// Example:
/// ```dart
/// final defaultCountry = await getDefaultCountry();
/// if (defaultCountry != null) {
///   print('Device country: ${defaultCountry.name}');
/// } else {
///   print('Could not determine device country');
/// }
/// ```
Future<Country?> getDefaultCountry() async {
  final countryCode =
      WidgetsBinding.instance.platformDispatcher.locale.countryCode;
  if (countryCode == null) return null;
  return countries.firstWhereOrNull(
    (element) => element.countryCode == CountryCode.fromString(countryCode),
  );
}

/// Finds a [Country] by its [CountryCode].
///
/// This function searches the list of countries for one with the specified country code.
///
/// Returns the matching [Country] object, or `null` if no country with the
/// specified code was found.
///
/// Example:
/// ```dart
/// final usa = getCountryByCountryCode(CountryCode.us);
/// if (usa != null) {
///   print('USA calling code: ${usa.callCode}');
/// }
/// ```
///
/// @param countryCode The country code to search for
/// @return The matching Country object or null if not found
Country? getCountryByCountryCode(CountryCode countryCode) {
  return countries.firstWhereOrNull(
    (element) => element.countryCode == countryCode,
  );
}
