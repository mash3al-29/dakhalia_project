import 'package:dakhalia_project/presntation/pages/dashboard_page.dart';
import 'package:dakhalia_project/presntation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farm Orchard Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            // Handle error or null data case
            return LoginPage(); // or redirect to another error handling page
          } else {
            return snapshot.data!;
          }
        },
      ),
      routes: {
        DashboardPage.routeId: (context) => DashboardPage(),
        LoginPage.routeId: (context) => LoginPage(),
      },
      onUnknownRoute: (settings) {
        // Handle unknown routes here, e.g., redirect to a 404 page
        return MaterialPageRoute(builder: (_) => LoginPage());
      },
    );
  }

  Future<Widget> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool("rememberMe") ?? false;
    if (rememberMe) {
      return DashboardPage();
    } else {
      return LoginPage();
    }
  }
}
