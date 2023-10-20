import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';

class BaseAuth extends StatefulWidget {
  final String title;
  final String description;
  final Widget child;
  const BaseAuth({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  State<BaseAuth> createState() => _BaseAuthState();
}

class _BaseAuthState extends State<BaseAuth> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
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
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
}
