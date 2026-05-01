import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  final String baseUrl = "https://your-api.com/upload";

  Future<String> upload(File file) async {
    final request = http.MultipartRequest('POST', Uri.parse(baseUrl));

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // backend field name
        file.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      final data = jsonDecode(resBody);

      return data['url']; // backend should return image URL
    } else {
      throw Exception('Upload failed: ${response.statusCode}');
    }
  }
}
