import 'package:flutter/material.dart';

import 'LoginRegisterScreen.dart';
class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "密碼管理服務",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),

              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginRegisterScreen()
                      )
                  );
                },
                child: Text('開始使用'),
              ),
            ]
        ),
      ),
    );
  }

}