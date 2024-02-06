// To parse this JSON data, do
//
//     final getCars = getCarsFromJson(jsonString);

// ignore_for_file: unnecessary_question_mark, constant_identifier_names
/*
import 'dart:convert';

GetCars getCarsFromJson(String str) => GetCars.fromJson(json.decode(str));

String getCarsToJson(GetCars data) => json.encode(data.toJson());

class GetCars {
  bool success;
  String message;
  List<Car>? cars;

  GetCars({
    required this.success,
    required this.message,
    this.cars,
  });

  factory GetCars.fromJson(Map<String, dynamic> json) => GetCars(
        success: json["success"],
        message: json["message"],
        cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "cars": List<dynamic>.from(cars!.map((x) => x.toJson())),
      };
}

class Car {
  int? id;
  UserName? userName;
  UserSurname? userSurname;
  UserEmail? userEmail;
  UserPhone? userPhone;
  int? userId;
  int? brandId;
  int? modelId;
  FuelType? fuelType;
  TransmissionType? transmissionType;
  double? dailyPrice;
  String? plate;
  Km? km;
  Note? note;
  int? weeklyRent;
  int? monthlyRent;
  int? minRentDay;
  int? isActive;
  int? isApproved;
  dynamic? isLongTerm;
  dynamic? isAvailableDateStart;
  dynamic? isAvailableDateEnd;

  Car({
    this.id,
    this.userName,
    this.userSurname,
    this.userEmail,
    this.userPhone,
    this.userId,
    this.brandId,
    this.modelId,
    this.fuelType,
    this.transmissionType,
    this.dailyPrice,
    this.plate,
    this.km,
    this.note,
    this.weeklyRent,
    this.monthlyRent,
    this.minRentDay,
    this.isActive,
    this.isApproved,
    this.isLongTerm,
    this.isAvailableDateStart,
    this.isAvailableDateEnd,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["ID"],
        userName: userNameValues.map[json["user_name"]],
        userSurname: userSurnameValues.map[json["user_surname"]],
        userEmail: userEmailValues.map[json["user_email"]],
        userPhone: userPhoneValues.map[json["user_phone"]],
        userId: json["user_id"],
        brandId: json["brand_id"],
        modelId: json["model_id"],
        fuelType: fuelTypeValues.map[json["fuel_type"]],
        transmissionType: transmissionTypeValues.map[json["transmission_type"]],
        dailyPrice: json["daily_price"],
        plate: json["plate"],
        km: kmValues.map[json["km"]],
        note: noteValues.map[json["note"]],
        weeklyRent: json["weekly_rent"],
        monthlyRent: json["monthly_rent"],
        minRentDay: json["min_rent_day"],
        isActive: json["is_active"],
        isApproved: json["is_approved"],
        isLongTerm: json["is_long_term"],
        isAvailableDateStart: json["is_available_date_start"],
        isAvailableDateEnd: json["is_available_date_end"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "user_name": userNameValues.reverse[userName],
        "user_surname": userSurnameValues.reverse[userSurname],
        "user_email": userEmailValues.reverse[userEmail],
        "user_phone": userPhoneValues.reverse[userPhone],
        "user_id": userId,
        "brand_id": brandId,
        "model_id": modelId,
        "fuel_type": fuelTypeValues.reverse[fuelType],
        "transmission_type": transmissionTypeValues.reverse[transmissionType],
        "daily_price": dailyPrice,
        "plate": plate,
        "km": kmValues.reverse[km],
        "note": noteValues.reverse[note],
        "weekly_rent": weeklyRent,
        "monthly_rent": monthlyRent,
        "min_rent_day": minRentDay,
        "is_active": isActive,
        "is_approved": isApproved,
        "is_long_term": isLongTerm,
        "is_available_date_start": isAvailableDateStart,
        "is_available_date_end": isAvailableDateEnd,
      };
}

enum FuelType { DIZEL, SAMPLE_STRING_5 }

final fuelTypeValues = EnumValues({"Dizel": FuelType.DIZEL, "sample string 5": FuelType.SAMPLE_STRING_5});

enum Km { SAMPLE_STRING_8, THE_3000059000, THE_3000059999 }

final kmValues = EnumValues({"sample string 8": Km.SAMPLE_STRING_8, "30.000 - 59.000": Km.THE_3000059000, "30.000 - 59.999": Km.THE_3000059999});

enum Note { ARACM_GNL_RAHATLYLA_KIRALAYABILIRSINIZ, ARACM_TEMIZDIR, SAMPLE_STRING_9 }

final noteValues = EnumValues({
  "Aracımı gönül rahatlığıyla kiralayabilirsiniz": Note.ARACM_GNL_RAHATLYLA_KIRALAYABILIRSINIZ,
  "Aracım temizdir.": Note.ARACM_TEMIZDIR,
  "sample string 9": Note.SAMPLE_STRING_9
});

enum TransmissionType { OTOMATIK, SAMPLE_STRING_6 }

final transmissionTypeValues = EnumValues({"Otomatik": TransmissionType.OTOMATIK, "sample string 6": TransmissionType.SAMPLE_STRING_6});

enum UserEmail { MEHMETALI_SAYAZILIM_COM, SAMPLE_STRING_3 }

final userEmailValues = EnumValues({"mehmetali@sayazilim.com": UserEmail.MEHMETALI_SAYAZILIM_COM, "sample string 3": UserEmail.SAMPLE_STRING_3});

enum UserName { MEHMET_ALI, SAMPLE_STRING_1 }

final userNameValues = EnumValues({"Mehmet Ali": UserName.MEHMET_ALI, "sample string 1": UserName.SAMPLE_STRING_1});

enum UserPhone { SAMPLE_STRING_4, THE_05532055567 }

final userPhoneValues = EnumValues({"sample string 4": UserPhone.SAMPLE_STRING_4, "05532055567": UserPhone.THE_05532055567});

enum UserSurname { KLL, SAMPLE_STRING_2 }

final userSurnameValues = EnumValues({"Kılıçlı": UserSurname.KLL, "sample string 2": UserSurname.SAMPLE_STRING_2});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
*/