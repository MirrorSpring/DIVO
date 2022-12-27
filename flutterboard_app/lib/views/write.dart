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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        '제목:   ',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        width: 270,
                        child: TextField(
                          controller: titleCont,
                          decoration: const InputDecoration(
                              labelText: "제목을 입력하세요",
                            ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: const [
                      Text(
                        '내용',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 350,
                        height: 300,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 15,
                          maxLines: null,
                          controller: contentCont,
                          decoration: const InputDecoration(
                            hintText: "매너있는 게시글을 작성해 주세요",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: titleCont.text.trim().isNotEmpty &&
                                contentCont.text.trim().isNotEmpty
                            ? () {
                                write().whenComplete(
                                  () {
                                    _showDialog();
                                  },
                                );
                              }
                            : null,
                        child: const Text(
                          '글쓰기',
                        ),
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
