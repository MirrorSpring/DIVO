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

  @override
  void initState() {
    super.initState();
    idCont = TextEditingController();
    pwCont = TextEditingController();
    pwCheckCont = TextEditingController();
    nameCont = TextEditingController();
    birthdayCont = TextEditingController();
    idcheck = true;
    pwcheck=false;
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
                      onChanged: (value) {
                        idCheck();
                      },
                      decoration: InputDecoration(
                        labelText: idCont.text.trim().isNotEmpty
                            ? !idcheck
                                ? '중복된 ID입니다'
                                : '사용 가능한 ID입니다.'
                            : 'ID를 입력하세요',
                      ),
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
                        if(pwCont.text.trim()==pwCheckCont.text.trim()){
                          setState(() {
                            pwcheck=true;
                          });
                        } else{
                          setState(() {
                            pwcheck=false;
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
                        if(pwCont.text.trim()==pwCheckCont.text.trim()){
                          setState(() {
                            pwcheck=true;
                          });
                        } else{
                          setState(() {
                            pwcheck=false;
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
              ElevatedButton(
                onPressed: () {
                  userJoin().whenComplete(() {
                    FocusScope.of(context).unfocus();
                    _showDialog(context);
                  });
                },
                child: const Text(
                  '회원가입',
                ),
              ),
            ],
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
  Future<bool> idCheck() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/idcheck?userid=${idCont.text.trim()}');
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
  _showDialog(BuildContext context){
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
