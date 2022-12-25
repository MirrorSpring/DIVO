import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:http/http.dart' as http;

class FindId extends StatefulWidget {
  const FindId({super.key});

  @override
  State<FindId> createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  late TextEditingController nameCont;
  late TextEditingController birthdayCont;
  late List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCont = TextEditingController();
    birthdayCont = TextEditingController();
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
                findId().whenComplete(() {
                  showId(context);
                });
              },
              child: const Text('ID 찾기'),
            ),
          ],
        ),
      ),
    );
  }

  //Functions//

  //Desc: ID 찾기
  //Date: 2022-12-25
  findId() async {
    data.clear();
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/findid?username=${nameCont.text.trim()}&birthday=${birthdayCont.text.trim()}');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      for (int i = 0; i < result.length; i++) {
        data.add(result[i]['userid']);
      }
    });
  }

  //Desc: ID 찾기 결과 출력
  //Date: 2022-12-25
  showId(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ID 찾기 결과',
          ),
          content: data.isNotEmpty
              ? Column(
                  children: [
                    const Text(
                      '회원님의 ID 목록입니다',
                    ),
                    Text(
                      data.join("\n"),
                    ),
                  ],
                )
              : const Text(
                  '조건에 맞는 ID가 없습니다.',
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text(
                '로그인 화면으로',
              ),
            ),
          ],
        );
      },
    );
  }
}
