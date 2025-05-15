/// Utility functions for working with country data.
library;

import 'package:country_calling_code_kit/src/core/constants.dart';
import 'package:country_calling_code_kit/src/core/country.dart';
import 'package:country_calling_code_kit/src/core/extensions.dart';
import 'package:device_region/device_region.dart';

/// Attempts to get the default country based on the device's SIM card.
///
/// This function uses the device_region package to get the SIM country code
/// and then finds the corresponding Country object.
///
/// Returns a [Country] object if successful, or `null` if:
/// - The device doesn't have a SIM card
/// - The SIM country code couldn't be determined
/// - An error occurred during the process
/// - No matching country was found for the SIM country code
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
  try {
    final countryCode = await DeviceRegion.getSIMCountryCode();
    return countries.firstWhereOrNull(
      (element) => element.countryCode == CountryCode.fromString(countryCode),
    );
  } catch (e) {
    return null;
  }
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
