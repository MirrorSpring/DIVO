import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Write extends StatefulWidget {
  const Write({super.key});

  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  late TextEditingController titleCont;
  late TextEditingController contentCont;

  @override
  void initState() {
    super.initState();
    titleCont = TextEditingController();
    contentCont = TextEditingController();
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
            '글쓰기',
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '제목: ',
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: titleCont,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    '내용',
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CupertinoTextField(
                      controller: contentCont,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      write().whenComplete(
                        () {
                          _showDialog();
                        },
                      );
                    },
                    child: const Text(
                      '글쓰기',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Functions//

  //Desc: 게시글 쓰기
  //Date: 2022-12-25
  Future<bool> write() async {
    final pref = await SharedPreferences.getInstance();
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/write?writerid=${pref.getString('userid')}&title=${titleCont.text}&content=${contentCont.text}');
    http.get(url);
    return true;
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '글쓰기 완료',
            ),
            content: const Text(
              '글쓰기를 완료했습니다.',
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
        });
  }
}
