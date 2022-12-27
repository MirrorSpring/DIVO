import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:flutterboard_app/views/detail.dart';
import 'package:flutterboard_app/views/login.dart';
import 'package:flutterboard_app/views/mypage.dart';
import 'package:flutterboard_app/views/write.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  late RefreshController refreshCont;
  late int limit;

  @override
  void initState() {
    super.initState();
    data = [];
    limit = 1;
    getJsonData();
    userid = '';
    username = '';
    getUserinfo();
    refreshCont = RefreshController(initialRefresh: false);
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
                limit = 1;
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
              title: const Text('회원정보 수정'),
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
                  limit = 1;
                  getJsonData();
                });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.lock,
                color: Colors.blue,
              ),
              title: const Text('로그아웃'),
              onTap: () {
                logout().whenComplete(() {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await _confirmQuit(context);
        },
        child: Center(
          child: SmartRefresher(
            controller: refreshCont,
            enablePullDown: true,
            enablePullUp: true,
            onLoading: () async {
              await Future.delayed(const Duration(milliseconds: 1000));
              limit += 1;
              getJsonData().whenComplete(() {
                refreshCont.loadComplete();
              });
            },
            onRefresh: () async {
              limit = 1;
              await Future.delayed(const Duration(milliseconds: 1000));
              getJsonData().whenComplete(() {
                refreshCont.refreshCompleted();
              });
            },
            header: CustomHeader(
              builder: (context, mode) {
                Widget body;
                if (mode == RefreshStatus.idle) {
                  body = const Text('위로 올려 새로고침');
                } else if (mode == RefreshStatus.refreshing) {
                  body = const CircularProgressIndicator();
                } else {
                  body = const Text('새로고침 완료');
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 70,
                        ),
                      ),
                      Text(
                        '글이 없습니다.',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: data.length,
                    //itemExtent: 5,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BoardDetail(
                                    boardid: data[index]['boardid']);
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
                                          SizedBox(
                                            width: 220,
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text: data[index]['title'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${data[index]['writername']}(@${data[index]['writerid']})',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  text:
                                                      '${data[index]['content']}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                maxLines: 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          (data[index]['updatedate'] == null)
                                              ? '     ${data[index]['writedate']}'
                                              : '     ${data[index]['updatedate']}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200),
                                        ),
                                        Text(
                                            (data[index]['updatedate'] == null)
                                                ? ''
                                                : '  (수정됨)',
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  //Functions//

  //Desc: 메인화면 출력
  //Date: 2022-12-25
  Future<bool> getJsonData() async {
    data.clear();
    var url = Uri.parse('http://${Static.ipAddress}:8080/main?limit=$limit');
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

  //Desc: 로그아웃
  //Date: 2022-12-26
  Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    return true;
  }

  //Desc: 앱 종료 확인
  //Date: 2022-12-26
  _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '앱 종료',
          ),
          content: const Text(
            '앱을 종료하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
              ),
            ),
            TextButton(
              onPressed: () {
                Static.disposeSharedPreferences();
                SystemNavigator.pop();
              },
              child: const Text(
                '확인',
              ),
            ),
          ],
        );
      },
    );
  }
}
