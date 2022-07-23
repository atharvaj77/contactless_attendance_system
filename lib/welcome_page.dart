import 'package:contactless_attendance_system/screens/student/auth/student_login.dart';
import 'package:contactless_attendance_system/screens/teacher/auth/teacher_login.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Welcome to Contact-Less Attendance System',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoSlab',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Simple | Hassel-free | Secure',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontFamily: 'JosefinSans'),
                ),
              ],
            ),
            Image.asset(
              'assets/images/welcome.jpg',
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: (() => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: ((context) => const TeacherLogin())),
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Login as Teacher',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: (() => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: ((context) => StudentLogin())),
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Login as Student',
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
