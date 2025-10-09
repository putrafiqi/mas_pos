import 'package:flutter/material.dart';
import 'package:mas_pos/common/common.dart';
import 'package:mas_pos/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage._();

  static Route<void> route() =>
      MaterialPageRoute(builder: (context) => LoginPage._());

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFF2C59E5)],
                  ),
                ),
                child: Image.asset(
                  AssetString.splashImage2,
                  alignment: Alignment.topCenter,
                ),
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
