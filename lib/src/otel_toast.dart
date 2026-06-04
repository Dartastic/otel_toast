// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_toast_suppression.dart';

class ToastResult {
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

class ToastCallResult<T> {
  const ToastCallResult({required this.value, this.result});
  final T value;
  final ToastResult? result;
}

Future<T> tracedToast<T>({
  required String operation,
  required Future<ToastCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (toastInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_toast');
  final span = t.startSpan('toast $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'toast')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.restaurantGuid != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('toast.restaurant.guid', res.restaurantGuid!)
        ]));
      }
      if (res.locationName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.location.name', res.locationName!)]));
      }
      if (res.orderGuid != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.order.guid', res.orderGuid!)]));
      }
      if (res.orderNumber != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.order.number', res.orderNumber!)]));
      }
      if (res.checkGuid != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.check.guid', res.checkGuid!)]));
      }
      if (res.employeeGuid != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.employee.guid', res.employeeGuid!)]));
      }
      if (res.serviceArea != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.service_area', res.serviceArea!)]));
      }
      if (res.menuItemGuid != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.menu_item.guid', res.menuItemGuid!)]));
      }
      if (res.diningOptionType != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('toast.dining_option', res.diningOptionType!)
        ]));
      }
      if (res.amount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeDouble('toast.amount', res.amount!)]));
      }
      if (res.currency != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.currency', res.currency!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('toast.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'toast.error')
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
