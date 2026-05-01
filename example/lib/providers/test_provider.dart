import 'package:example/api/config/api_service.dart';
import 'package:example/models/test.dart';
import 'package:example/providers/base_crud_provider.dart';
import 'package:example/repositories/base_repository.dart';

class TestRepository extends BaseRepository<ProductD> {
  TestRepository(ApiService api)
    : super(
        api: api,
        endpoint: '/products',
        fromJson: ProductD.fromJson,
        toJson: (o) => o.toJson(),
        listDataKey: 'data', // change/remove based on your API
      );
}

class TestProvider extends BaseCrudProvider<ProductD> {
  TestProvider(ApiService api)
    : super(repository: TestRepository(api), idSelector: (o) => o.id);
}
