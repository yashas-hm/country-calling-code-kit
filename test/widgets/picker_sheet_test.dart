import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

  testWidgets('opens a modal bottom sheet containing the CountryPicker', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness((context) => showCountryPickerModalSheet(context: context)),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Afghanistan'), findsOneWidget);
  });

  testWidgets('resolves the returned future with the selected country', (
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

  testWidgets('resolves with null when dismissed by tapping the scrim', (
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

  testWidgets('forwards preferredCountries to the picker', (tester) async {
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

  testWidgets('forwards search:false to the picker', (tester) async {
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
}
