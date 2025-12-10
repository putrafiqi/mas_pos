import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/common/common.dart';
import 'package:mas_pos/data/data.dart';
import 'package:mas_pos/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage._();

  static Route<void> route() =>
      MaterialPageRoute(builder: (context) => LoginPage._());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(context.read<AuthRepository>()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            context.read<AuthBloc>().add(AuthChangeRequested());
            Navigator.pop(context);
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                AppSnackBar(message: state.errorMessage!, isError: true),
              );
          }
        },
        child: const LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.4,
              width: double.infinity,
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
                fit: BoxFit.cover,
              ),
            ),
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}
