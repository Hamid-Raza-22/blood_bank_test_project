import 'package:blood_bank_test_project/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'constant/size_helper.dart';
void main() {
  runApp(const MyApp());
}
//Ahmad
//hamid
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(context);
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SignInScreen(),
        );
      },
    );
  }
}