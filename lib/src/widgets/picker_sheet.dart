import 'package:country_calling_code_kit/src/core/country.dart';
import 'package:country_calling_code_kit/src/widgets/picker_widget.dart';
import 'package:flutter/material.dart';

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
