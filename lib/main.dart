/*marjan hosen Oni
Daffodil international University
*/
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'common/splash.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light(),
      home:Splash(),
    );
  }
}
