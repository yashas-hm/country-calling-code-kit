library;

import 'dart:io';

import 'package:country_calling_code_kit/src/core/constants.dart';
import 'package:country_calling_code_kit/src/core/country.dart';
import 'package:country_calling_code_kit/src/core/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that displays a searchable list of countries with their flags and calling codes.
///
/// This widget is the core UI component of the country_calling_code_kit package.
/// It displays a list of countries with their flags, names, and optionally their
/// calling codes. It also provides a search functionality to filter countries.
///
/// The widget attempts to determine the user's country based on the device's SIM card
/// and displays it at the top of the list. It also supports displaying a list of
/// preferred countries at the top.
///
/// This widget is used by [showCountryPickerDialog] and [showCountryPickerModalSheet]
/// to provide a consistent UI for country selection.
class CountryPicker extends StatefulWidget {
  /// Creates a new [CountryPicker] widget.
  ///
  /// The [onSelected] callback is required and is called when a country is selected.
  ///
  /// Other parameters allow customization of the appearance and behavior of the widget:
  /// - [countryNameTextStyle]: Custom text style for country names
  /// - [countryCallCodeTextStyle]: Custom text style for calling codes
  /// - [imageSize]: Custom size for flag images
  /// - [searchFilter]: Custom function for filtering countries during search
  /// - [splashColor]: Custom splash color for item selection
  /// - [hoverColor]: Custom hover color for items (on web/desktop)
  /// - [preferredCountries]: List of country codes to display at the top of the list
  /// - [showCallCode]: Whether to show calling codes next to country names
  /// - [search]: Whether to show the search bar
  const CountryPicker({
    super.key,
    required this.onSelected,
    this.countryNameTextStyle,
    this.countryCallCodeTextStyle,
    this.imageSize,
    this.searchFilter,
    this.splashColor,
    this.hoverColor,
    this.preferredCountries,
    this.showCallCode = false,
    this.search = true,
  });

  /// Callback that is called when a country is selected.
  ///
  /// This callback receives the selected [Country] object.
  final ValueChanged<Country> onSelected;

  /// Custom text style for country names.
  ///
  /// If not provided, a default style with fontSize 15 is used.
  final TextStyle? countryNameTextStyle;

  /// Custom text style for country calling codes.
  ///
  /// If not provided, a default style with fontSize 13 and fontWeight bold is used.
  final TextStyle? countryCallCodeTextStyle;

  /// Custom size for flag images.
  ///
  /// If not provided, flags are displayed with a height of 25 and width of 40.
  final Size? imageSize;

  /// Custom splash color for item selection.
  ///
  /// If not provided, the theme's primary color is used.
  final Color? splashColor;

  /// Custom hover color for items (on web/desktop).
  ///
  /// If not provided, the theme's secondary color with reduced opacity is used.
  final Color? hoverColor;

  /// Custom function for filtering countries during search.
  ///
  /// If provided, this function is used instead of the default filtering logic.
  /// The function receives the search text and should return a filtered list of countries.
  final List<Country> Function(String text)? searchFilter;

  /// List of country codes to display at the top of the list.
  ///
  /// These countries will be shown first in the order provided.
  final List<CountryCode>? preferredCountries;

  /// Whether to show calling codes next to country names.
  ///
  /// Defaults to false.
  final bool showCallCode;

  /// Whether to show the search bar.
  ///
  /// Defaults to true.
  final bool search;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final textEditController = TextEditingController();

  late final List<Country> initialCountries;

  List<Country> filteredCountries = [];
  bool loading = true;

  @override
  void initState() {
    setInitialCountries();
    super.initState();
  }

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  void setInitialCountries() async {
    List<Country> list = countries;

    if (widget.preferredCountries != null) {
      if (widget.preferredCountries!.isNotEmpty) {
        list = countries
            .where(
              (country) =>
                  !widget.preferredCountries!.contains(country.countryCode),
            )
            .toList();
        for (var country in widget.preferredCountries!.reversed) {
          list.insert(0, getCountryByCountryCode(country)!);
        }
      }
    }

    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      final defCountry = await getDefaultCountry();
      if (defCountry != null) {
        list = countries
            .where((country) => country.countryCode != defCountry.countryCode)
            .toList();
        list.insert(0, defCountry);
      }
    }

    initialCountries = list;
    filteredCountries = initialCountries;

    setState(() {
      loading = false;
    });
  }

  void filterText(String text) {
    if (widget.searchFilter != null) {
      filteredCountries = widget.searchFilter!(text);
    } else {
      if (text.isEmpty) {
        filteredCountries = initialCountries;
      } else {
        filteredCountries = initialCountries
            .where(
              (country) =>
                  country.name.toLowerCase().startsWith(text.toLowerCase()) ||
                  country.countryCode.toString().toLowerCase().startsWith(
                        text.toLowerCase(),
                      ) ||
                  country.callCode.toLowerCase().startsWith(text.toLowerCase()),
            )
            .toList();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            if (widget.search)
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 23,
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: textEditController,
                          onChanged: filterText,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    if (textEditController.text.isNotEmpty)
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        hoverColor: Platform.isAndroid || Platform.isIOS
                            ? null
                            : widget.hoverColor ??
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.1),
                        splashColor: widget.splashColor ??
                            Theme.of(context).primaryColor,
                        onTap: () {
                          textEditController.clear();
                          filterText('');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.clear,
                            size: 20,
                            color:
                                Theme.of(context).textTheme.bodySmall?.color ??
                                    (Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black.withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.5)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredCountries.length,
                itemBuilder: (_, index) => InkWell(
                  hoverColor: Platform.isAndroid || Platform.isIOS
                      ? null
                      : widget.hoverColor ??
                          Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.1),
                  splashColor:
                      widget.splashColor ?? Theme.of(context).primaryColor,
                  onTap: () => widget.onSelected(filteredCountries[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 15,
                      children: [
                        Image.asset(
                          filteredCountries[index].flag,
                          fit: BoxFit.fill,
                          height: widget.imageSize?.height ?? 25,
                          width: widget.imageSize?.width ?? 40,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              filteredCountries[index].name,
                              style: widget.countryNameTextStyle ??
                                  TextStyle(fontSize: 15),
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              filteredCountries[index].callCode,
                              textAlign: TextAlign.left,
                              style: widget.countryCallCodeTextStyle ??
                                  TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
