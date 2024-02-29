import 'package:flutter/material.dart';

import '../database/DatabaseHelper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password == confirmPassword) {
      bool usernameExists = await DatabaseHelper.instance.checkUsernameExists(username);
      if (usernameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('使用者名稱 $username 已存在'),
          ),
        );
        return;
      }

      // 實際應用中，您可能會將帳號密碼存儲在安全的地方，如數據庫或加密文件中
      print('使用者名稱: $username, 密碼: $password 註冊成功');
      await DatabaseHelper.instance.insertUser({
        'username': username,
        'password': password,
      });

      bool usernameInsertSuccess = await DatabaseHelper.instance.checkUsernameExists(username);
      if (usernameInsertSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$username 註冊成功!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$username 註冊失敗!'),
          ),
        );
      }

    } else {
      // 密碼不一致的處理邏輯
      print('密碼不一致');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('密碼不一致'),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: '使用者名稱',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '密碼',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: '確認密碼',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('註冊'),
            ),
          ],
        ),
      ),
    );
  }
}
