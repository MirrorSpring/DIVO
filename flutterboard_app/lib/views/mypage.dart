import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:flutterboard_app/views/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late TextEditingController idCont;
  late TextEditingController pwCont;
  late TextEditingController pwCheckCont;
  late TextEditingController nameCont;
  late TextEditingController birthdayCont;
  late bool idcheck;
  late bool pwcheck;
  late List data;
  var userid;

  @override
  void initState() {
    super.initState();
    idCont = TextEditingController();
    pwCont = TextEditingController();
    pwCheckCont = TextEditingController();
    nameCont = TextEditingController();
    birthdayCont = TextEditingController();
    idcheck = true;
    pwcheck = false;
    data = [];
    userid = '';
    getUserInfo().whenComplete(() {
      idCont.text = data[0]['userid'];
      pwCont.text = data[0]['userpw'];
      nameCont.text = data[0]['username'];
      birthdayCont.text = data[0]['birthday'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'ID: ',
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: idCont,
                    readOnly: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '비밀번호: ',
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: pwCont,
                    obscureText: true,
                    onChanged: (value) {
                      if (pwCont.text.trim() == pwCheckCont.text.trim()) {
                        setState(() {
                          pwcheck = true;
                        });
                      } else {
                        setState(() {
                          pwcheck = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '비밀번호 확인: ',
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: pwCheckCont,
                    obscureText: true,
                    onChanged: (value) {
                      if (pwCont.text.trim() == pwCheckCont.text.trim()) {
                        setState(() {
                          pwcheck = true;
                        });
                      } else {
                        setState(() {
                          pwcheck = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: idCont.text.trim().isNotEmpty
                          ? pwcheck
                              ? '비밀번호가 일치합니다.'
                              : '비밀번호가 일치하지 않습니다.'
                          : '비밀번호를 다시 한 번 입력하세요',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '이름: ',
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: nameCont,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '생년월일: ',
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: birthdayCont,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateUser();
                  },
                  child: const Text(
                    '회원정보 수정',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteUser().whenComplete(() {
                      _showDeleteConfirm();
                    });
                  },
                  child: const Text(
                    '회원탈퇴',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Desc: 회원정보 출력
  //Date: 2022-12-26
  Future<bool> getUserInfo() async {
    final pref = await SharedPreferences.getInstance();
    userid = pref.getString('userid');
    data.clear();
    var url =
        Uri.parse('http://${Static.ipAddress}:8080/mypage?userid=$userid');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      data.addAll(result);
    });

    return true;
  }

  //Desc: 회원정보 수정
  //Date: 2022-12-26
  Future<bool> updateUser() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/updateuser?userid=$userid&username=${nameCont.text.trim()}&userpw=${pwCont.text.trim()}&birthday=${birthdayCont.text.trim()}');
    await http.get(url).whenComplete(() {
      _showUpdateConfirm();
    });
    return true;
  }

  //Desc: 회원정보 수정 확인
  //Date: 2022-12-26
  _showUpdateConfirm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '회원정보 수정',
          ),
          content: const Text(
            '회원정보가 수정되었습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
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

  //Desc: 회원탈퇴
  //Date: 2022-12-26
  Future<bool> deleteUser() async {
    var url =
        Uri.parse('http://${Static.ipAddress}:8080/deleteuser?userid=$userid');
    await http.get(url).whenComplete(() {
      _showUpdateConfirm();
    });
    return true;
  }

  //Desc: 회원탈퇴
  //Date: 2022-12-26
  _showDeleteConfirm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '회원탈퇴',
          ),
          content: const Text(
            '회원탈퇴가 완료되었습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Login();
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
}
