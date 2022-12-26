import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BoardDetail extends StatefulWidget {
  final int boardid;
  const BoardDetail({super.key, required this.boardid});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  late List data;
  late bool updatemode;
  late bool buttonvisible;
  late TextEditingController titleCont;
  late TextEditingController contentCont;
  late bool editable = false;

  @override
  void initState() {
    super.initState();
    titleCont = TextEditingController();
    contentCont = TextEditingController();
    setState(() {
      updatemode = false;
      buttonvisible = false;
    });
    data = [];
    getBoardDetail().whenComplete(() {
      titleCont.text = data.isEmpty ? "" : data[0]['title'];
      contentCont.text = data.isEmpty ? "" : data[0]['content'];
      checkWriter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            data.isEmpty
                ? ""
                : '${data[0]['writername']}(@${data[0]['writerid']})님의 글',
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
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
                        readOnly: !updatemode,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '작성일자: ${data.isEmpty ? "" : data[0]['writedate']}',
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
                        readOnly: !updatemode,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: editable,
                  child: Row(
                    children: [
                      const Text(
                        '수정 모드',
                      ),
                      Switch(
                        value: updatemode,
                        onChanged: (value) {
                          setState(() {
                            updatemode = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: updatemode,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          updateBoard();
                        },
                        child: const Text(
                          '수정',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showDeleteConfirm(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          '삭제',
                        ),
                      ),
                    ],
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

  //Desc: 게시글 상세보기 출력
  //Date: 2022-12-25
  Future<bool> getBoardDetail() async {
    data.clear();
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/boarddetail?boardid=${widget.boardid}');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      data.addAll(result);
    });

    return true;
  }

  //Desc: 게시글 수정
  //Date: 2022-12-25
  Future<bool> updateBoard() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/updateboard?boardid=${widget.boardid}&title=${titleCont.text}&content=${contentCont.text}');
    await http.get(url).whenComplete(() {
      _showUpdateConfirm();
    });
    return true;
  }

  //Desc: 게시글 수정 확인
  //Date: 2022-12-25
  _showUpdateConfirm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '게시글 수정',
          ),
          content: const Text(
            '게시글이 수정되었습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                getBoardDetail();
                FocusScope.of(context).unfocus();
                setState(() {
                  updatemode = false;
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

  //Desc: 게시글 삭제
  //Date: 2022-12-25
  Future<bool> deleteBoard() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/deleteboard?boardid=${widget.boardid}');
    await http.get(url);
    return true;
  }

  //Desc: 게시글 삭제 확인
  //Date: 2022-12-25
  _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '게시글 삭제',
          ),
          content: const Text(
            '게시글을 삭제하시겠습니까?.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
              child: const Text(
                '아니오',
              ),
            ),
            TextButton(
              onPressed: () {
                deleteBoard().whenComplete(() {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                });
              },
              child: const Text(
                '예',
              ),
            ),
          ],
        );
      },
    );
  }

  //Desc: 본인이 쓴 글인지 확인
  //Date: 2022-12-26
  checkWriter() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getString('userid') == data[0]['writerid']) {
      setState(() {
        editable = true;
      });
    } else {
      setState(() {
        editable = false;
      });
    }
    print(editable);
  }
}
