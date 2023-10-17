import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0E0E0),
              Color(0xFFBDBDBD),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: buildOptionButton(
                  context,
                  'Manage Product',
                  Icons.shopping_cart,
                ),
              ),
              SizedBox(
                width: 200,
                child: buildOptionButton(
                  context,
                  'Salesmen',
                  Icons.person,
                ),
              ),
              SizedBox(
                width: 200,
                child: buildOptionButton(
                  context,
                  'Sales Report',
                  Icons.insert_chart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionButton(
      BuildContext context, String title, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          if (title == 'Manage Product') {
            Navigator.pushNamed(context, '/view-products');
          } else if (title == 'Salesmen') {
            Navigator.pushNamed(context, '/all-users');
          } else if (title == 'Sales Report') {
            Navigator.pushNamed(context, '/Sales-Report');
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 30,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
