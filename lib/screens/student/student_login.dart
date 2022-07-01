import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/screens/student/student_home.dart';
import 'package:contactless_attendance_system/screens/student/student_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  AuthHelper _authHelper = AuthHelper();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  void loginStudent() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _authHelper
          .signIn(_emailEditingController.text, _passwordEditingController.text)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const StudentHome();
        }));
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        SnackBar snackBar = SnackBar(content: Text(e.code));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      SnackBar snackBar = const SnackBar(
          content: Text("Something went wront please try again later!"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login as a Student'),
        backgroundColor: ColorData.studentColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Image.asset(name)
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Please enter a valid email!',
                          labelText: 'Email'),
                      controller: _emailEditingController,
                    ),
                    TextField(
                      controller: _passwordEditingController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: 'Please enter your password',
                          labelText: 'Password'),
                    ),
                  ],
                ),
              )),
          Column(
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: loginStudent,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                  child: const Text(
                    'Login',
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
                  const Text('Not registered yet? '),
                  TextButton(
                      onPressed: (() => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: ((context) => const StudentSignUp())),
                          )),
                      child: const Text('Register'))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
