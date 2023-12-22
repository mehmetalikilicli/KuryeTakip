class CarModel {
  int type;
  String brand;
  String brandModel;
  String year;
  String kilometer;
  String transmission;
  String fuelType;
  List<String> photos;
  double dailyPrice;

  CarModel({
    required this.type,
    required this.brand,
    required this.brandModel,
    required this.year,
    required this.kilometer,
    required this.transmission,
    required this.fuelType,
    required this.photos,
    required this.dailyPrice,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      type: json['Type'] ?? 0,
      brand: json['Brand'] ?? '',
      brandModel: json['BrandModel'] ?? '',
      year: json['Year'] ?? '',
      kilometer: json['Kilometer'] ?? '',
      transmission: json['Tranmission'] ?? '',
      fuelType: json['FuelType'] ?? '',
      photos: (json['Photos'] as List<dynamic>?)?.map((photo) => photo.toString()).toList() ?? [],
      dailyPrice: (json['DailyPrice'] ?? 0.0).toDouble(),
    );
  }
}
