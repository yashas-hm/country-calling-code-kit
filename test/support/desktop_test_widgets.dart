import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs [callback] as a widget test pinned to a desktop platform.
///
/// The `flutter test` harness defaults [defaultTargetPlatform] to
/// [TargetPlatform.android]. On mobile the picker runs the SIM/locale
/// default-country reorder path (which awaits and rewrites the list order)
/// and disables hover colors. Pinning a desktop platform via a
/// [TargetPlatformVariant] keeps those code paths off so the widget tests
/// stay deterministic.
///
/// The variant is used instead of `setUp`/`tearDown` because it resets
/// [debugDefaultTargetPlatformOverride] inside the test body, before the
/// framework's end-of-test invariant check runs.
void desktopTestWidgets(String description, WidgetTesterCallback callback) {
  testWidgets(
    description,
    callback,
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );
}
