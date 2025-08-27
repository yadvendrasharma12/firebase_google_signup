import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_signin/screens/forget_password_screen.dart';
import 'package:google_signin/screens/home_screen.dart';
import 'package:google_signin/screens/signIn_screen.dart';
import 'package:google_signin/screens/signUp_screen.dart';
import 'package:google_signin/services/auth_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Auth Demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  AuthWrapper(),
      routes: {
        '/signin': (_) =>  const SignInScreen(),
        '/signup': (_) =>  const SignUpScreen(),
        '/forgot': (_) =>  const ForgotPasswordScreen(),
        '/home': (_) =>  const HomeScreen(),
      },
    );
  }
}
