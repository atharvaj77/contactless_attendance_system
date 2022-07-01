import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/screens/teacher/teacher_home.dart';
import 'package:contactless_attendance_system/screens/teacher/auth/teacher_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherSignUp extends StatefulWidget {
  const TeacherSignUp({Key? key}) : super(key: key);

  @override
  State<TeacherSignUp> createState() => _TeacherSignUpState();
}

class _TeacherSignUpState extends State<TeacherSignUp> {
  bool _isLoading = false;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  AuthHelper _authHelper = AuthHelper();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void signUpTeacher() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _authHelper
          .signUp(_emailEditingController.text, _passwordEditingController.text)
          .then((value) {
        if (value != null) {
          Map<String, String> teacherData = {
            'name': _nameEditingController.text,
            'email': _emailEditingController.text,
          };

          User? user = FirebaseAuth.instance.currentUser;

          _databaseHelper.uploadTeacherInfo(user!.uid, teacherData);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const TeacherHome())),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          SnackBar snackBar =
              const SnackBar(content: Text("Teacher Already Exists"));

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
    return _isLoading
        ? Container(
            child: const Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Register as a Teacher'),
              backgroundColor: ColorData.teacherColor,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Image.asset(name)
                Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameEditingController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.portrait),
                              hintText: 'Please enter your Name',
                              labelText: 'Name'),
                        ),
                        TextField(
                          controller: _emailEditingController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Please enter your email',
                              labelText: 'Email'),
                        ),
                        TextField(
                          controller: _passwordEditingController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              hintText: 'Please enter a new password',
                              labelText: 'Password'),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: signUpTeacher,
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
                        const Text('Already have an account?'),
                        TextButton(
                            onPressed: (() =>
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const TeacherLogin())),
                                )),
                            child: const Text('Login'))
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
