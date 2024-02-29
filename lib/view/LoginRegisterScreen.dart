import 'package:flutter/material.dart';
import 'package:password_manager/view/RegisterScreen.dart';

class LoginRegisterScreen extends StatelessWidget {
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
                decoration: InputDecoration(
                    labelText: "輸入帳號"
                ),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "輸入密碼"
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {  },
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
