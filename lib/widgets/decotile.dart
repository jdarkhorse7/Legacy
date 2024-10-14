import 'package:flutter/material.dart';

class DecoTile extends StatelessWidget {
  const DecoTile({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {

  
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 5),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              // begin: even? Alignment.topLeft :Alignment.topRight, end:  even? Alignment.bottomRight :Alignment.bottomLeft,

              colors: [
                Colors.teal.withOpacity(0.75),
                const Color.fromARGB(255, 17, 17, 17)
              ])),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: const Color.fromARGB(255, 17, 17, 17).withOpacity(0.98),
          padding: const EdgeInsets.only(bottom: 8),
          child: child,
        ),
      ),
    );
  }
}
