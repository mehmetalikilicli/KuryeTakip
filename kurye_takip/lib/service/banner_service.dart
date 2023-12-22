import 'dart:convert';
import 'package:http/http.dart' as http;

class BannerService {
  static Future<List<String>> fetchBannerUrls() async {
    try {
      final response = await http.get(Uri.parse('https://bilisteapi.takipsa.com/Banner/GetPhotos'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>().toList();
      } else {
        throw Exception('Failed to load banner URLs');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
