// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_azure_ai_search_suppression.dart';

class AzureAiSearchResult {
  const AzureAiSearchResult({
    this.serviceName,
    this.region,
    this.skuName,
    this.indexName,
    this.indexerName,
    this.indexerStatus,
    this.queryType,
    this.searchMode,
    this.scoringProfile,
    this.documentsReturned,
    this.totalCount,
    this.searchScore,
    this.semanticConfiguration,
    this.semanticAnswers,
    this.vectorTopK,
    this.vectorQueriesCount,
    this.facetCount,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? serviceName;
  final String? region;
  final String? skuName;
  final String? indexName;
  final String? indexerName;
  final String? indexerStatus;
  final String? queryType;
  final String? searchMode;
  final String? scoringProfile;
  final int? documentsReturned;
  final int? totalCount;
  final double? searchScore;
  final String? semanticConfiguration;
  final int? semanticAnswers;
  final int? vectorTopK;
  final int? vectorQueriesCount;
  final int? facetCount;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class AzureAiSearchCallResult<T> {
  const AzureAiSearchCallResult({required this.value, this.result});
  final T value;
  final AzureAiSearchResult? result;
}

Future<T> tracedAzureAiSearch<T>({
  required String operation,
  required Future<AzureAiSearchCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (azureAiSearchInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_azure_ai_search');
  final span = t.startSpan('azure_ai_search $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'azure');
    span.setStringAttribute('rpc.service', 'AISearch');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.serviceName != null) {
        span.setStringAttribute(
            'azure.ai_search.service.name', res.serviceName!);
      }
      if (res.region != null) {
        span.setStringAttribute('azure.region', res.region!);
      }
      if (res.skuName != null) {
        span.setStringAttribute('azure.ai_search.sku.name', res.skuName!);
      }
      if (res.indexName != null) {
        span.setStringAttribute('azure.ai_search.index.name', res.indexName!);
      }
      if (res.indexerName != null) {
        span.setStringAttribute(
            'azure.ai_search.indexer.name', res.indexerName!);
      }
      if (res.indexerStatus != null) {
        span.setStringAttribute(
            'azure.ai_search.indexer.status', res.indexerStatus!);
      }
      if (res.queryType != null) {
        span.setStringAttribute('azure.ai_search.query.type', res.queryType!);
      }
      if (res.searchMode != null) {
        span.setStringAttribute('azure.ai_search.search_mode', res.searchMode!);
      }
      if (res.scoringProfile != null) {
        span.setStringAttribute(
            'azure.ai_search.scoring_profile', res.scoringProfile!);
      }
      if (res.documentsReturned != null) {
        span.setIntAttribute(
            'azure.ai_search.documents_returned', res.documentsReturned!);
      }
      if (res.totalCount != null) {
        span.setIntAttribute('azure.ai_search.total_count', res.totalCount!);
      }
      if (res.searchScore != null) {
        span.setDoubleAttribute('azure.ai_search.top_score', res.searchScore!);
      }
      if (res.semanticConfiguration != null) {
        span.setStringAttribute('azure.ai_search.semantic.configuration',
            res.semanticConfiguration!);
      }
      if (res.semanticAnswers != null) {
        span.setIntAttribute(
            'azure.ai_search.semantic.answers', res.semanticAnswers!);
      }
      if (res.vectorTopK != null) {
        span.setIntAttribute('azure.ai_search.vector.top_k', res.vectorTopK!);
      }
      if (res.vectorQueriesCount != null) {
        span.setIntAttribute(
            'azure.ai_search.vector.queries_count', res.vectorQueriesCount!);
      }
      if (res.facetCount != null) {
        span.setIntAttribute('azure.ai_search.facet_count', res.facetCount!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('azure.ai_search.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.indexerStatus == 'transientFailure' ||
          res.indexerStatus == 'persistentFailure' ||
          res.indexerStatus == 'error';
      if (fail) {
        span.setStringAttribute(ErrorResource.errorType.key,
            res.errorCode ?? 'azure_ai_search.error');
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
