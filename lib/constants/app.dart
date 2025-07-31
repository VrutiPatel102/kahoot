import 'package:flutter/cupertino.dart';

import 'app_images.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages().backgroundImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(child: child),
    );
  }
}
