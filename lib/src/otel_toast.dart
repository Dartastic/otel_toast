// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_toast_suppression.dart';

class ToastResult {
  /// Creates a result.
  const ToastResult({
    this.restaurantGuid,
    this.locationName,
    this.orderGuid,
    this.orderNumber,
    this.checkGuid,
    this.employeeGuid,
    this.serviceArea,
    this.menuItemGuid,
    this.diningOptionType,
    this.amount,
    this.currency,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? restaurantGuid;
  final String? locationName;
  final String? orderGuid;
  final String? orderNumber;
  final String? checkGuid;
  final String? employeeGuid;
  final String? serviceArea;
  final String? menuItemGuid;
  final String? diningOptionType;
  final double? amount;
  final String? currency;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class ToastCallResult<T> {
  /// Creates a call result.
  const ToastCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final ToastResult? result;
}

Future<T> tracedToast<T>({
  required String operation,
  required Future<ToastCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (toastInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_toast');
  final span = t.startSpan('toast $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'toast')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.restaurantGuid != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('toast.restaurant.guid', res.restaurantGuid!)
        ]));
      }
      if (res.locationName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('toast.location.name', res.locationName!)
        ]));
      }
      if (res.orderGuid != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('toast.order.guid', res.orderGuid!)]));
      }
      if (res.orderNumber != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('toast.order.number', res.orderNumber!)]));
      }
      if (res.checkGuid != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('toast.check.guid', res.checkGuid!)]));
      }
      if (res.employeeGuid != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('toast.employee.guid', res.employeeGuid!)
        ]));
      }
      if (res.serviceArea != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('toast.service_area', res.serviceArea!)]));
      }
      if (res.menuItemGuid != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('toast.menu_item.guid', res.menuItemGuid!)
        ]));
      }
      if (res.diningOptionType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('toast.dining_option', res.diningOptionType!)
        ]));
      }
      if (res.amount != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeDouble('toast.amount', res.amount!)]));
      }
      if (res.currency != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('toast.currency', res.currency!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('toast.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'toast.error')
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
