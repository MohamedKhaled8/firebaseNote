import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/auth/widgets/textformfield.dart';
import 'package:flutterfire/view/auth/widgets/customlogoauth.dart';
import 'package:flutterfire/view/auth/widgets/custombuttonauth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const CustomLogoAuth(),
                  const SizedBox(height: 20),
                  const Text("Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Login To Continue Using The App",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                      hinttext: "ُEnter Your Email",
                      mycontroller: email,
                      validator: (val) {
                        if (val == "") {
                          return "Can't To be Empty";
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                      validator: (val) {
                        if (val == "") {
                          return "Can't To be Empty";
                        }
                        return null;
                      },
                      hinttext: "ُEnter Your Password",
                      mycontroller: password),
                  InkWell(
                    onTap: () async {
                      if (email.text == "") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc:
                              "Please write your email and then click Forget Password",
                        ).show();
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        // ignore: use_build_context_synchronously
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc:
                              'A link to reset your password has been sent to your email. Please go to your email and click on the link.',
                        ).show();
                      } catch (e) {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    "Please make sure that the email you entered is correct and try again.")
                            .show();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  CustomButtonAuth(
                      title: "login",
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            if (credential.user!.emailVerified) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(credential.user!.uid)
                                  .set({
                                "email": email.text.trim(),
                                "password": password.text.trim()
                              }); // ignore: use_build_context_synchronously
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Success',
                                desc: 'Login successful!',
                              ).show();
                              Navigator.of(context)
                                  .pushReplacementNamed("homePageScreen");
                            } else {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    "Please go to the email to activate the account",
                              ).show();
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              // عندما لا يوجد مستخدم بهذا الايميل، عرض AwesomeDialog من نوع error
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'No user found for that email.',
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              // عندما تكون كلمة المرور غير صحيحة، عرض AwesomeDialog من نوع error
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Wrong password provided for that user',
                              ).show();
                            }
                          }
                        } else {
                          print("Not Valid");
                        }
                      }),

                  const SizedBox(height: 20),

                  MaterialButton(
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.red[700],
                      textColor: Colors.white,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Login With Google  "),
                          Image.asset(
                            "assets/images/4.png",
                            width: 20,
                          )
                        ],
                      )),
                  const SizedBox(height: 20),
                  // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "Don't Have An Account ? ",
                        ),
                        TextSpan(
                            text: "Register",
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                      ])),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
