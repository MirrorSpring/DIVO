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
  late bool correctbday;
  late bool correctpw;
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
    correctbday = true;
    correctpw = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 35,
                        ),
                        SizedBox(
                          height: 70,
                          child: Text(
                            'ID:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Text(
                            '비밀번호:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Text(
                            '비밀번호 확인:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Text(
                            '이름:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Text(
                            '생년월일:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //---------------------------------------
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: idCont,
                            readOnly: true,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: pwCont,
                            decoration: InputDecoration(
                              labelText: pwCont.text.trim().isNotEmpty
                                  ? correctpw
                                      ? '사용 가능한 비밀번호입니다.'
                                      : '사용 불가능한 비밀번호입니다.'
                                  : '알파벳 소문자와 숫자를 조합하여 15자 이내',
                              labelStyle: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              if (value.trim() == pwCheckCont.text.trim()) {
                                setState(() {
                                  pwcheck = true;
                                });
                              } else {
                                setState(() {
                                  pwcheck = false;
                                });
                              }
                              if (Static.idReg.hasMatch(value.trim()) &&
                                  value.length < 15) {
                                setState(() {
                                  correctpw = true;
                                });
                              } else {
                                setState(() {
                                  correctpw = false;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: pwCheckCont,
                            obscureText: true,
                            onChanged: (value) {
                              if (pwCont.text.trim() ==
                                  pwCheckCont.text.trim()) {
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
                              labelText: pwCont.text.trim().isNotEmpty
                                  ? pwcheck
                                      ? '비밀번호가 일치합니다.'
                                      : '비밀번호가 일치하지 않습니다.'
                                  : '비밀번호를 다시 한 번 입력하세요',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: nameCont,
                            decoration:
                                const InputDecoration(labelText: '이름을 입력하세요'),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: birthdayCont,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (Static.birthdayReg.hasMatch(value.trim())) {
                                setState(() {
                                  correctbday = true;
                                });
                              } else {
                                setState(() {
                                  correctbday = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: birthdayCont.text.trim().isNotEmpty
                                  ? correctbday
                                      ? ''
                                      : '생년월일을 정확히 입력해 주세요.'
                                  : '숫자 8자리(ex: 19000101)',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: ElevatedButton(
                        onPressed: correctbday &&
                                nameCont.text.trim().isNotEmpty &&
                                pwcheck
                            ? () {
                                updateUser().whenComplete(() {
                                  FocusScope.of(context).unfocus();
                                  _showUpdateConfirm();
                                });
                              }
                            : null,
                        child: const Text(
                          '회원정보 수정',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          _showDeleteConfirm();
                        },
                        child: const Text(
                          '회원탈퇴',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  //Desc: 회원탈퇴 확인
  //Date: 2022-12-26
  _showDeleteConfirm() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '회원탈퇴',
          ),
          content: const Text(
            '탈퇴하시겠습니까?',
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
                deleteUser().whenComplete(() {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  _showDeleteResult();
                });
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

  //Desc: 회원탈퇴 결과 출력
  //Date: 2022-12-26
  _showDeleteResult() {
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
