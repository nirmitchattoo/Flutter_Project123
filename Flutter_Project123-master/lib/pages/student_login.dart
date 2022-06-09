import 'package:flutter/material.dart';
import 'package:student_help/services/authentication.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class StudentLogin extends StatefulWidget {
  StudentLogin({required this.auth,required this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final _formKey = GlobalKey<FormState>();

  String _email = " ";
  String _password = " ";
  String _errorMessage = " ";

  bool _isLoading = true;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form != null && !form.validate()) {

      return false;
    }
    form?.save();
    return true;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        var result =
            await FirebaseFirestore.instance.collection('users').doc(userId).get();
        print(result['role']);
        if (result['role'] == "Teacher")
          throw Exception("Only Students can login");
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
      
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
          _formKey.currentState!.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState!.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Login Here',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            _errorMessage,
            style: const TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 120.0,
          child: Image.asset('assets/Student.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value!.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: const Text('Login',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
