// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_mx_suppression.dart';

class MxResult {
  /// Creates a result.
  const MxResult({
    this.clientId,
    this.environment,
    this.surface,
    this.userGuid,
    this.memberGuid,
    this.institutionCode,
    this.institutionName,
    this.connectionStatus,
    this.aggregationType,
    this.aggregationStatus,
    this.accountGuid,
    this.accountKind,
    this.accountType,
    this.transactionsCount,
    this.daysReturned,
    this.holdingsCount,
    this.statementsCount,
    this.mfaRequired,
    this.connectFlow,
    this.taxonomyCategoryCount,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? clientId;
  final String? environment;
  final String? surface;
  final String? userGuid;
  final String? memberGuid;
  final String? institutionCode;
  final String? institutionName;
  final String? connectionStatus;
  final String? aggregationType;
  final String? aggregationStatus;
  final String? accountGuid;
  final String? accountKind;
  final String? accountType;
  final int? transactionsCount;
  final int? daysReturned;
  final int? holdingsCount;
  final int? statementsCount;
  final bool? mfaRequired;
  final String? connectFlow;
  final int? taxonomyCategoryCount;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class MxCallResult<T> {
  /// Creates a call result.
  const MxCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final MxResult? result;
}

Future<T> tracedMx<T>({
  required String operation,
  required Future<MxCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (mxInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_mx');
  final span = t.startSpan('mx $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'mx')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.clientId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.client.id', res.clientId!)]));
      }
      if (res.environment != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.environment', res.environment!)]));
      }
      if (res.surface != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.surface', res.surface!)]));
      }
      if (res.userGuid != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.user.guid', res.userGuid!)]));
      }
      if (res.memberGuid != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.member.guid', res.memberGuid!)]));
      }
      if (res.institutionCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('mx.institution.code', res.institutionCode!)
        ]));
      }
      if (res.institutionName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('mx.institution.name', res.institutionName!)
        ]));
      }
      if (res.connectionStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('mx.connection.status', res.connectionStatus!)
        ]));
      }
      if (res.aggregationType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('mx.aggregation.type', res.aggregationType!)
        ]));
      }
      if (res.aggregationStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'mx.aggregation.status', res.aggregationStatus!)
        ]));
      }
      if (res.accountGuid != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.account.guid', res.accountGuid!)]));
      }
      if (res.accountKind != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.account.kind', res.accountKind!)]));
      }
      if (res.accountType != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.account.type', res.accountType!)]));
      }
      if (res.transactionsCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('mx.transactions.count', res.transactionsCount!)
        ]));
      }
      if (res.daysReturned != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('mx.days_returned', res.daysReturned!)]));
      }
      if (res.holdingsCount != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('mx.holdings.count', res.holdingsCount!)]));
      }
      if (res.statementsCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('mx.statements.count', res.statementsCount!)
        ]));
      }
      if (res.mfaRequired != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeBool('mx.mfa.required', res.mfaRequired!)]));
      }
      if (res.connectFlow != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.connect.flow', res.connectFlow!)]));
      }
      if (res.taxonomyCategoryCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'mx.taxonomy.category_count', res.taxonomyCategoryCount!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('mx.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.connectionStatus == 'IMPEDED' ||
          res.connectionStatus == 'FAILED' ||
          res.aggregationStatus == 'failed';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'mx.error')
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
