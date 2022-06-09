import 'package:firebase_database/firebase_database.dart';

class Todo {
  DataSnapshot key;
  String subject = " ";
  bool completed;
  String userId = " ";

  Todo({required DataSnapshot this.key,String subject="", String userId="", required bool this.completed});

  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot,
    userId = (snapshot.value as Map)["userId"],
    subject = (snapshot.value as Map)["subject"],
    completed = (snapshot.value as Map)["completed"];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}