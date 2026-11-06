// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_toast/otel_toast.dart';

/// Traces Toast calls with OpenTelemetry.
///
/// `otel_toast` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Toast call in
/// [tracedToast]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'toast-example');

  // Traces a Toast call.
  final toastId = await tracedToast<String>(
    operation: 'create',
    invoke: () async {
      // Make the Toast call here, then report what it returned.
      const id = 'toast_8f3a2c';
      return const ToastCallResult(
          value: id,
          result: ToastResult(
              restaurantGuid: 'restaurantgu_8f3a2c',
              locationName: 'example',
              orderGuid: 'ordergu_8f3a2c',
              orderNumber: 'example',
              checkGuid: 'checkgu_8f3a2c',
              employeeGuid: 'employeegu_8f3a2c',
              serviceArea: 'example',
              menuItemGuid: 'menuitemgu_8f3a2c',
              diningOptionType: 'standard',
              amount: 0.5,
              currency: 'usd',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedToast create returned $toastId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutToastInstrumentationAsync.
  await runWithoutToastInstrumentationAsync(
    () => tracedToast<String>(
      operation: 'create',
      invoke: () async {
        const id = 'toast_8f3a2c';
        return const ToastCallResult(
            value: id,
            result: ToastResult(
                restaurantGuid: 'restaurantgu_8f3a2c',
                locationName: 'example',
                orderGuid: 'ordergu_8f3a2c',
                orderNumber: 'example',
                checkGuid: 'checkgu_8f3a2c',
                employeeGuid: 'employeegu_8f3a2c',
                serviceArea: 'example',
                menuItemGuid: 'menuitemgu_8f3a2c',
                diningOptionType: 'standard',
                amount: 0.5,
                currency: 'usd',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
