import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';

class BaseAuth extends StatefulWidget {
  final String title;
  final String description;
  final bool backToLogin;
  final Widget child;

  const BaseAuth({
    super.key,
    required this.title,
    required this.description,
    this.backToLogin = false,
    required this.child,
  });

  @override
  State<BaseAuth> createState() => _BaseAuthState();
}

class _BaseAuthState extends State<BaseAuth> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final safePadding = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () {
        if (widget.backToLogin) {
          _navigateToLoginPage();
        }

        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: safePadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                          ),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.description,
                            style: TextStyle(color: PrimaryColor.pureGrey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
