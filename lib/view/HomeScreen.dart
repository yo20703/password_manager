import 'dart:math';

import 'package:flutter/material.dart';
import 'package:password_manager/database/DatabaseHelper.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int userId;
  HomeScreen({required this.username, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState(username: username, userId: userId);
}

class _HomeScreenState extends State<HomeScreen> {
  final String username;
  final int userId;

  _HomeScreenState({required this.username, required this.userId});

  List<Map<String, dynamic>> _passwords = [];

  List<Map<String, dynamic>> _filteredPasswords = [];

  TextEditingController _searchController = TextEditingController();

  void _loadPasswords() async {
    List<Map<String, dynamic>> passwords = await DatabaseHelper.instance.getPasswordsByUserId(userId);
    _passwords = passwords;
    _searchPassword(_searchController.text);
  }

  void _searchPassword(String keyword) {
    print('_searchPassword: $keyword');
    setState(() {
      _filteredPasswords = _passwords
          .where((password) =>
              password['title'].toLowerCase().contains(keyword.toLowerCase()) ||
              password['username']
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _addPassword(Map<String, dynamic> password) async {
    int insertPassword = await DatabaseHelper.instance.insertPassword(password);
    _passwords = await DatabaseHelper.instance.getPasswordsByUserId(userId);
    _filteredPasswords = _passwords;
    _searchPassword(_searchController.text);
  }

  void _showEditPasswordDialog(Map<String, dynamic> password) {
    TextEditingController _passwordController = TextEditingController(text: password['password']);
    bool showPassword = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('密碼'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('網站名稱: ${password['title']}'),
                      Text('使用者名稱: ${password['username']}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('密碼:'),
                          Switch(
                            value: showPassword,
                            onChanged: (value) {
                              setState(() {
                                showPassword = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (showPassword)
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: '密碼',
                          ),
                          onChanged: (value) {
                            password['password'] = value;
                          },
                        ),
                      if (!showPassword)
                        Text('********'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, child: Text('取消')
                    ),
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, child: Text('儲存')
                    ),
                  ],
                );
              },
          );
        }
    );
  }

  void _showAddPasswordDialog() {
    Map<String, dynamic> password = {
      'user_id': userId,
      'title': '',
      'username': '',
      'password': '',
      'description': '',
    };

    TextEditingController _passwordController = TextEditingController();

    int passwordLength = 12;
    bool includeUppercase = true;
    bool includeLowercase = true;
    bool includeNumbers = true;
    bool includeSymbols = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('新增密碼'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '網站名稱',
                      ),
                      onChanged: (value) {
                        password['title'] = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '使用者名稱',
                      ),
                      onChanged: (value) {
                        password['username'] = value;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '密碼',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {
                              password['password'] = _generateRandomPassword(
                                passwordLength,
                                includeUppercase,
                                includeLowercase,
                                includeNumbers,
                                includeSymbols,
                              );
                              _passwordController.text = password['password'];
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        password['password'] = value;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('密碼長度'),
                        DropdownButton<int>(
                          value: passwordLength,
                          onChanged: (int? value) {
                            setState(() {
                              passwordLength = value!;
                            });
                          },
                          items: List.generate(21, (index) => index + 5)
                              .map((length) {
                            return DropdownMenuItem<int>(
                              value: length,
                              child: Text(length.toString()),
                            );
                          })
                              .toList(),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: Text('包含英文大寫'),
                      value: includeUppercase,
                      onChanged: (value) {
                        setState(() {
                          includeUppercase = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('包含英文小寫'),
                      value: includeLowercase,
                      onChanged: (value) {
                        setState(() {
                          includeLowercase = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('包含數字'),
                      value: includeNumbers,
                      onChanged: (value) {
                        setState(() {
                          includeNumbers = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('包含符號'),
                      value: includeSymbols,
                      onChanged: (value) {
                        setState(() {
                          includeSymbols = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    _addPassword(password);
                    Navigator.of(context).pop();
                  },
                  child: Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _generateRandomPassword(
      int passwordLength,
      bool includeUppercase,
      bool includeLowercase,
      bool includeNumber,
      bool includeSymbols
      ) {
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const numberChars = '0123456789';
    const symbolChars = '!@#\$%^&*()_+=<>?';

    String chars = '';
    if (includeUppercase) chars += uppercaseChars;
    if (includeLowercase) chars += lowercaseChars;
    if (includeNumber) chars += numberChars;
    if (includeSymbols) chars += symbolChars;

    final random = Random.secure();

    return List.generate(passwordLength, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  void initState() {
    super.initState();
    _loadPasswords();
    _filteredPasswords = _passwords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('密碼管理服務'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _searchPassword,
            decoration: InputDecoration(
              labelText: '搜尋',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _filteredPasswords.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredPasswords[index]['title']),
                      subtitle: Text(_filteredPasswords[index]['username']),
                      onTap: () {
                        _showEditPasswordDialog(_filteredPasswords[index]);
                      },
                    );
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPasswordDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
