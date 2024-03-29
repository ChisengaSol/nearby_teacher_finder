import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/services/auth.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:csappliedteacherapp/src/shared/loading.dart';
import 'package:flutter/material.dart';

import 'helperfunctions.dart';

//validator classes
class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.length < 8 ? 'Password should have more than 8 characters' : null;
  }
}

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  LoginScreen({this.toggleView});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DatabaseService databaseService = new DatabaseService();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  QuerySnapshot snapshotUserInfo;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            // the login ui
            body: Padding(
            padding: EdgeInsets.all(25),
            child: Form(
              //associate global key with form
              key: _formKey,

              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        Icons.person_outline_outlined,
                        color: Colors.grey[300],
                        size: 140,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Login to continue",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextFormField(
                          key: const ValueKey("userEmail"),
                          validator: EmailFieldValidator.validate,
                          //updates state of email when user is typing
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.mail,
                              size: 30,
                            ),
                            labelText: "EMAIL",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          key: const ValueKey("password"),
                          obscureText: true,
                          validator: PasswordFieldValidator.validate,
                          //updates state of password when user is typing
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 30,
                            ),
                            labelText: "PASSWORD",
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: FlatButton(
                          key: const ValueKey("Login"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              HelperFunctions.saveUserEmailSharedPreference(
                                  email);

                              databaseService
                                  .getUserByEmail(email)
                                  .then((value) {
                                snapshotUserInfo = value;
                                HelperFunctions.saveUserEmailSharedPreference(
                                    snapshotUserInfo.docs[0].data()["email"]);
                                //print('${snapshotUserInfo.docs[0].data()["email"]} This my email');
                              });

                              setState(() => loading = true);

                              dynamic result = await _auth.emailAndPwordSignIn(
                                  email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Sign in failed. Please check your credentials';
                                  loading = false;
                                });
                              }

                              HelperFunctions.saveUserLoggedInSharedPreference(
                                  true);
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text("Login"),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            key: ValueKey("createAccount"),
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
          ));
  }
}
