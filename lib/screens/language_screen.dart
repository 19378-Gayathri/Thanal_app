import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('select_language'.tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome'.tr(), style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.setLocale(const Locale('en'));
              },
              child: const Text('English'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.setLocale(const Locale('ml'));
              },
              child: const Text('മലയാളം'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.setLocale(const Locale('hi'));
              },
              child: const Text('हिन्दी'),
            ),
          ],
        ),
      ),
    );
  }
}
