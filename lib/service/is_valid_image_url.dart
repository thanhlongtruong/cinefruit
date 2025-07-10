import 'package:http/http.dart' as http;

Future<bool> isValidImageUrl(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200 &&
        response.headers['content-type']?.startsWith('image/') == true;
  } catch (e) {
    return false;
  }
}
