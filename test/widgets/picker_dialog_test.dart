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

  testWidgets('opens a dialog containing the CountryPicker', (tester) async {
    await tester.pumpWidget(
      harness((context) => showCountryPickerDialog(context: context)),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Afghanistan'), findsOneWidget);
  });

  testWidgets('resolves the returned future with the selected country', (
    tester,
  ) async {
    Country? result;
    await tester.pumpWidget(
      harness((context) async {
        result = await showCountryPickerDialog(context: context);
      }),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Afghanistan'));
    await tester.pumpAndSettle();

    expect(result?.countryCode, CountryCode.af);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('resolves with null when dismissed by tapping the barrier', (
    tester,
  ) async {
    Country? result;
    bool completed = false;
    await tester.pumpWidget(
      harness((context) async {
        result = await showCountryPickerDialog(context: context);
        completed = true;
      }),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
    expect(result, isNull);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('forwards preferredCountries to the picker', (tester) async {
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerDialog(
          context: context,
          preferredCountries: [CountryCode.jp],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Japan'), findsOneWidget);
  });

  testWidgets('forwards search:false to the picker', (tester) async {
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerDialog(context: context, search: false),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
  });
}
