import 'package:flutter/material.dart';
import 'package:password_manager/database/DatabaseHelper.dart';
import 'package:password_manager/view/HomeScreen.dart';
import 'package:password_manager/view/RegisterScreen.dart';

class LoginRegisterScreen extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    bool isLogin = await DatabaseHelper.instance.checkLogin(username, password);
    if (isLogin) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      //fail
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('登入失敗!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登入/註冊"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: "輸入帳號"
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: "輸入密碼"
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Text("登入"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()
                      )
                  );
                },
                child: Text("註冊"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
