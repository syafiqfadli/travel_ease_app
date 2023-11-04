import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/route_page.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';

class DialogService {
  static Future showMessage<T>({
    required String title,
    required bool hasAction,
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
            message != null
                ? Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : const SizedBox.shrink(),
          ],
        ),
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
          hasAction
              ? SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoutePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: PrimaryColor.navyBlack,
                      backgroundColor: PrimaryColor.pureWhite,
                      side: BorderSide(color: PrimaryColor.navyBlack),
                    ),
                    child: const Text('View'),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  static Future logInMessage<T>({
    required BuildContext context,
  }) async {
    double width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Log In Account"),
                IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Text("👋", style: TextStyle(fontSize: 50)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "You need to log in first.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              "Please log in or register first to make transactions.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('Log In'),
            ),
          ),
        ],
      ),
    );
  }
}
