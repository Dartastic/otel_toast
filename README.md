# otel_toast

Dartastic OpenTelemetry bridge for Toast (restaurant POS + management).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_toast/otel_toast.dart';

await tracedToast<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return ToastCallResult(value: r, result: ToastResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutToastInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
