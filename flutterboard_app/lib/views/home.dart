import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:flutterboard_app/views/detail.dart';
import 'package:flutterboard_app/views/mypage.dart';
import 'package:flutterboard_app/views/write.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List data;
  late var userid;
  late var username;

  @override
  void initState() {
    super.initState();
    data = [];
    getJsonData();
    userid = '';
    username = '';
    getUserinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Write();
                  },
                ),
              ).then((value) {
                getJsonData();
                getUserinfo();
              });
            },
            icon: const Icon(
              Icons.create,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                username,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              accountEmail: Text(
                '@$userid',
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.blue,
              ),
              title: const Text('마이페이지'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MyPage();
                  },
                ),
              ).then((value) {
                getJsonData();
              });
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: data.isEmpty
            ? const Text(
                '데이터가 없습니다',
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BoardDetail(boardid: data[index]['boardid']);
                          },
                        ),
                      ).then((value) {
                        getJsonData();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Container(
                          color: Colors.blue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '제목: ${data[index]['title']}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        (data[index]['updatedate'] ==
                                                data[index]['writedate'])
                                            ? ''
                                            : '  (수정됨)',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '작성자: ${data[index]['writername']}(@${data[index]['writerid']})',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '작성일자: ${data[index]['writedate']}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              ),
      ),
    );
  }

  //Functions//

  //Desc: 메인화면 출력
  //Date: 2022-12-25
  Future<bool> getJsonData() async {
    data.clear();
    var url = Uri.parse('http://${Static.ipAddress}:8080/main');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      data.addAll(result);
    });

    return true;
  }

  //Desc: Userid, username 가져오기
  //Date: 2022-12-26
  Future<bool> getUserinfo() async {
    final pref = await SharedPreferences.getInstance();
    userid = pref.getString('userid');
    username = pref.getString('username');
    return true;
  }
}
