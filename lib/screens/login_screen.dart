import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traith/screens/admin/admin_home_screen.dart';
import 'package:traith/screens/home_screen.dart';
import 'package:traith/screens/signup_screen.dart';
import 'package:traith/utils/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> loginWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final user = userCredential.user;

      // Simple email check
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
          MaterialPageRoute(builder: (context) => AdminHomeScreen(isAdmin: false)),
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
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
                    child: SingleChildScrollView(
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

                          // Login Button
                          InkWell(
                            onTap: () async {
                              await loginWithEmailAndPassword();
                            },
                            child: Container(
                              height: 60,
                              width: double.infinity,
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
                              child: Center(
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColor.whiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                            "Don't have an account ? ",
                                style: TextStyle(fontSize: 18),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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


  void testFirebaseConnection() async {
    try {
      await FirebaseFirestore.instance.collection('test').add({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Hello from Flutter!',
      });
      print("✅ Firestore write successful!");
    } catch (e) {
      print("❌ Firestore error: $e");
    }
  }


}
