import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _passwords = [];

  List<Map<String, dynamic>> _filteredPasswords = [];

  TextEditingController _searchController = TextEditingController();

  void _loadPasswords() {
    _passwords = [
      {'id': 1, 'title': '網站A', 'username': 'userA', 'password': 'passwordA'},
      {'id': 2, 'title': '網站B', 'username': 'userB', 'password': 'passwordB'},
      {'id': 3, 'title': '網站C', 'username': 'userC', 'password': 'passwordC'},
    ];
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
    Map<String, dynamic> password =
    {'id': 0, 'title': '', 'username': '', 'password': ''};

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('新增密碼'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '網站名稱'
                  ),

                  onChanged: (value){
                    //todo 更改網站名稱
                    password['title'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: '使用者名稱'
                  ),

                  onChanged: (value){
                    password['username'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: '密碼'
                  ),

                  onChanged: (value){
                    password['password'] = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('取消')
              ),
              TextButton(onPressed: () {
                //todo 新增到陣列內
                password['id'] = _passwords.length;
                _addPassword(password);
                Navigator.of(context).pop();

              }, child: Text('保存')
              ),
            ],
          );
        }
    );
  }

  void _addPassword(Map<String, dynamic> password) {
    setState(() {
      _passwords.add(password);
      _filteredPasswords = _passwords;
    });
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
