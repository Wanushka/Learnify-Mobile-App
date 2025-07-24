import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learnifyapp/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:learnifyapp/providers/auth_provider.dart';
import 'package:learnifyapp/providers/course_provider.dart';
import 'package:learnifyapp/providers/quiz_provider.dart';
import 'package:learnifyapp/screens/auth/splash_screen.dart';
import 'package:learnifyapp/screens/auth/login_screen.dart';
import 'package:learnifyapp/screens/auth/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}