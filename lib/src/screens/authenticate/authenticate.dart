//import 'package:cs_applied_project/src/screens/authenticate/sign_in.dart';
import 'package:csappliedteacherapp/src/screens/authenticate/login.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginScreen(),      
    );
  }
}