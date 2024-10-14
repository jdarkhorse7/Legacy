import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegacyCoin extends StatefulWidget {
  const LegacyCoin({super.key, required this.action});

  final void Function()? action;

  @override
  State<LegacyCoin> createState() => _LegacyCoinState();
}

class _LegacyCoinState extends State<LegacyCoin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  startCoin() async {
    await _controller.forward();
    _controller.reset();
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 9), vsync: this);
    Future.delayed(const Duration(seconds: 4), () => startCoin());

    Timer.periodic(
      const Duration(seconds: 30),
      (timer) => startCoin(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bigCoin() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform(
              transform: Matrix4.rotationY(
                  Tween(begin: 0.0, end: 1.0).animate(_controller).value *
                      2 *
                      pi),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder(
                        side: BorderSide(color: Colors.white, width: 0.70))),
                    shadowColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 25, 25, 25))),
                onPressed: () {},
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage('assets/legacy.png'),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.cyanAccent.withOpacity(0.5),
                              Colors.transparent,
                              Colors.transparent
                            ])),
                  ),
                ),
              ),
            ),
          ),
          DefaultTextStyle(
            style: GoogleFonts.charmonman(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
            child: const Text(
              'Legacy',
            ),
          )
        ],
      );

  smallCoin() => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform(
          transform: Matrix4.rotationY(
              Tween(begin: 0.0, end: 1.0).animate(_controller).value * 2 * pi),
          alignment: Alignment.center,
          child: ElevatedButton(
            style: const ButtonStyle(
                shape: WidgetStatePropertyAll(CircleBorder(
                    side: BorderSide(color: Colors.white, width: 0.70))),
                shadowColor: WidgetStatePropertyAll(Colors.white),
                elevation: WidgetStatePropertyAll(2),
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 25, 25, 25))),
            onPressed: widget.action,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: const AssetImage('assets/legacy.png'),
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
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return smallCoin();
  }
}
