import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage(
                'assets/legacy.png',
              ),
              radius: 60,
              backgroundColor: Colors.black87,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.cyanAccent.withOpacity(0.34),
                          Colors.transparent,
                          Colors.transparent
                        ])),
              ),
            ),
            const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 0.75,
                strokeCap: StrokeCap.round,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
