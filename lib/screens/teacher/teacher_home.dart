import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/auth_helper.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/main.dart';
import 'package:contactless_attendance_system/screens/teacher/section_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  bool _isLoading = false;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  late Stream<QuerySnapshot> sectionsStream;

  final TextEditingController _nameEditingController = TextEditingController();
  AuthHelper _authHelper = AuthHelper();

  void loadAllSections() async {
    _databaseHelper
        .searchSectionforTeacher(FirebaseAuth.instance.currentUser?.email)
        .then((val) => {
              setState(() {
                sectionsStream = val;
                _isLoading = false;
              })
            });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    loadAllSections();
  }

  Widget sectionsList() {
    return StreamBuilder<QuerySnapshot>(
        stream: sectionsStream,
        builder: ((context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => SectionView(
                                    sectionName: snapshot.data!.docs[index].id,
                                  ))));
                        }),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: ColorData.teacherColor,
                                child: SizedBox(
                                    width: double.infinity,
                                    height: 80.0,
                                    child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index].id,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]))))));
                  }))
              : const Center(
                  child: Text('No Sections found. Click + to add section'));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            child: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ColorData.teacherColor,
              title:
                  Text('Welcome ${FirebaseAuth.instance.currentUser!.email}'),
              actions: [
                IconButton(
                    onPressed: () {
                      _authHelper.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: ((context) => const MyApp())),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/sessions.jpg'),
                      const Text(
                        "Image from Freepik.com",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  sectionsList(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorData.teacherColor,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          child: Column(children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Create Section'),
                            ),
                            TextField(
                              controller: _nameEditingController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.receipt),
                                labelText: 'Enter section name',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Map<String, String> sectionInfo = {
                                  'sectionName': _nameEditingController.text,
                                  'teacherEmail':
                                      FirebaseAuth.instance.currentUser!.email!,
                                };

                                _databaseHelper.createSection(
                                    _nameEditingController.text, sectionInfo);
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              child: const Text('Done!'),
                            ),
                          ]),
                        ),
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
