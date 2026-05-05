import 'package:adaptive_widgeet/fetch_api_express/api/config/api_service.dart';

/// Generic CRUD repository.
/// Extend this class for each resource (Product, Category, etc.).
abstract class BaseRepository<T> {
  final ApiService api;
  final String endpoint; // e.g. '/products'
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  /// If your API wraps lists like `{ "data": [...] }`, set this to `'data'`.
  /// Leave null if the API returns a raw array.
  final String? listDataKey;

  /// Suffix appended to [endpoint] for create requests.
  /// E.g. DummyJSON expects `POST /products/add`, so pass `'/add'`.
  /// Defaults to `''` (standard REST: `POST /products`).
  final String createSuffix;

  BaseRepository({
    required this.api,
    required this.endpoint,
    required this.fromJson,
    required this.toJson,
    this.listDataKey,
    this.createSuffix = '',
  });

  Future<List<T>> getAll({Map<String, String>? queryParams}) {
    return api.callApiList<T>(
      endpoint: endpoint,
      queryParams: queryParams,
      fromJson: fromJson,
      dataKey: listDataKey,
    );
  }

  Future<T> getById(dynamic id) {
    return api.callApi<T>(endpoint: '$endpoint/$id', fromJson: fromJson);
  }

  Future<T> create(T item) {
    return api.callApi<T>(
      endpoint: '$endpoint$createSuffix',
      method: 'POST',
      body: toJson(item),
      fromJson: fromJson,
    );
  }

  Future<T> update(dynamic id, T item) {
    return api.callApi<T>(
      endpoint: '$endpoint/$id',
      method: 'PUT',
      body: toJson(item),
      fromJson: fromJson,
    );
  }

  Future<bool> delete(dynamic id) async {
    await api.callApi<Map<String, dynamic>>(
      endpoint: '$endpoint/$id',
      method: 'DELETE',
      fromJson: (json) => json,
    );
    return true;
  }
}
