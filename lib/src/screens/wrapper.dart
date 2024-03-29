import 'package:csappliedteacherapp/src/app.dart';
import 'package:csappliedteacherapp/src/models/user.dart';
import 'package:csappliedteacherapp/src/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Myuser>(context);

    //return either homescreen or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Navigation(); //HomeScreen();
    }
  }
}
