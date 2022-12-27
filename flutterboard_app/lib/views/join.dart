import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:http/http.dart' as http;

class JoinUser extends StatefulWidget {
  const JoinUser({super.key});

  @override
  State<JoinUser> createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  late TextEditingController idCont;
  late TextEditingController pwCont;
  late TextEditingController pwCheckCont;
  late TextEditingController nameCont;
  late TextEditingController birthdayCont;
  late bool idcheck;
  late bool pwcheck;
  late bool correctid;
  late bool correctpw;
  late bool correctbday;

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
    correctid = false;
    correctpw = false;
    correctbday = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '회원가입',
          ),
        ),
        body: SingleChildScrollView(
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
                            onChanged: (value) {
                              idCheck(value);
                              if (Static.idReg.hasMatch(value.trim()) &&
                                  value.trim().length <= 13) {
                                setState(() {
                                  correctid = true;
                                });
                              } else {
                                setState(() {
                                  correctid = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: idCont.text.isNotEmpty
                                  ? correctid
                                      ? !idcheck
                                          ? '중복된 ID입니다'
                                          : '사용 가능한 ID입니다.'
                                      : '사용 불가능한 ID입니다.'
                                  : '알파벳 소문자와 숫자를 조합하여 13자 이내',
                              labelStyle: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton(
                    onPressed: correctbday&&nameCont.text.trim().isNotEmpty&&pwcheck&&idcheck&&correctid?
                    () {
                      userJoin().whenComplete(() {
                        FocusScope.of(context).unfocus();
                        _showDialog(context);
                      });
                    }:null,
                    child: const Text(
                      '회원가입',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Functions//

  //Desc: 회원가입
  //Date: 2022-12-26
  Future<bool> userJoin() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/join?userid=${idCont.text.trim()}&userpw=${pwCont.text.trim()}&username=${nameCont.text.trim()}&birthday=${birthdayCont.text.trim()}');
    http.get(url);

    return true;
  }

  //Desc: ID 중복체크
  //Date: 2022-12-26
  Future<bool> idCheck(String value) async {
    var url =
        Uri.parse('http://${Static.ipAddress}:8080/idcheck?userid=$value');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    if (result[0]['check'] == 1) {
      setState(() {
        idcheck = false;
      });
    } else {
      setState(() {
        idcheck = true;
      });
    }
    return true;
  }

  //Desc: 회원가입 성공 메시지 출력
  //Date: 2022-12-26
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '회원가입 완료',
          ),
          content: const Text(
            '회원가입이 완료되었습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
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
