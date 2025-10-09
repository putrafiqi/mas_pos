import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Positioned(
      top: 200,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _GreetingText(),

            const Gap(32),

            Text('Username', style: textTheme.titleSmall),
            const Gap(8),
            TextField(decoration: InputDecoration(hintText: 'Username')),
            const Gap(24),
            Text('Password', style: textTheme.titleSmall),
            const Gap(8),
            TextField(decoration: InputDecoration(hintText: 'Password')),
            const Gap(32),
            FilledButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Text('Masuk'),
              ),
            ),
          ],
        ),
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
