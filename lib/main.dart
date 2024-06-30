import 'package:expense_manager/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'authentication/login_page.dart';
import 'authentication/sign_up_page.dart';
import 'home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCQzLjNRl6iFz7OfwPpAg2ba-K1ANsahuE",
        appId: "1:1017005018689:android:f6723560abd5aa745040c0",
        messagingSenderId: "1017005018689",
        projectId: "expense-manager-7fa29",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false; // check user logged in or not
    if (isLoggedIn) { // if user is logged in, open dashboard
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(

            child: HomePage(),
          ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),

        }, //dashboard
      );
    } else {// if user isn't logged in, open login page
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(

            child: LoginPage(),
          ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),

        }, //login page
      );
    }
  }
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   routes: {
    //     '/': (context) => SplashScreen(
    //
    //       child: LoginPage(),
    //     ),
    //     '/login': (context) => LoginPage(),
    //     '/signUp': (context) => SignUpPage(),
    //     '/home': (context) => HomePage(),
    //
    //   },
    // );
  // }
}

