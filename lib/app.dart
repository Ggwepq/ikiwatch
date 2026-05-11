import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/screens/app_shell.dart';

class IkiwatchApp extends StatelessWidget {
  const IkiwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ikiwatch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
