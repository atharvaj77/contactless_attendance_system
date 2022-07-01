import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/main.dart';
import 'package:contactless_attendance_system/screens/student/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  AuthHelper _authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  _authHelper.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => const MyApp())),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white))
          ],
          backgroundColor: ColorData.studentColor,
          title: Text('Welcome ${FirebaseAuth.instance.currentUser!.email}'),
          bottom: TabBar(
            tabs: [
              // Todo : Add concrete implementation
              Tab(text: 'Give Attendance'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (() => Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => QRScan())),
                    )),
                child: Text('Scan QR Code'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorData.studentColor)),
              )
            ],
          ),
          Container(),
        ]),
      ),
    );
  }
}
