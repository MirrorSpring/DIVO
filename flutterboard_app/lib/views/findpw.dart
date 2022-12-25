import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:http/http.dart' as http;

class FindPw extends StatefulWidget {
  const FindPw({super.key});

  @override
  State<FindPw> createState() => _FindPwState();
}

class _FindPwState extends State<FindPw> {
  late TextEditingController idCont;
  late TextEditingController nameCont;
  late TextEditingController birthdayCont;
  late TextEditingController pwCont;
  late TextEditingController pwCheckCont;
  late List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idCont = TextEditingController();
    nameCont = TextEditingController();
    birthdayCont = TextEditingController();
    pwCont = TextEditingController();
    pwCheckCont = TextEditingController();
    data = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'findid',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: idCont,
              decoration: const InputDecoration(
                labelText: "ID",
              ),
            ),
            TextField(
              controller: nameCont,
              decoration: const InputDecoration(
                labelText: "이름",
              ),
            ),
            TextField(
              controller: birthdayCont,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "생년월일(ex: 19900101)",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                findPw().whenComplete(() {
                  resetPwView();
                });
              },
              child: const Text('비밀번호 찾기'),
            ),
          ],
        ),
      ),
    );
  }

  //Desc: 비밀번호 찾기
  //Date: 2022-12-26
  findPw() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/findpw?username=${nameCont.text.trim()}&birthday=${birthdayCont.text.trim()}&userid=${idCont.text.trim()}');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      data.addAll(result);
    });
  }

  //Desc: 비밀번호 재설정
  //Date: 2022-12-26
  resetPw() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/resetpw?userpw=${pwCont.text.trim()}&userid=${idCont.text.trim()}');
    await http.get(url);
  }

  //Desc: 비밀번호 재설정 화면
  //Date: 2022-12-26
  resetPwView() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: AlertDialog(
            title: Text(
              data.isNotEmpty ? '비밀번호 재설정' : '비밀번호 찾기 결과',
            ),
            content: data.isNotEmpty
                ? Column(
                    children: [
                      TextField(
                        controller: pwCont,
                        obscureText: true,
                      ),
                      TextField(
                        controller: pwCheckCont,
                        obscureText: true,
                      ),
                    ],
                  )
                : const Text(
                    '조건에 맞는 결과가 없습니다.',
                  ),
            actions: [
              data.isEmpty
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '로그인 화면으로',
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        resetPw();
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                      },
                      child: const Text('비밀번호 재설정'),
                    ),
            ],
          ),
        );
      },
    );
  }
}
