import 'package:firebase_database/firebase_database.dart';

class Todo {
  DataSnapshot key;
  String subject = " ";
  bool completed;
  String userId = " ";

  Todo(String subject, String userId, bool completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value ["userId"],
    subject = snapshot.value ["subject"],
    completed = snapshot.value ["completed"];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}