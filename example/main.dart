// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_azure_ai_search/otel_azure_ai_search.dart';

/// Traces Azure Ai Search calls with OpenTelemetry.
///
/// `otel_azure_ai_search` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Azure Ai Search call in
/// [tracedAzureAiSearch]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'azure-ai-search-example');

  // Traces a Azure Ai Search call.
  final azureAiSearchId = await tracedAzureAiSearch<String>(
    operation: 'create',
    invoke: () async {
      // Make the Azure Ai Search call here, then report what it returned.
      const id = 'azure_ai_search_8f3a2c';
      return const AzureAiSearchCallResult(
          value: id,
          result: AzureAiSearchResult(
              serviceName: 'example',
              region: 'us-east-1',
              skuName: 'example',
              indexName: 'products',
              indexerName: 'products',
              indexerStatus: 'succeeded',
              queryType: 'standard',
              searchMode: 'example',
              scoringProfile: 'example',
              documentsReturned: 1,
              totalCount: 3,
              searchScore: 0.5,
              semanticConfiguration: 'example',
              semanticAnswers: 1,
              vectorTopK: 1,
              vectorQueriesCount: 3,
              facetCount: 3,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedAzureAiSearch create returned $azureAiSearchId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAzureAiSearchInstrumentationAsync.
  await runWithoutAzureAiSearchInstrumentationAsync(
    () => tracedAzureAiSearch<String>(
      operation: 'create',
      invoke: () async {
        const id = 'azure_ai_search_8f3a2c';
        return const AzureAiSearchCallResult(
            value: id,
            result: AzureAiSearchResult(
                serviceName: 'example',
                region: 'us-east-1',
                skuName: 'example',
                indexName: 'products',
                indexerName: 'products',
                indexerStatus: 'succeeded',
                queryType: 'standard',
                searchMode: 'example',
                scoringProfile: 'example',
                documentsReturned: 1,
                totalCount: 3,
                searchScore: 0.5,
                semanticConfiguration: 'example',
                semanticAnswers: 1,
                vectorTopK: 1,
                vectorQueriesCount: 3,
                facetCount: 3,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
