import 'package:flutter/material.dart';

import 'package:se_project/signup.dart';
import 'package:se_project/view-products.dart';
import 'login.dart' as log;
import 'seller-viewall.dart' as all;
import 'adminDashboard.dart' as opt;
import 'add-product.dart' as add;
import 'salesreport.dart' as sales;
import 'all_users.dart' as users;
import 'display_deleted_users.dart' as deleted;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile shop',
      home: log.LoginPage(),
      routes: {
        '/signup': (context) => SignUpForm(),
        '/view-products': (context) => ViewAllProduct(),
        '/options': (context) => opt.MyHomePage(),
        '/seller-viewall': (context) => all.ResponsiveProductTable(),
        '/Sales-Report': (context) => sales.SalesReportPage(),
        '/add-product': (context) => add.CreateProduct(),
        '/all-users': (context) => users.DataDisplayScreen(),
        '/deleted-users': (context) => const deleted.DeletedUsersScreen(),
      },
    );
  }
}
