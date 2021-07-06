import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myuseum/Utils/getAPI.dart';
import 'dart:convert';
String urlBase = "https://cop-4331-large-project.herokuapp.com";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: LoginRoute(),
    );
  }
}

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  @override
  String _email = "";
  String _password = "";
  String _loginStatus = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),

      body: Center(
          child: Column(
            children: [
              TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: 'Email',),
                  onChanged: (text) {
                    _email = text;
                  }
              ),
              TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: 'Password',),
                  obscureText: true,
                  onChanged: (text) {
                    _password = text;
                  }
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  _login(context);
                },
              ),
              Text(
                '$_loginStatus',
              ),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterRoute()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Forgot Password'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordRoute()),
                  );
                },
              ),
            ],
          )
      ),
    );
    return Container();
  }

  void _login(BuildContext context) {
    setState(() {
      _loginStatus = 'Logging in';
    });
    String output = "";
    String registerURL = urlBase + "/users/login";
    String content = '{"email": "' + _email + '","password": "' +
        _password + '"}';
    Register.sendRegister(registerURL, content).then((value) {
      output = value;
      if(output.compareTo('200') == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'Homepage')),
        );
      }
      else if(output.compareTo('400') == 0)
      {
        setState(() {
          _loginStatus = 'Wrong password or email';
        });
      }
      else
      {
        setState(() {
          _loginStatus = 'error: ' + output;
        });
      }
    });
  }
}

class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  @override

  String _email = "";
  String _firstName = "";
  String _lastName = "";
  String _password = "";
  String _output = "";

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: 'Email',),
                  onChanged: (text) {
                    _email = text;
                  }
              ),
              TextField(
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    _firstName = text;
                  }
              ),
              TextField(
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    _lastName = text;
                  }
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    _password = text;
                  }
              ),
              Text(
                  '$_output'
              ),
              ElevatedButton (
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        )
    );
    return Container();
  }

  void _register() {
    setState(() {
      _output = "Registering...";
    });
    String content = '{"email": "' + _email + '","firstName": "' +
        _firstName + '","lastName": "' + _lastName + '","password": "' +
        _password + '"}';
    String registerURL = urlBase + "/users/register";
    Register.sendRegister(registerURL, content).then((value) {
      setState(() {
        _output = value;
      });
    });
  }

}

class ForgotPasswordRoute extends StatefulWidget {
  @override
  _ForgotPasswordRouteState createState() => _ForgotPasswordRouteState();
}

class _ForgotPasswordRouteState extends State<ForgotPasswordRoute> {
  @override

  String _output = "";
  String _email = "";

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),

        body: Center(
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (text) {
                  _email = text;
                },
              ),
              ElevatedButton(
                onPressed: _forgotPassword,
                child:
                    Text('Submit'),
              ),
              Text('$_output'),
            ]
          )
        ),
    );
    return Container();
  }

  void _forgotPassword() {
    setState(() {
      _output = "Sending...";
    });
    String content = '{"email": "' + _email + '"';
    String registerURL = urlBase + "/users/forgotPassword";
    Register.sendRegister(registerURL, content).then((value) {
      if(value.compareTo("200") == 0) {
        setState(() {
          _output = 'Email sent';
        });
      }
      else if(value.compareTo("400") == 0) {
        setState(() {
          _output = 'Email required';
        });
      }
      else if(value.compareTo("404") == 0) {
        setState(() {
          _output = 'Email does not exist';
        });
      }
      else if(value.compareTo("503") == 0) {
        setState(() {
          _output = 'Email failed to send';
        });
      }
      else
      {
        setState(() {
          _output = 'Error ' + value;
        });
      }
    });
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _output = "";
  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _demoRegister() {
    setState(() {
      _output = "Registering...";
    });
    String content = '{"email": "' + _email + '","firstName": "' +
        _firstName + '","lastName": "' + _lastName + '","password": "' +
        _password + '"}';
    String registerURL = urlBase + "/users/register";
    Register.sendRegister(registerURL, content).then((value) {
      setState(() {
        _output = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have tapped the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
                textAlign: TextAlign.center,
                onChanged: (text) {
                  _email = text;
                }
            ),
            TextField(
                textAlign: TextAlign.center,
                onChanged: (text) {
                  _firstName = text;
                }
            ),
            TextField(
                textAlign: TextAlign.center,
                onChanged: (text) {
                  _lastName = text;
                }
            ),
            TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (text) {
                  _password = text;
                }
            ),
            Text(
                '$_output'
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _demoRegister,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
