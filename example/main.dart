// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_mx/otel_mx.dart';

/// Traces Mx calls with OpenTelemetry.
///
/// `otel_mx` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Mx call in
/// [tracedMx]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'mx-example');

  // Traces a Mx call.
  final mxId = await tracedMx<String>(
    operation: 'create',
    invoke: () async {
      // Make the Mx call here, then report what it returned.
      const id = 'mx_8f3a2c';
      return const MxCallResult(
          value: id,
          result: MxResult(
              clientId: 'client_8f3a2c',
              environment: 'example',
              surface: 'example',
              userGuid: 'usergu_8f3a2c',
              memberGuid: 'membergu_8f3a2c',
              institutionCode: 'example',
              institutionName: 'example',
              connectionStatus: 'succeeded',
              aggregationType: 'standard',
              aggregationStatus: 'succeeded',
              accountGuid: 'accountgu_8f3a2c',
              accountKind: 'example',
              accountType: 'standard',
              transactionsCount: 3,
              daysReturned: 1,
              holdingsCount: 3,
              statementsCount: 3,
              mfaRequired: true,
              connectFlow: 'example',
              taxonomyCategoryCount: 3,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedMx create returned $mxId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutMxInstrumentationAsync.
  await runWithoutMxInstrumentationAsync(
    () => tracedMx<String>(
      operation: 'create',
      invoke: () async {
        const id = 'mx_8f3a2c';
        return const MxCallResult(
            value: id,
            result: MxResult(
                clientId: 'client_8f3a2c',
                environment: 'example',
                surface: 'example',
                userGuid: 'usergu_8f3a2c',
                memberGuid: 'membergu_8f3a2c',
                institutionCode: 'example',
                institutionName: 'example',
                connectionStatus: 'succeeded',
                aggregationType: 'standard',
                aggregationStatus: 'succeeded',
                accountGuid: 'accountgu_8f3a2c',
                accountKind: 'example',
                accountType: 'standard',
                transactionsCount: 3,
                daysReturned: 1,
                holdingsCount: 3,
                statementsCount: 3,
                mfaRequired: true,
                connectFlow: 'example',
                taxonomyCategoryCount: 3,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
