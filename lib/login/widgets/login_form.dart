import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mas_pos/login/login.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHidePassword = true;
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: screenHeight * 0.25),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Form(
              key: loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _GreetingText(),

                  const Gap(32),

                  Text('Username', style: textTheme.titleSmall),
                  const Gap(8),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value != null &&
                          value.contains(
                            RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ),
                          )) {
                        return null;
                      }
                      return 'Masukan email yang valid';
                    },
                  ),
                  const Gap(24),
                  Text('Password', style: textTheme.titleSmall),
                  const Gap(8),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isHidePassword = !isHidePassword;
                          });
                        },
                        icon:
                            isHidePassword
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                      ),
                    ),
                    obscureText: isHidePassword,
                  ),
                  const Gap(32),
                  FilledButton(
                    onPressed: () {
                      if (loginFormKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                          LoginPressed(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Text('Masuk'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Selamat Datang di MASPOS',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        Text(
          'Masuk untuk klola bisnismu dengan mudah dan efisien. MASPOS hadirkan solusi point-of-sale terbaik untuk kemudahan operasional sehari-hari.',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
