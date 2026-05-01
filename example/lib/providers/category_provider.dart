import 'package:example/api/config/api_service.dart';
import 'package:example/models/category.dart';
import 'package:example/providers/base_crud_provider.dart';
import 'package:example/repositories/base_repository.dart';

class CategoryRepository extends BaseRepository<Category> {
  CategoryRepository(ApiService api)
    : super(
        api: api,
        endpoint: '/categories',
        fromJson: Category.fromJson,
        toJson: (c) => c.toJson(),
        listDataKey: 'data',
      );
}

class CategoryProvider extends BaseCrudProvider<Category> {
  CategoryProvider(ApiService api)
    : super(repository: CategoryRepository(api), idSelector: (c) => c.id);
}
