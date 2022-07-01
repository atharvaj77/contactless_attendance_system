import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/screens/student/student_login.dart';
import 'package:contactless_attendance_system/screens/teacher/auth/teacher_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherLogin()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Container(
              height: 150,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorData.teacherColor,
              ),
              margin: EdgeInsets.all(10.0),
              child: const Center(
                  child: Text(' Login as \nTeacher',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ))),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentLogin(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Container(
              height: 150,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorData.studentColor,
              ),
              margin: EdgeInsets.all(10.0),
              child: const Center(
                  child: Text(' Login as \nStudent',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ))),
            ),
          ),
        ),
      ],
    );
  }
}
