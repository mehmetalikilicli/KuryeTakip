import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kurye_takip/model/cars_list.dart';
import 'package:kurye_takip/model/rent_request_notification.dart';

class CustomDialog {
  static Future<void> showMessage({
    BuildContext? context,
    String? title,
    String? message,
    String? positiveButtonText,
    Function? onPositiveButtonPressed,
    String? negativeButtonText,
    Function? onNegativeButtonPressed,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: title != null ? Text(title, textAlign: TextAlign.center) : null,
          content: message != null ? Text(message, textAlign: TextAlign.center) : null,
          actions: <Widget>[
            Visibility(
              visible: negativeButtonText != null,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onNegativeButtonPressed != null) {
                    onNegativeButtonPressed();
                  }
                },
                child: Text(negativeButtonText ?? 'Kapat'),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPositiveButtonPressed != null) {
                  onPositiveButtonPressed();
                }
              },
              child: Text(positiveButtonText ?? 'Tamam'),
            ),
          ],
        );
      },
    );
  }
}

class RenterCommentBottomSheet {
  static Future<void> showComments({
    required BuildContext context,
    String? title,
    String? message,
    String? positiveButtonText,
    required RentNotification rentNotification,
    Function? onPositiveButtonPressed,
    String? negativeButtonText,
    Function? onNegativeButtonPressed,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Renter bilgileri
              const Text("Kişi Bilgileri", style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rentNotification.renterName ?? '', style: const TextStyle(fontSize: 12)),
                    Text(rentNotification.renterEmail ?? '', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              const Divider(thickness: 2),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: rentNotification.renterComment!.length,
                  itemBuilder: (BuildContext context, int index) {
                    RenterComment? comment = rentNotification.renterComment![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: rentNotification.renterComment![index].point.toDouble(),
                              itemCount: 5,
                              itemSize: 18.0,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Değerlendirme: ${comment.comment}"),
                        ),
                        const Divider(thickness: 2),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: negativeButtonText != null,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onNegativeButtonPressed != null) {
                          onNegativeButtonPressed();
                        }
                      },
                      child: Text(negativeButtonText ?? 'Kapat'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onPositiveButtonPressed != null) {
                        onPositiveButtonPressed();
                      }
                    },
                    child: Text(positiveButtonText ?? 'Tamam'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CarCommentBottomSheet {
  static Future<void> showComments({
    required BuildContext context,
    String? title,
    String? message,
    String? positiveButtonText,
    required CarElement carElement,
    Function? onPositiveButtonPressed,
    String? negativeButtonText,
    Function? onNegativeButtonPressed,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Renter bilgileri
              const Text("Araç Bilgileri", style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(carElement.brandName ?? '', style: const TextStyle(fontSize: 12)),
                    Text(carElement.modelName ?? '', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              const Divider(thickness: 2),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: carElement.carComments!.length,
                  itemBuilder: (BuildContext context, int index) {
                    CarComment? comment = carElement.carComments![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: 3,
                              itemCount: 5,
                              itemSize: 18.0,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Değerlendirme: ${comment.comment}"),
                        ),
                        const Divider(thickness: 2),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onNegativeButtonPressed != null) {
                        onNegativeButtonPressed();
                      }
                    },
                    child: Text(negativeButtonText ?? 'Kapat'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onPositiveButtonPressed != null) {
                        onPositiveButtonPressed();
                      }
                    },
                    child: Text(positiveButtonText ?? 'Tamam'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
