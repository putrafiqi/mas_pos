import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos/common/common.dart';
import 'package:mas_pos/data/data.dart';
import 'package:mas_pos/home/home.dart';
import 'package:mas_pos/login/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  if (kDebugMode) {
    // To solve CERTIFICATE_VERIFY_FAILED
    HttpOverrides.global = KHttpOverrides();
  }
  final secureStorage = FlutterSecureStorage();
  runApp(App(storage: secureStorage));
}

class App extends StatelessWidget {
  const App({super.key, required this.storage});
  final FlutterSecureStorage storage;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(storage: storage),
        ),
        RepositoryProvider(
          create:
              (context) => AuthRepository(context.read<AuthRemoteDataSource>()),
        ),
      ],
      child: BlocProvider(
        create:
            (context) =>
                AuthBloc(context.read<AuthRepository>())
                  ..add(AuthChangeRequested()),
        child: MaterialApp(
          theme: AppTheme.light,
          home: const AppView(),
          title: 'MasPOS',
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return HomePage();
        } else if (state.status == AuthStatus.unauthenticated) {
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
        return ColoredBox(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator.adaptive()),
        );
      },
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
