import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:traith/screens/admin/gallery_view.dart';
import 'package:traith/screens/admin/event_screen.dart';

import '../../utils/color.dart';
import 'officier_details.dart';

class AdminHomeScreen extends StatefulWidget {
  final bool isAdmin;
  const AdminHomeScreen({super.key, required this.isAdmin});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      OfficiersDetails(isAdmin: widget.isAdmin),
      EventScreen(isAdmin: widget.isAdmin),
      GalleryView(),
    ];
    return Scaffold(
      backgroundColor:Colors.grey[200],
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.event, size: 30, color: Colors.black),
          Icon(Icons.camera, size: 30, color: Colors.black),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}


