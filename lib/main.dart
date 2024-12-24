import 'package:app_web_ecommerce/views/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WebAppDashboard());
}

class WebAppDashboard extends StatelessWidget {
  const WebAppDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
