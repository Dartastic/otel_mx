// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_mx/otel_mx.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_mx-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('transactions.list records institution + counts', () async {
    await tracedMx<String>(
      operation: 'transactions.list',
      invoke: () async => const MxCallResult(
        value: 'ok',
        result: MxResult(
          institutionCode: 'chase',
          institutionName: 'Chase',
          accountType: 'CHECKING',
          transactionsCount: 87,
          daysReturned: 90,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('mx transactions.list')!);
    expect(a['mx.institution.code'], 'chase');
    expect(a['mx.transactions.count'], 87);
  });

  test('IMPEDED connection sets span error', () async {
    await tracedMx<String>(
      operation: 'members.aggregate',
      invoke: () async => const MxCallResult(
        value: 'ok',
        result: MxResult(
          connectionStatus: 'IMPEDED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('mx members.aggregate')!.status,
      SpanStatusCode.Error,
    );
  });

  test('connect widget records flow', () async {
    await tracedMx<String>(
      operation: 'connect_widget.get_url',
      invoke: () async => const MxCallResult(
        value: 'ok',
        result: MxResult(
          connectFlow: 'aggregation',
          mfaRequired: false,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('mx connect_widget.get_url')!);
    expect(a['mx.connect.flow'], 'aggregation');
    expect(a['mx.mfa.required'], false);
  });

  test('suppression skips spans', () async {
    await runWithoutMxInstrumentationAsync(() async {
      await tracedMx<String>(
        operation: 'users.list',
        invoke: () async => const MxCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('mx '), isEmpty);
  });
}
