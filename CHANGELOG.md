## 1.0.0

* Initial release of country_calling_code_kit
* Features:
  * Country selection via dialog or bottom sheet
  * Default country detection based on device settings
  * Display of country flags, names, and calling codes
  * Support for all major platforms (Android, iOS, Web, macOS, Linux, Windows)

## 1.0.1

* README update

## 1.0.2

* Bug Fixes
* Added Documentation

## 1.1.0

* Bug Fixes
* Ability to change corner radius for flag images

## 2.0.0

* Removed the `device_region` plugin dependency; the package now has no
  non-SDK dependencies.
* `getDefaultCountry()` now detects the region from the platform locale
  instead of the SIM card, making the package fully WASM-compatible and
  supported on all six platforms (including Web and macOS) with no native
  code or permissions. **Breaking:** it now returns `null` when the platform
  locale has no region component (previously it fell back to the first
  country).
* Added `itemBorderRadius` to `CountryPicker`, `showCountryPickerDialog`, and
  `showCountryPickerModalSheet` to control the corner radius of each list
  item (defaults to 10).
* Added `maxWidth` to `showCountryPickerDialog` and
  `showCountryPickerModalSheet` to constrain the width of the dialog/sheet.
* Added `maxHeight` to `showCountryPickerDialog` and
  `showCountryPickerModalSheet` to constrain the height of the dialog/sheet
  (defaults to 80%/85% of the screen height respectively).
* Added `shape` to `showCountryPickerDialog` and
  `showCountryPickerModalSheet` to customize the shape border of the
  dialog/sheet (defaults to rounded corners).
