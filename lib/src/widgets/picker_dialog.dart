library;

import 'package:country_calling_code_kit/src/core/country.dart';
import 'package:country_calling_code_kit/src/widgets/picker_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Shows a dialog with a country picker.
///
/// This function displays a dialog containing a [CountryPicker] widget,
/// allowing the user to select a country from a searchable list.
///
/// The dialog is displayed using [showAdaptiveDialog], which adapts to the
/// platform's native dialog style.
///
/// Example:
/// ```dart
/// final selectedCountry = await showCountryPickerDialog(
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
/// - [flagCornerRadius]: Corner Radius for flag images
/// - [itemBorderRadius]: Corner radius for each country list item (defaults to 10)
/// - [maxWidth]: Maximum width of the dialog (defaults to unconstrained)
/// - [maxHeight]: Maximum height of the dialog (defaults to 80% of the screen height)
/// - [shape]: Shape border of the dialog (defaults to a 20px rounded rectangle)
///
/// Returns a [Future] that completes with the selected [Country] object
/// or with `null` if the dialog is dismissed without selection.
Future<Country?> showCountryPickerDialog({
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
  double? flagCornerRadius,
  double? itemBorderRadius,
  double? maxWidth,
  double? maxHeight,
  ShapeBorder? shape,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.80,
            maxWidth:
                maxWidth ?? MediaQuery.of(context).size.shortestSide * 0.90,
          ),
          child: CountryPicker(
            onSelected: (country) => Navigator.of(
              ctx,
            ).pop(country),
            countryNameTextStyle: countryNameTextStyle,
            countryCallCodeTextStyle: countryCallCodeTextStyle,
            imageSize: imageSize,
            splashColor: splashColor,
            hoverColor: hoverColor,
            searchFilter: searchFilter,
            preferredCountries: preferredCountries,
            showCallCode: showCallCode,
            search: search,
            flagCornerRadius: flagCornerRadius,
            itemBorderRadius: itemBorderRadius,
          ),
        ),
      ),
    );
