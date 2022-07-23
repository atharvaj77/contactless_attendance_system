import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/screens/teacher/auth/teacher_signup.dart';
import 'package:contactless_attendance_system/screens/teacher/teacher_home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({Key? key}) : super(key: key);

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  AuthHelper _authHelper = AuthHelper();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  void loginTeacher() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _authHelper
          .signIn(_emailEditingController.text, _passwordEditingController.text)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const TeacherHome();
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
    var _mediaQuery = MediaQuery.of(context);
    return _isLoading
        ? Container(
            child: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Login as a Teacher'),
              backgroundColor: ColorData.teacherColor,
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: _mediaQuery.size.width,
                height: _mediaQuery.size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/teacher.jpg'),
                        const Text(
                          "Designed by pch.vector / Freepik",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 23),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
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
                                controller: _passwordEditingController,
                                obscureText: true,
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
                            ],
                          ),
                        )),
                    Column(
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: loginTeacher,
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                                onPressed: (() =>
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: ((context) {
                                        return const TeacherSignUp();
                                      })),
                                    )),
                                child: const Text('Register'))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
