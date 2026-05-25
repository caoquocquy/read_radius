import 'package:book_radius/app/router.dart';
import 'package:book_radius/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ReadRadiusApp extends StatelessWidget {
  const ReadRadiusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ReadRadius',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
