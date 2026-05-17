// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_toast/otel_toast.dart';
import 'package:test/test.dart';

void main() {
  group('otel_toast', () {
    test('suppression toggles in zone', () async {
      expect(toastInstrumentationSuppressed(), isFalse);
      await runWithoutToastInstrumentationAsync(() async {
        expect(toastInstrumentationSuppressed(), isTrue);
      });
      expect(toastInstrumentationSuppressed(), isFalse);
    });

    test('ToastResult fields default null', () {
      const r = ToastResult();
      expect(r.statusCode, isNull);
    });
  });
}
