import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:flutterboard_app/views/findid.dart';
import 'package:flutterboard_app/views/findpw.dart';
import 'package:flutterboard_app/views/home.dart';
import 'package:flutterboard_app/views/join.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  late TextEditingController idCont;
  late TextEditingController pwCont;
  late List data;
  late AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();
    idCont = TextEditingController();
    pwCont = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    data = [];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached: //앱이 메모리에서 없어진 상태
        break;
      case AppLifecycleState.resumed: //다시 돌아왔을 때
        break;
      case AppLifecycleState.inactive: //앱 비활성화(최소화 버튼 누르기), 꺼짐

        break;
      case AppLifecycleState.paused:
        Static.disposeSharedPreferences();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _confirmQuit(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                '로그인',
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.account_circle_rounded,
                    size: 200,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: idCont,
                      decoration: const InputDecoration(labelText: "ID"),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: pwCont,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _loginTry(idCont.text.trim(), pwCont.text.trim(), context)
                          .whenComplete(() {
                        if (data[0]['check'] != null) {
                          _saveId();
                          _showSuccess(context);
                        } else {
                          _showFail(context);
                        }
                      });
                    },
                    child: const Text(
                      '로그인',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('회원정보를 잊으셨나요?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const FindId();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'ID 찾기',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const FindPw();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '처음 오셨나요?',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const JoinUser();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Functions

  //Desc: 로그인 버튼을 눌렀을 때
  //Date: 2022-12-23
  Future<bool> _loginTry(String id, String pw, BuildContext context) async {
    data.clear();
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/login?userid=${idCont.text.trim()}&userpw=${pwCont.text.trim()}');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      data.addAll(result);
    });
    return true;
  }

  //Desc: 로그인 성공 시 뜨는 다이얼로그
  //Date: 2022-12-23
  _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '환영합니다!',
          ),
          content: Text(
            '안녕하세요, ${idCont.text.trim()}님!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Home();
                    },
                  ),
                );
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

  //Desc: 로그인 실패 시 뜨는 다이얼로그
  //Date: 2022-12-23
  _showFail(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '로그인 실패',
          ),
          content: const Text(
            'ID 또는 비밀번호가 일치하지 않습니다',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  //Desc: ID를 Shared Preferences에 저장
  //Date: 2022-12-23
  _saveId() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('userid', idCont.text);
    pref.setString('username', data[0]['check']);
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
                Navigator.of(context).pop();
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
