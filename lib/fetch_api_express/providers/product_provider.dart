import 'package:adaptive_widgeet/fetch_api_express/api/config/api_service.dart';
import 'package:adaptive_widgeet/fetch_api_express/models/product.dart';
import 'package:adaptive_widgeet/fetch_api_express/providers/base_crud_provider.dart';
import 'package:adaptive_widgeet/fetch_api_express/repositories/base_repository.dart';

/// DummyJSON product repository.
///
/// Endpoints:
///   GET    /products            (list, wrapped in { "products": [...] })
///   GET    /products/{id}       (single)
///   POST   /products/add        (create — non-standard, hence createSuffix)
///   PUT    /products/{id}       (update)
///   DELETE /products/{id}       (delete)
class ProductRepository extends BaseRepository<ProductModel> {
  ProductRepository(ApiService api)
    : super(
        api: api,
        endpoint: '/products',
        fromJson: ProductModel.fromJson,
        toJson: (p) => p.toJson(),
        listDataKey: 'products',
        createSuffix: '',
      );
}

class ProductProvider extends BaseCrudProvider<ProductModel> {
  ProductProvider(ApiService api)
    : super(repository: ProductRepository(api), idSelector: (p) => p.productId);
}
