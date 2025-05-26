import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traith/screens/admin/admin_home_screen.dart';
import 'package:traith/screens/home_screen.dart';
import 'package:traith/utils/color.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;

      // Simple email check for admin
      if (user != null && user.email == 'yakykld@gmail.com') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomeScreen(isAdmin: true),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: false)),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.greenColor, AppColor.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: 100, // adjust as needed
                child: Container(
                  width: 350,
                  height: 250,
                  child: Image.asset('assets/63logo.png'),
                ),
              ),

              // Shadow-like effect container
              Positioned(
                top: 380, // Adjust this to control the shadow position

                child: Container(
                  height: 30, // Minimal height to create a shadow effect
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: AppColor.lightgrey.withOpacity(
                      0.5,
                    ), // Very light shadow effect
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              // Main Expanded Container
              Positioned(
                bottom: 0,
                child: Container(
                  height:
                      MediaQuery.of(context).size.height *
                      0.6, // Covers the bottom half
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to TRAITH',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 100),
                        // Email Input Field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Email',
                            fillColor: AppColor.whiteColor,
                            filled: true,
                            prefixIcon: Icon(Icons.mail_outline),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 231, 239, 236),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            fillColor: AppColor.whiteColor,
                            filled: true,
                            prefixIcon: Icon(Icons.lock),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color.fromARGB(179, 231, 239, 236),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),

                        // SignUp Button
                        InkWell(
                          onTap: () {
                            createUserWithEmailAndPassword();
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            child: Center(
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.greenColor,
                                  AppColor.lightGreen,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
