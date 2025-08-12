import 'package:flutter/cupertino.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const AppBackground({
    super.key,
    required this.child,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
      ),
      child: Center(child: child),
    );
  }
}
