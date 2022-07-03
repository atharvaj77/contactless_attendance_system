import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelper {
  getTeacherInfoByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('Teachers')
        .where('email', isEqualTo: email)
        .get();
  }

  getTeacherInfoByName(String name) async {
    return await FirebaseFirestore.instance
        .collection('Teachers')
        .where('name', isEqualTo: name)
        .get();
  }

  uploadTeacherInfo(String username, Map<String, String> teacherInfo) {
    FirebaseFirestore.instance
        .collection('Teachers')
        .doc(username)
        .set(teacherInfo);
  }

  getStudentInfoByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection('Students')
        .where('email', isEqualTo: email)
        .get();
  }

  getStudentInfoByName(String username) async {
    return await FirebaseFirestore.instance
        .collection('Students')
        .where('name', isEqualTo: username)
        .get();
  }

  uploadStudentInfo(String username, Map<String, String> studentInfo) {
    FirebaseFirestore.instance
        .collection('Students')
        .doc(username)
        .set(studentInfo);
  }

  searchSectionforTeacher(String? teacherEmail) async {
    return FirebaseFirestore.instance
        .collection('Sections')
        .where('teacherEmail', isEqualTo: teacherEmail)
        .snapshots();
  }

  createSection(String sectionName, Map<String, String> sectionInfo) {
    FirebaseFirestore.instance
        .collection('Sections')
        .doc(sectionName)
        .set(sectionInfo);
  }

  searchSessionsofClass(String sectionName) async {
    return FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionName)
        .collection('Sessions')
        .snapshots();
  }

  searchSessionsofClassget(String sectionName, String sessionId) async {
    return FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionName)
        .collection('Sessions')
        .doc(sessionId)
        .get();
  }

  deleteSessionsofClass(String sectionName, String sessionId) async {
    return await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionName)
        .collection('Sessions')
        .doc(sessionId)
        .delete();
  }

  createSession(String sectionName, String sessionId) {
    FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionName)
        .collection('Sessions')
        .doc(sessionId)
        .set({'sessionName': sessionId, 'active': true});

    FirebaseFirestore.instance
        .collection('Sections')
        .doc(sectionName)
        .collection('Students')
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((element) {
        Map<String, dynamic> studData = {
          'studentEmail': element['studentEmail'],
          'studentName': element['studentName'],
          'attending': false
        };

        FirebaseFirestore.instance
            .collection('Attendance')
            .doc(sectionName)
            .collection('Sessions')
            .doc(sessionId)
            .collection('Attendees')
            .doc(element.id)
            .set(studData);
      });
    });
  }

  disactivateSession(String sectionName, String sessionId) {
    FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionName)
        .collection('Sessions')
        .doc(sessionId)
        .set({'sessionName': sessionId, 'active': false});
  }

  getStudentsforSection(String sectionName) async {
    return FirebaseFirestore.instance
        .collection('Sections')
        .doc(sectionName)
        .collection('Students')
        .snapshots();
  }

  addStudenttoSection(String sectionName, String rollNo, String studentName,
      String studentEmail) {
    FirebaseFirestore.instance
        .collection('Sections')
        .doc(sectionName)
        .collection('Students')
        .doc(rollNo)
        .set({'studentName': studentName, 'studentEmail': studentEmail});
  }

  deleteStudentfromSection(String sectionName, String rollNo) async {
    return await FirebaseFirestore.instance
        .collection('Sections')
        .doc(sectionName)
        .collection('Students')
        .doc(rollNo)
        .delete();
  }

  getAttendanceStatus(String sectionName, String sessionId) async {
    return FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionName)
        .collection('Sessions')
        .doc(sessionId)
        .collection('Attendees')
        .snapshots();
  }

  markStudentAttendance(String sectionId, String sessionId, String rollNumber) {
    FirebaseFirestore.instance
        .collection('Attendance')
        .doc(sectionId)
        .collection('Sessions')
        .doc(sessionId)
        .collection('Attendees')
        .doc(rollNumber)
        .update({'attending': true});
  }
}
