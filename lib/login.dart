import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myuseum/Utils/getAPI.dart';
import 'package:myuseum/main.dart';
import 'package:myuseum/Utils/userInfo.dart';
import 'package:myuseum/register.dart';
import 'package:myuseum/forgot_password.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  String _email = "";
  String _password = "";
  String _loginStatus = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (text) {
                    _email = text;
                  }),
              TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (text) {
                    _password = text;
                  }),
              Text(
                '$_loginStatus',
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Login'),
                  onPressed: () {
                    _login(context);
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Register'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterRoute()),
                    );
                  },
                ),
              ),
              TextButton(
                child: Text('Forgot Password'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordRoute()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    //return Container();
  }

  void _login(BuildContext context) {
    setState(() {
      _loginStatus = 'Logging in';
    });
    String output = "";
    String registerURL = urlBase + "/users/login";
    String content =
        '{"email": "' + _email + '","password": "' + _password + '"}';
    Register.postRegisterGetStatusCode(registerURL, content).then((value) {
      output = value;
      if (output.compareTo('200') == 0) {
        Register.postRegisterGetBody(registerURL, content).then((value) {
          parseLogin(value);
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(title: 'Homepage')),
        );
      } else if (output.compareTo('400') == 0) {
        setState(() {
          _loginStatus = 'Wrong password or email';
        });
      } else {
        setState(() {
          _loginStatus = 'error: ' + output;
        });
      }
    });
  }

  void parseLogin(String responseBody) {
    Login.fromJson(jsonDecode(responseBody));
  }
}

class Login {
  Login(String newAccessToken, String newId, String newEmail) {
    setAccessToken(newAccessToken);
    setId(newId);
    setEmail(newEmail);
  }

  Login.fromJson(Map<String, dynamic> json) {
    Login(json['accessToken'] as String, json['id'] as String,
        json['email'] as String);
  }
}
