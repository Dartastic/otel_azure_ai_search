// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_azure_ai_search_suppression.dart';

class AzureAiSearchResult {
  /// Creates a result.
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

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class AzureAiSearchCallResult<T> {
  /// Creates a call result.
  const AzureAiSearchCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final AzureAiSearchResult? result;
}

Future<T> tracedAzureAiSearch<T>({
  required String operation,
  required Future<AzureAiSearchCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (azureAiSearchInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t =
      tracer ?? OTelAPI.tracerProvider().getTracer('otel_azure_ai_search');
  final span = t.startSpan('azure_ai_search $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'azure')]));
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.service', 'AISearch')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.serviceName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'azure.ai_search.service.name', res.serviceName!)
        ]));
      }
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('azure.region', res.region!)]));
      }
      if (res.skuName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.ai_search.sku.name', res.skuName!)
        ]));
      }
      if (res.indexName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.ai_search.index.name', res.indexName!)
        ]));
      }
      if (res.indexerName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'azure.ai_search.indexer.name', res.indexerName!)
        ]));
      }
      if (res.indexerStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'azure.ai_search.indexer.status', res.indexerStatus!)
        ]));
      }
      if (res.queryType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.ai_search.query.type', res.queryType!)
        ]));
      }
      if (res.searchMode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'azure.ai_search.search_mode', res.searchMode!)
        ]));
      }
      if (res.scoringProfile != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'azure.ai_search.scoring_profile', res.scoringProfile!)
        ]));
      }
      if (res.documentsReturned != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'azure.ai_search.documents_returned', res.documentsReturned!)
        ]));
      }
      if (res.totalCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('azure.ai_search.total_count', res.totalCount!)
        ]));
      }
      if (res.searchScore != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble('azure.ai_search.top_score', res.searchScore!)
        ]));
      }
      if (res.semanticConfiguration != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.ai_search.semantic.configuration',
              res.semanticConfiguration!)
        ]));
      }
      if (res.semanticAnswers != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'azure.ai_search.semantic.answers', res.semanticAnswers!)
        ]));
      }
      if (res.vectorTopK != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('azure.ai_search.vector.top_k', res.vectorTopK!)
        ]));
      }
      if (res.vectorQueriesCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'azure.ai_search.vector.queries_count', res.vectorQueriesCount!)
        ]));
      }
      if (res.facetCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('azure.ai_search.facet_count', res.facetCount!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('azure.ai_search.error.code', res.errorCode!)
        ]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.indexerStatus == 'transientFailure' ||
          res.indexerStatus == 'persistentFailure' ||
          res.indexerStatus == 'error';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(ErrorAttributes.errorType.key,
              res.errorCode ?? 'azure_ai_search.error')
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
