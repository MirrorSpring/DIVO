import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:http/http.dart' as http;

class BoardDetail extends StatefulWidget {
  final int boardid;
  const BoardDetail({super.key, required this.boardid});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  late List data;
  late bool updatemode;
  late TextEditingController titleCont;
  late TextEditingController contentCont;

  @override
  void initState() {
    super.initState();
    titleCont = TextEditingController();
    contentCont = TextEditingController();
    data = [];
    getBoardDetail().whenComplete(() {
      titleCont.text=data.isEmpty?"":data[0]['title'];
      contentCont.text=data.isEmpty?"":data[0]['content'];
    });
    setState(() {
      updatemode = true;
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
            data.isEmpty ? "" : '${data[0]['writername']}님의 글',
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
                      readOnly: updatemode,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '작성일자: ${data.isEmpty?"":data[0]['writedate']}',
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
                      readOnly: updatemode,
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
}
