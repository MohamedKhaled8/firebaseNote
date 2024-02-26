import 'view/home/ui/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire/view/auth/ui/login.dart';
import 'package:flutterfire/view/auth/ui/signup.dart';
import 'package:flutterfire/view/note/view_note_screen.dart';
import 'package:flutterfire/view/categories/categories_add.dart';
import 'package:flutterfire/core/firebase/instanse/firebase_insatnse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('===========================User is currently signed out!');
      } else {
        print('===========================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[50],
              titleTextStyle: const TextStyle(
                  color: Colors.orange,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              iconTheme: const IconThemeData(color: Colors.orange))),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: ((FireBaseInstance.instanse.currentUser != null &&
              FireBaseInstance.instanse.currentUser!.emailVerified))
          ? const HomePageScreen() //home
          : const LoginScreen(),

      ///login
      routes: {
        "signup": (context) => const SignUpScreen(),
        "login": (context) => const LoginScreen(),
        "homePageScreen": (context) => const HomePageScreen(),
        "addcategory": (context) => const AddCategory(),
        // "viewNoteScreen": (context) => ViewNoteScreen(
        //       categoryid: '',
        //     ),
      },
    );
  }
}
