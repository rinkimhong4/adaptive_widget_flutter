import 'package:example/api/config/api_service.dart';
import 'package:example/models/student.dart';
import 'package:example/providers/base_crud_provider.dart';
import 'package:example/repositories/base_repository.dart';

class StudentRepository extends BaseRepository<Student> {
  StudentRepository(ApiService api)
    : super(
        api: api,
        endpoint: '/students',
        fromJson: Student.fromJson,
        toJson: (o) => o.toJson(),
        listDataKey: null, // We handle the nested structure ourselves
      );

  @override
  Future<List<Student>> getAll({Map<String, String>? queryParams}) async {
    // Fetch the raw JSON object (without trying to extract a list)
    final response = await api.callApi<Map<String, dynamic>>(
      endpoint: endpoint,
      queryParams: queryParams,
      fromJson: (json) => json,
    );

    // Extract the nested list: response["data"]["data"]
    final outerData = response['data'];
    if (outerData == null || outerData is! Map<String, dynamic>) {
      throw Exception('Expected outer data to be a map, got: $outerData');
    }

    final innerData = outerData['data'];
    if (innerData == null || innerData is! List<dynamic>) {
      throw Exception('Expected inner data to be a list, got: $innerData');
    }

    return (innerData as List<dynamic>)
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class StudentProvider extends BaseCrudProvider<Student> {
  StudentProvider(ApiService api)
    : super(repository: StudentRepository(api), idSelector: (o) => o.studentid);
}
