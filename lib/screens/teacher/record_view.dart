import 'package:contactless_attendance_system/screens/teacher/attendance_view.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:contactless_attendance_system/helpers/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactless_attendance_system/constant/color_data.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RecordView extends StatefulWidget {
  final String sectionName;
  const RecordView({Key? key, required this.sectionName}) : super(key: key);

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  bool _isLoading = false;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  late Stream<QuerySnapshot> sessionsStream;
  TextEditingController _nameEditingController = TextEditingController();

  void _loadSessions() async {
    _databaseHelper.searchSessionsofClass(widget.sectionName).then((val) => {
          setState((() {
            _isLoading = false;
            sessionsStream = val;
          }))
        });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _loadSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: ColorData.teacherColor,
              title: Text(widget.sectionName),
            ),
            body: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: sessionsStream,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data!.size,
                          itemBuilder: ((context, index) {
                            return InkWell(
                                onTap: (() => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: ((context) => AttendanceView(
                                                sessionId: snapshot
                                                    .data!.docs[index].id,
                                                sectionName: widget.sectionName,
                                              ))),
                                    )),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        color: ColorData.teacherColor,
                                        child: SizedBox(
                                            width: double.infinity,
                                            height: 80.0,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data!
                                                            .docs[index].id,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ]))))));
                          }))
                      : Container();
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorData.teacherColor,
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Create Session',
                                style: TextStyle(
                                    color: ColorData.teacherColor,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                controller: _nameEditingController,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.receipt),
                                  labelText: 'Enter session name',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _databaseHelper
                                    .searchSessionsofClassget(
                                        widget.sectionName,
                                        _nameEditingController.text)
                                    .then((val) {
                                  val.exists
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Session with same name already exists')))
                                      : _databaseHelper.createSession(
                                          widget.sectionName,
                                          _nameEditingController.text);
                                });
                                setState(() {
                                  _loadSessions();
                                });
                                Navigator.of(context).pop();

                                String qrData = widget.sectionName +
                                    '/' +
                                    _nameEditingController
                                        .text; // 'csb/29-06-2022'

                                final key =
                                    encrypt.Key.fromUtf8('VITisbestCollege');
                                final iv = encrypt.IV.fromLength(16);
                                final encrypter =
                                    encrypt.Encrypter(encrypt.AES(key));
                                final encryptedQR =
                                    encrypter.encrypt(qrData, iv: iv);
                                final decryptedQR =
                                    encrypter.decrypt(encryptedQR, iv: iv);

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              QrImage(
                                                data: encryptedQR.base64,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _databaseHelper
                                                        .disactivateSession(
                                                            widget.sectionName,
                                                            _nameEditingController
                                                                .text);
                                                  },
                                                  child: const Text('Done'))
                                            ]),
                                      );
                                    });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              child: const Text('Generate Session'),
                            ),
                          ]),
                        ),
                      );
                    });
              },
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
