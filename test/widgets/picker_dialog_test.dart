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

  desktopTestWidgets('opens a dialog containing the CountryPicker', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness((context) => showCountryPickerDialog(context: context)),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Afghanistan'), findsOneWidget);
  });

  desktopTestWidgets('resolves the returned future with the selected country', (
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

  desktopTestWidgets(
    'resolves with null when dismissed by tapping the barrier',
    (tester) async {
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
    },
  );

  desktopTestWidgets('forwards preferredCountries to the picker', (
    tester,
  ) async {
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

  desktopTestWidgets('forwards search:false to the picker', (tester) async {
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerDialog(context: context, search: false),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
  });

  desktopTestWidgets('constrains the dialog width to maxWidth', (tester) async {
    // Note: Material's Dialog enforces a built-in minWidth of 280, so use a
    // maxWidth above that floor. The default (unconstrained) width here would
    // be shortestSide * 0.90 = 540, so 350 proves the constraint is applied.
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerDialog(context: context, maxWidth: 350),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(CountryPicker)).width,
      lessThanOrEqualTo(350),
    );
  });

  desktopTestWidgets('constrains the dialog height to maxHeight', (
    tester,
  ) async {
    // Default height here would be screenHeight * 0.80 = 480, so 200 proves
    // the constraint is applied.
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerDialog(context: context, maxHeight: 200),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(CountryPicker)).height,
      lessThanOrEqualTo(200),
    );
  });

  desktopTestWidgets('applies a custom shape to the dialog', (tester) async {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    );
    await tester.pumpWidget(
      harness(
        (context) => showCountryPickerDialog(context: context, shape: shape),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<Dialog>(find.byType(Dialog));
    expect(dialog.shape, shape);
  });
}
