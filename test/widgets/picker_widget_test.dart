import 'package:country_calling_code_kit/country_calling_code_kit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/desktop_test_widgets.dart';

void main() {
  Widget wrap(Widget child, {ThemeData? theme}) => MaterialApp(
    theme: theme,
    home: Scaffold(body: child),
  );

  group('CountryPicker', () {
    desktopTestWidgets(
      'renders the full country list with a search bar by default',
      (tester) async {
        await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Afghanistan'), findsOneWidget);
      },
    );

    desktopTestWidgets('hides the search bar when search is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (_) {}, search: false)),
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.text('Afghanistan'), findsOneWidget);
    });

    desktopTestWidgets(
      'filters the list by country name prefix, case-insensitively',
      (tester) async {
        await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

        await tester.enterText(find.byType(TextField), 'Ind');
        await tester.pump();

        expect(find.text('India'), findsOneWidget);
        expect(find.text('Indonesia'), findsOneWidget);
        expect(find.text('Afghanistan'), findsNothing);
      },
    );

    desktopTestWidgets('filters the list by ISO country code prefix', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      await tester.enterText(find.byType(TextField), 'us');
      await tester.pump();

      expect(find.text('United States of America'), findsOneWidget);
      expect(
        find.text('United Kingdom of Great Britain and Northern Ireland'),
        findsNothing,
      );
    });

    desktopTestWidgets('filters the list by calling code prefix', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      await tester.enterText(find.byType(TextField), '+91');
      await tester.pump();

      expect(find.text('India'), findsOneWidget);
      expect(find.text('Pakistan'), findsNothing);
    });

    desktopTestWidgets('shows an empty list for a query matching nothing', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      await tester.enterText(find.byType(TextField), 'zzzzz-no-match');
      await tester.pump();

      expect(find.text('Afghanistan'), findsNothing);
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.childrenDelegate.estimatedChildCount, 0);
    });

    desktopTestWidgets(
      'clears the search text and restores the full list when the clear icon is tapped',
      (tester) async {
        await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

        await tester.enterText(find.byType(TextField), 'Ind');
        await tester.pump();
        expect(find.text('Afghanistan'), findsNothing);
        expect(find.byIcon(Icons.clear), findsOneWidget);

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(find.text('Afghanistan'), findsOneWidget);
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller!.text, isEmpty);
      },
    );

    desktopTestWidgets('hides the clear icon when the search text is empty', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      expect(find.byIcon(Icons.clear), findsNothing);
    });

    desktopTestWidgets('uses a custom searchFilter when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CountryPicker(
            onSelected: (_) {},
            searchFilter: (text) => [
              countries.firstWhere((c) => c.countryCode == CountryCode.fr),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'anything');
      await tester.pump();

      expect(find.text('France'), findsOneWidget);
      expect(find.text('Afghanistan'), findsNothing);
    });

    desktopTestWidgets('custom searchFilter also runs for an empty query', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CountryPicker(
            onSelected: (_) {},
            searchFilter: (text) => [
              countries.firstWhere((c) => c.countryCode == CountryCode.jp),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'x');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(find.text('Japan'), findsOneWidget);
      expect(find.text('Afghanistan'), findsNothing);
    });

    desktopTestWidgets('invokes onSelected with the tapped country', (
      tester,
    ) async {
      Country? selected;
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (c) => selected = c)),
      );

      await tester.tap(find.text('Afghanistan'));
      await tester.pump();

      expect(selected, isNotNull);
      expect(selected!.countryCode, CountryCode.af);
    });

    desktopTestWidgets('invokes onSelected with a filtered result', (
      tester,
    ) async {
      Country? selected;
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (c) => selected = c)),
      );

      await tester.enterText(find.byType(TextField), 'Canada');
      await tester.pump();
      await tester.tap(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Canada'),
        ),
      );
      await tester.pump();

      expect(selected?.countryCode, CountryCode.ca);
    });

    desktopTestWidgets(
      'orders preferred countries first, preserving the given order',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            CountryPicker(
              onSelected: (_) {},
              preferredCountries: [CountryCode.ca, CountryCode.us],
            ),
          ),
        );

        final canadaY = tester.getTopLeft(find.text('Canada')).dy;
        final usY = tester.getTopLeft(find.text('United States of America')).dy;
        final afghanistanY = tester.getTopLeft(find.text('Afghanistan')).dy;

        expect(canadaY, lessThan(usY));
        expect(usY, lessThan(afghanistanY));
      },
    );

    desktopTestWidgets('ignores an empty preferredCountries list', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (_) {}, preferredCountries: const [])),
      );

      expect(find.text('Afghanistan'), findsOneWidget);
    });

    desktopTestWidgets('applies a custom corner radius to flag images', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (_) {}, flagCornerRadius: 12)),
      );

      final clipRRect = tester
          .widgetList<ClipRRect>(find.byType(ClipRRect))
          .first;
      expect(clipRRect.borderRadius, BorderRadius.circular(12));
    });

    desktopTestWidgets('defaults the flag corner radius to zero', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      final clipRRect = tester
          .widgetList<ClipRRect>(find.byType(ClipRRect))
          .first;
      expect(clipRRect.borderRadius, BorderRadius.circular(0));
    });

    desktopTestWidgets('applies a custom image size to flags', (tester) async {
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (_) {}, imageSize: const Size(60, 30))),
      );

      final image = tester.widgetList<Image>(find.byType(Image)).first;
      expect(image.width, 60);
      expect(image.height, 30);
    });

    desktopTestWidgets('defaults the flag image size to 40x25', (tester) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      final image = tester.widgetList<Image>(find.byType(Image)).first;
      expect(image.width, 40);
      expect(image.height, 25);
    });

    desktopTestWidgets('applies custom text styles for name and call code', (
      tester,
    ) async {
      const nameStyle = TextStyle(fontSize: 22, color: Colors.red);
      const codeStyle = TextStyle(fontSize: 11, color: Colors.blue);

      await tester.pumpWidget(
        wrap(
          CountryPicker(
            onSelected: (_) {},
            countryNameTextStyle: nameStyle,
            countryCallCodeTextStyle: codeStyle,
          ),
        ),
      );

      final nameText = tester.widget<Text>(find.text('Afghanistan'));
      expect(nameText.style, nameStyle);

      final codeText = tester.widget<Text>(find.text('+93'));
      expect(codeText.style, codeStyle);
    });

    desktopTestWidgets('applies custom splash and hover colors to list items', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CountryPicker(
            onSelected: (_) {},
            splashColor: Colors.green,
            hoverColor: Colors.orange,
          ),
        ),
      );

      final itemInkWell = tester
          .widgetList<InkWell>(find.byType(InkWell))
          .first;
      expect(itemInkWell.splashColor, Colors.green);
      expect(itemInkWell.hoverColor, Colors.orange);
    });

    desktopTestWidgets('defaults splash and hover colors to the theme', (
      tester,
    ) async {
      final theme = ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      );

      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (_) {}), theme: theme),
      );

      final itemInkWell = tester
          .widgetList<InkWell>(find.byType(InkWell))
          .first;
      expect(itemInkWell.splashColor, theme.primaryColor);
      expect(
        itemInkWell.hoverColor,
        theme.colorScheme.secondary.withValues(alpha: 0.1),
      );
    });

    desktopTestWidgets('applies a custom item border radius', (tester) async {
      await tester.pumpWidget(
        wrap(CountryPicker(onSelected: (_) {}, itemBorderRadius: 20)),
      );

      final itemInkWell = tester
          .widgetList<InkWell>(find.byType(InkWell))
          .first;
      expect(itemInkWell.borderRadius, BorderRadius.circular(20));
    });

    desktopTestWidgets('defaults the item border radius to 10', (tester) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      final itemInkWell = tester
          .widgetList<InkWell>(find.byType(InkWell))
          .first;
      expect(itemInkWell.borderRadius, BorderRadius.circular(10));
    });

    desktopTestWidgets(
      'removes the bottom padding when noBottomPadding is true',
      (tester) async {
        await tester.pumpWidget(
          wrap(CountryPicker(onSelected: (_) {}, noBottomPadding: true)),
        );

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(CountryPicker),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(container.padding, const EdgeInsets.fromLTRB(10, 20, 10, 0));
      },
    );

    desktopTestWidgets('keeps the bottom padding by default', (tester) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(CountryPicker),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.padding, const EdgeInsets.fromLTRB(10, 20, 10, 20));
    });

    desktopTestWidgets('disposes its search controller without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(CountryPicker(onSelected: (_) {})));
      await tester.pumpWidget(const SizedBox());

      expect(tester.takeException(), isNull);
    });
  });
}
