import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Downloads an image from [url] and saves it to the app's documents directory.
/// Returns the local file path if successful, otherwise null.
Future<String?> downloadAndSaveImage(String url, String fileName) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    }
  } catch (e) {
    // Handle error
  }
  return null;
}
