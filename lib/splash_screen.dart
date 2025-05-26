import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:traith/screens/home_screen.dart';
import 'package:traith/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Image.asset('assets/63logo.png', width: 300),
      ),
    );
  }
}

/*

              ElevatedButton(onPressed: ()async{
                try {
                  final collectionPath='officers_detail';
                  final collection = FirebaseFirestore.instance.collection(collectionPath);
                  final snapshot = await collection.get();

                  for (final doc in snapshot.docs) {
                    await doc.reference.delete();
                  }

                  // Optional success message
                  print('All documents in $collectionPath deleted successfully');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All data deleted from $collectionPath')),
                  );
                } catch (e) {
                  print('Error deleting documents: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting data: $e')),
                  );
                }
              }, child: Text("delete")),



 */