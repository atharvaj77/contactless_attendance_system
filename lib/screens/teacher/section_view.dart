import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:contactless_attendance_system/screens/teacher/attendance_view.dart';
import 'package:contactless_attendance_system/screens/teacher/record_view.dart';
import 'package:contactless_attendance_system/screens/teacher/stud_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SectionView extends StatefulWidget {
  String sectionName;

  SectionView({Key? key, required this.sectionName}) : super(key: key);

  @override
  State<SectionView> createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorData.teacherColor,
        title: Text(widget.sectionName),
      ),
      body: ListView(
        children: [
          InkWell(
              onTap: (() => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: ((context) =>
                            RecordView(sectionName: widget.sectionName))),
                  )),
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
                                      'Sessions',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])))))),
          InkWell(
              onTap: (() => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: ((context) =>
                            StudentListView(sectionName: widget.sectionName))),
                  )),
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
                                      'Student List',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])))))),
        ],
      ),
    );
  }
}
