import 'dart:convert';

List<String> bannerItemFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String bannerItemToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
