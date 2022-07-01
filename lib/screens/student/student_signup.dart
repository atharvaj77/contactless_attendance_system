import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/screens/student/student_home.dart';
import 'package:contactless_attendance_system/screens/student/student_login.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as a Student'),
        backgroundColor: ColorData.studentColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Image.asset(name)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(children: [
                    TextField(
                      controller: _nameEditingController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.portrait),
                          hintText: 'Please enter your name',
                          labelText: 'Name'),
                    ),
                    TextField(
                      controller: _rollnoEditingController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Please enter your roll number',
                          labelText: 'Roll Number'),
                    ),
                    TextField(
                      controller: _emailEditingController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Please enter a valid email!',
                          labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordEditingController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: 'Please enter your password',
                          labelText: 'Password'),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: signUpStudent,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      child: Text('Login'))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
