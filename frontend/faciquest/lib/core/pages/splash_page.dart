import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    offset: const Offset(1, 1)),
                BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    offset: const Offset(-1, -1))
              ]),
        ),
      ),
    );
  }
}
