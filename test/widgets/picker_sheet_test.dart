import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/desktop_test_widgets.dart';

void main() {
  Widget harness(Future<void> Function(BuildContext context) onPressed) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => onPressed(context),
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  desktopTestWidgets('opens a modal bottom sheet containing the CountryPicker',
      (
    tester,
  ) async {
    await tester.pumpWidget(
      harness((context) => showCountryPickerModalSheet(context: context)),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Afghanistan'), findsOneWidget);
  });

  desktopTestWidgets('resolves the returned future with the selected country', (
    tester,
  ) async {
    Country? result;
    await tester.pumpWidget(
      harness((context) async {
        result = await showCountryPickerModalSheet(context: context);
      }),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Afghanistan'));
    await tester.pumpAndSettle();

    expect(result?.countryCode, CountryCode.af);
    expect(find.text('Afghanistan'), findsNothing);
  });

  desktopTestWidgets('resolves with null when dismissed by tapping the scrim', (
    tester,
  ) async {
    Country? result;
    bool completed = false;
    await tester.pumpWidget(
      harness((context) async {
        result = await showCountryPickerModalSheet(context: context);
        completed = true;
      }),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(result, isNull);
  });

  desktopTestWidgets('forwards preferredCountries to the picker',
      (tester) async {
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerModalSheet(
          context: context,
          preferredCountries: [CountryCode.de],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Germany'), findsOneWidget);
  });

  desktopTestWidgets('forwards search:false to the picker', (tester) async {
    await tester.pumpWidget(
      harness(
        (context) =>
            showCountryPickerModalSheet(context: context, search: false),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
  });

  desktopTestWidgets('constrains the sheet width to maxWidth', (tester) async {
    await tester.pumpWidget(
      harness(
        (context) =>
            showCountryPickerModalSheet(context: context, maxWidth: 200),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(CountryPicker)).width,
        lessThanOrEqualTo(200));
  });

  desktopTestWidgets('constrains the sheet height to maxHeight',
      (tester) async {
    // Default height here would be screenHeight * 0.85 = 510, so 250 proves
    // the constraint is applied.
    await tester.pumpWidget(
      harness(
        (context) =>
            showCountryPickerModalSheet(context: context, maxHeight: 250),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(CountryPicker)).height,
        lessThanOrEqualTo(250));
  });

  desktopTestWidgets('applies a custom shape to the sheet', (tester) async {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    );
    await tester.pumpWidget(
      harness(
        (context) =>
            showCountryPickerModalSheet(context: context, shape: shape),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
    expect(sheet.shape, shape);
  });
}
