// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_azure_ai_search/otel_azure_ai_search.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_azure_ai_search-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('search records query type + counts', () async {
    await tracedAzureAiSearch<String>(
      operation: 'documents.search',
      invoke: () async => const AzureAiSearchCallResult(
        value: 'ok',
        result: AzureAiSearchResult(
          indexName: 'products',
          queryType: 'semantic',
          searchMode: 'any',
          documentsReturned: 10,
          totalCount: 542,
          searchScore: 12.5,
          semanticConfiguration: 'default',
          semanticAnswers: 1,
        ),
      ),
    );
    final a =
        attrsOf(spans.findSpanByName('azure_ai_search documents.search')!);
    expect(a['azure.ai_search.query.type'], 'semantic');
    expect(a['azure.ai_search.total_count'], 542);
    expect(a['azure.ai_search.semantic.configuration'], 'default');
  });

  test('indexer persistentFailure sets span error', () async {
    await tracedAzureAiSearch<String>(
      operation: 'indexers.getStatus',
      invoke: () async => const AzureAiSearchCallResult(
        value: 'ok',
        result: AzureAiSearchResult(
          indexerName: 'sql-indexer',
          indexerStatus: 'persistentFailure',
        ),
      ),
    );
    expect(
      spans.findSpanByName('azure_ai_search indexers.getStatus')!.status,
      SpanStatusCode.Error,
    );
  });

  test('vector search records top_k', () async {
    await tracedAzureAiSearch<String>(
      operation: 'documents.search',
      invoke: () async => const AzureAiSearchCallResult(
        value: 'ok',
        result: AzureAiSearchResult(
          queryType: 'vector',
          vectorTopK: 50,
          vectorQueriesCount: 2,
        ),
      ),
    );
    final a =
        attrsOf(spans.findSpanByName('azure_ai_search documents.search')!);
    expect(a['azure.ai_search.vector.top_k'], 50);
    expect(a['azure.ai_search.vector.queries_count'], 2);
  });

  test('suppression skips spans', () async {
    await runWithoutAzureAiSearchInstrumentationAsync(() async {
      await tracedAzureAiSearch<String>(
        operation: 'services.list',
        invoke: () async => const AzureAiSearchCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('azure_ai_search '), isEmpty);
  });
}
