import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_help/services/authentication.dart';

class TeacherBasicSecPage extends StatefulWidget {
  TeacherBasicSecPage({required Key key, required this.auth, required this.userId, required this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;

  final String userId;

  @override
  State<StatefulWidget> createState() => new _TeacherBasicSecPageState();
}

class _TeacherBasicSecPageState extends State<TeacherBasicSecPage> {
  //final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  //final _textEditingController = TextEditingController();
  //bool _isEmailVerified = false;
  String subject= " ";
  String month = " ";
  String year = " ";
  String str =  " ";
  String userId = " ";
  int shows = 0;

  bool validateAndSave() {
    final form = _formKey2.currentState;
    if (form != null && !form.validate()) {

      return false;
    }
    form?.save();
    return true;
    }


  @override
  void initState() {
    userId = widget.userId;
    super.initState();
    //_checkEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    if (shows == 0) {
      return showEntryPage();
    } else {
      return showDataPage();
    }
  }

  Widget showEntryPage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          //resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        enterDetails(),
                        formInput(),
                        GestureDetector(
                          onTap: () {
                            if (validateAndSave()) {
                              setState(() {
                                shows = 1;
                              });
                              //showDataPage();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(70),
                            width: 300,
                            height: 40,
                            //color:Colors.pink,
                            decoration: BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.rectangle,
                                //borderRadius: BorderRadius.circular(10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: const Center(
                              child: Text(
                                'View',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget formInput() {
    return SingleChildScrollView(
      child: new Container(
          //padding: EdgeInsets.all(2.0),
          child: new Form(
        key: _formKey2,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            subjCodeInput(),
            dateInput(),
            yearInput(),
          ],
        ),
      )),
    );
  }

  Widget enterDetails() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        width: 280,
        height: 50,
        alignment: Alignment(80, 30),
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          //borderRadius: BorderRadius.circular(12),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: const Center(
          child: Text(
            'Enter Details',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget subjCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 5.0),
      child: new TextFormField(
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          hintText: 'Enter Subject',
        ),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (String? value){ if(value!.isEmpty) {return null;}
        return "Enter Subject First";
        },

        onSaved: (value) => month = value.toString(),
      ),
    );
  }

  Widget dateInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        decoration: new InputDecoration(
          hintText: 'Enter Month',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.datetime,
        autofocus: false,
        validator: (String? value){ if(value!.isEmpty) {return null;}
        return "Enter Month";
        },

        onSaved: (value) => month = value.toString(),
      ),
    );
  }

  Widget yearInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        decoration: new InputDecoration(
          hintText: 'Enter Year',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (String? value){ if(value!.isEmpty) {return null;}
        return "Enter Year";
        },

        onSaved: (value) => year = value.toString(),
      ),
    );
  }

  Widget showDataPage() {
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeachDetails()));
    return Scaffold(
      body:Container(
        child: FutureBuilder(
          future: getData(),

          builder: (BuildContext context,AsyncSnapshot snapshot){

            if(snapshot.data == null)
            {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 10),
                    Text('Loading'),
                  ],
                ),
              );
              //return Center(child: Container(child: Text('Loading Data',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),));
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DataTable(
                    sortColumnIndex: 0,
                      sortAscending: true,
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Attended'),numeric: true)
                      ],
                      rows:snapshot.data.entries.map<DataRow>((entry){
                        return DataRow(cells:[
                          DataCell(Text(entry.key)),
                          DataCell(Text(entry.value.toString())),
                        ]);
                      }).toList()),
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0,0),
                      child: RaisedButton(
                        color: Colors.indigo,
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              shows = 0;
                            });
                          },
                          child: Text('Return')),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }


  Future<Map> getData() async {
    var attendance = new Map();
    int? subCount = 0;
    String queryMonth = month.toString() + '.' + year.toString();
    var j1;
  var users = await FirebaseFirestore.instance.collection('users').get();
    var idList = users.docs;
    for (int i = 0; i < idList.length; i++) {
      if (idList[i].data()['role'] == 'student') {
        var y = await FirebaseFirestore.instance.collection('users').doc(idList[i].documentID).collection(subject).doc(queryMonth).get();
        for (int j = 1; j <= 30; j++) {
          if (j<10) j1 = j.toString().padLeft(2, '0'); else j1 = j.toString();
          try {
            subCount+=y.data[j1]['count'];
          }
          catch(e){
            continue;
          }
        }
        attendance[idList[i].data()['Name']] = subCount;
        subCount = 0;
      }
    }
    //print(attendance);
    return attendance;
  }
}