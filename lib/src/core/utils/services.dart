import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';

class DialogService {
  static Future showMessage<T>({
    required String title,
    void Function()? actionFunction,
    String? message,
    required IconData icon,
    required BuildContext context,
  }) async {
    double width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          children: [
            Icon(icon, size: 45),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        content: message != null
            ? Text(
                message,
                textAlign: TextAlign.center,
              )
            : null,
        actions: [
          SizedBox(
            width: width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PrimaryColor.navyBlack,
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
