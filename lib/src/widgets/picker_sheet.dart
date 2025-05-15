library;

import 'package:country_calling_code_kit/src/core/country.dart';
import 'package:country_calling_code_kit/src/widgets/picker_widget.dart';
import 'package:flutter/material.dart';

/// Shows a modal sheet with a country picker.
///
/// This function displays a modal sheet containing a [CountryPicker] widget,
/// allowing the user to select a country from a searchable list.
///
/// The modal sheet is displayed using [showModalBottomSheet], which adapts to the
/// platform's native modal sheet style.
///
/// Example:
/// ```dart
/// final selectedCountry = await showCountryPickerModalSheet(
///   context: context,
///   preferredCountries: [CountryCode.us, CountryCode.ca],
/// );
///
/// if (selectedCountry != null) {
///   print('Selected: ${selectedCountry.name} (${selectedCountry.callCode})');
/// }
/// ```
///
/// Parameters:
/// - [context]: The build context (required)
/// - [countryNameTextStyle]: Custom text style for country names
/// - [countryCallCodeTextStyle]: Custom text style for calling codes
/// - [imageSize]: Custom size for flag images
/// - [splashColor]: Custom splash color for item selection
/// - [hoverColor]: Custom hover color for items (on web/desktop)
/// - [searchFilter]: Custom function for filtering countries during search
/// - [preferredCountries]: List of country codes to display at the top of the list
/// - [showCallCode]: Whether to show calling codes next to country names (defaults to true)
/// - [search]: Whether to show the search bar (defaults to true)
/// - [returnOnlyCallCode]: If true, returns only the calling code string instead of the Country object
///
/// Returns a [Future] that completes with the selected [Country] object,
/// or with the calling code string if [returnOnlyCallCode] is true,
/// or with `null` if the modal sheet is dismissed without selection.
Future<Country?> showCountryPickerModalSheet({
  required BuildContext context,
  TextStyle? countryNameTextStyle,
  TextStyle? countryCallCodeTextStyle,
  Size? imageSize,
  Color? splashColor,
  Color? hoverColor,
  List<Country> Function(String text)? searchFilter,
  List<CountryCode>? preferredCountries,
  bool showCallCode = true,
  bool search = true,
  bool returnOnlyCallCode = false,
}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) => CountryPicker(
        onSelected: (country) => Navigator.of(ctx)
            .pop(returnOnlyCallCode ? country.callCode : country),
        countryNameTextStyle: countryNameTextStyle,
        countryCallCodeTextStyle: countryCallCodeTextStyle,
        imageSize: imageSize,
        splashColor: splashColor,
        hoverColor: hoverColor,
        searchFilter: searchFilter,
        preferredCountries: preferredCountries,
        showCallCode: showCallCode,
        search: search,
      ),
    );
