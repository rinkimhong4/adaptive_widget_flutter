import 'package:example/api/config/api_service.dart';
import 'package:example/models/product.dart';
import 'package:example/providers/base_crud_provider.dart';
import 'package:example/repositories/base_repository.dart';

/// DummyJSON product repository.
///
/// Endpoints:
///   GET    /products            (list, wrapped in { "products": [...] })
///   GET    /products/{id}       (single)
///   POST   /products/add        (create — non-standard, hence createSuffix)
///   PUT    /products/{id}       (update)
///   DELETE /products/{id}       (delete)
class ProductRepository extends BaseRepository<Product> {
  ProductRepository(ApiService api)
    : super(
        api: api,
        endpoint: '/products',
        fromJson: Product.fromJson,
        toJson: (p) => p.toJson(),
        listDataKey: 'products', // 👈 DummyJSON wraps lists under "products"
        createSuffix: '/add', // 👈 DummyJSON uses POST /products/add
      );
}

class ProductProvider extends BaseCrudProvider<Product> {
  ProductProvider(ApiService api)
    : super(repository: ProductRepository(api), idSelector: (p) => p.id);
}
