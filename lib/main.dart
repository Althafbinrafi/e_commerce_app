import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/cart_provider.dart';
import 'package:flutter_application_1/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'First Step',
        theme: ThemeData(
          primaryColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 218, 157, 14)),
          useMaterial3: true,
        ),
        home: const LoginPage());
  }
}
