import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/screens/student/student_home.dart';
import 'package:contactless_attendance_system/screens/student/auth/student_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({Key? key}) : super(key: key);

  @override
  State<StudentSignUp> createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  bool _isLoading = false;
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _rollnoEditingController = TextEditingController();
  TextEditingController _nameEditingController = TextEditingController();
  AuthHelper _authHelper = AuthHelper();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void signUpStudent() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _authHelper
          .signUp(_emailEditingController.text, _passwordEditingController.text)
          .then((value) {
        if (value != null) {
          Map<String, String> studentData = {
            'name': _nameEditingController.text,
            'email': _emailEditingController.text,
            'rollNo': _rollnoEditingController.text,
          };

          User? user = FirebaseAuth.instance.currentUser;

          _databaseHelper.uploadStudentInfo(user!.uid, studentData);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const StudentHome())),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          SnackBar snackBar =
              const SnackBar(content: Text("Student Already Exists"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register as a Student'),
        backgroundColor: ColorData.studentColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/student.jpg',
                  width: _mediaQuery.size.width * 0.8,
                ),
                const Text(
                  "Image from Freepik.com",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _nameEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.portrait),
                            hintText: 'Please enter your name',
                            labelText: 'Name'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _rollnoEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.adb_outlined),
                            hintText: 'Please enter your roll number',
                            labelText: 'Roll Number'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _emailEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Please enter a valid email!',
                            labelText: 'Email'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        obscureText: true,
                        controller: _passwordEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintStyle: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                            prefixIcon: Icon(Icons.password),
                            hintText: 'Please enter your password',
                            labelText: 'Password'),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _mediaQuery.size.height * 0.03,
            ),
            Column(
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: signUpStudent,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        )),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                        onPressed: (() => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: ((context) => const StudentLogin())),
                            )),
                        child: const Text('Login'))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
