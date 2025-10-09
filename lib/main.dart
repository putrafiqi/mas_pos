import 'package:flutter/material.dart';
import 'package:mas_pos/common/common.dart';
import 'package:mas_pos/login/login.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      home: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          //Image
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFF2C59E5)],
              ),
              image: DecorationImage(
                alignment: Alignment.bottomCenter,
                image: AssetImage(AssetString.splashImage2),
              ),
            ),
          ),
          // White Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 1],
                colors: [Colors.white, Colors.white.withAlpha(100)],
              ),
            ),
          ),

          _SloganText(),

          _ButtonNext(),
        ],
      ),
    );
  }
}

class _SloganText extends StatelessWidget {
  const _SloganText();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Positioned(
      top: 75,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Kasir Pintar, Bisnis Lancar!', style: textTheme.headlineMedium),
          RichText(
            text: TextSpan(
              style: textTheme.headlineMedium,
              text: 'Yuk, Coba',
              children: [
                TextSpan(
                  style: textTheme.headlineMedium?.copyWith(
                    color: Color(0xFF2C59E5),
                    fontWeight: FontWeight.bold,
                  ),
                  text: ' MASPOS',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonNext extends StatelessWidget {
  const _ButtonNext();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 75,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FilledButton(
          onPressed: () {
            Navigator.push(context, LoginPage.route());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Yuk mulai coba'),
                Image.asset(AssetString.arrowRight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
