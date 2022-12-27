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
  late List commentdata;
  late bool updatemode;
  late bool buttonvisible;
  late TextEditingController titleCont;
  late TextEditingController contentCont;
  late TextEditingController commentupdateCont;
  late TextEditingController commentCont;
  late bool editable = false;
  late String? userid;
  late bool commentinserted;

  @override
  void initState() {
    super.initState();
    titleCont = TextEditingController();
    contentCont = TextEditingController();
    commentupdateCont = TextEditingController();
    commentCont = TextEditingController();
    setState(() {
      updatemode = false;
      buttonvisible = false;
    });
    data = [];
    commentdata = [];
    getComment();
    getBoardDetail().whenComplete(() {
      titleCont.text = data.isEmpty ? "" : data[0]['title'];
      contentCont.text = data.isEmpty ? "" : data[0]['content'];
      checkWriter();
    });
    userid = '';
    getUser();
    commentinserted = false;
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
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        '제목: ',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        width: 270,
                        child: TextField(
                          controller: titleCont,
                          readOnly: !updatemode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        '작성일자: ${data.isEmpty ? "" : data[0]['writedate']}',
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Text(
                        '내용',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 350,
                        height: 300,
                        child: TextField(
                          readOnly: !updatemode,
                          keyboardType: TextInputType.multiline,
                          minLines: 15,
                          maxLines: null,
                          controller: contentCont,
                          decoration: const InputDecoration(
                            hintText: "매너있는 게시글을 작성해 주세요",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: editable && !updatemode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              updatemode = true;
                            });
                          },
                          child: const Text(
                            '수정',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: updatemode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                updatemode = false;
                              });
                            },
                            child: const Text(
                              '취소',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              updateBoard();
                            },
                            child: const Text(
                              '수정',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
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
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      children: const [
                        Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: commentdata.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: commentdata.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${commentdata[index]['username']}(@${commentdata[index]['c_userid']})',
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              commentdata[index]
                                                  ['commentcontent'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            commentdata[index]
                                                ['commentwritedate'],
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: commentdata[index]
                                                ['c_userid'] ==
                                            userid,
                                        child: Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                _showCommentUpdate(
                                                    context, index);
                                              },
                                              child: const Text(
                                                '수정',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _showCommentDeleteConfirm(
                                                    context, index);
                                              },
                                              child: const Text(
                                                '삭제',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Text(
                            '댓글이 없습니다.',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Text(
                                '댓글 쓰기',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 290,
                                    child: TextField(
                                        controller: commentCont,
                                        textInputAction: TextInputAction.go,
                                        onChanged: (value) {
                                          if (commentCont.text.trim().isEmpty) {
                                            setState(() {
                                              commentinserted = false;
                                            });
                                          } else {
                                            setState(() {
                                              commentinserted = true;
                                            });
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "건전한 댓글을 입력해 주세요."),
                                        onSubmitted: (value) {
                                          if (value.trim().isNotEmpty) {
                                            writeComment().whenComplete(() {
                                              Navigator.of(context).pop();
                                              _showWriteResult();
                                              commentCont.text = "";
                                            });
                                          }
                                        }),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (commentCont.text.isNotEmpty) {
                                          writeComment().whenComplete(() {
                                            Navigator.of(context).pop();
                                            _showWriteResult();
                                            commentCont.text = "";
                                          });
                                        }
                                      },
                                      child: const Text(
                                        '댓글 쓰기',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(
            Icons.comment,
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

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          '게시글 삭제',
                        ),
                        content: const Text(
                          '게시글이 삭제되었습니다.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              getBoardDetail();
                              FocusScope.of(context).unfocus();
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
  }

  //Desc: 댓글 출력
  //Date: 2022-12-25
  Future<bool> getComment() async {
    commentdata.clear();
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/showcomment?boardid=${widget.boardid}');
    var response = await http.get(url);
    var dataConvertedJson = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJson['results'];

    setState(() {
      commentdata.addAll(result);
    });
    return true;
  }

  Future<bool> getUser() async {
    final pref = await SharedPreferences.getInstance();
    userid = pref.getString('userid');

    return true;
  }

  //Desc: 댓글 수정 화면 출력
  //Date: 2022-12-26
  _showCommentUpdate(BuildContext context, int index) {
    commentupdateCont.text = commentdata[index]['commentcontent'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '댓글 수정',
          ),
          content: TextField(
            controller: commentupdateCont,
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
              ),
            ),
            TextButton(
              onPressed: () {
                updateComment(index).whenComplete(() {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  setState(() {
                    getComment();
                  });
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          '댓글 수정',
                        ),
                        content: const Text(
                          '댓글이 수정되었습니다.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              getBoardDetail();
                              getComment();
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
                });
              },
              child: const Text(
                '수정',
              ),
            ),
          ],
        );
      },
    );
  }

  //Desc: 댓글 수정
  //Date: 2022-12-26
  Future<bool> updateComment(int index) async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/updatecomment?commentid=${commentdata[index]['commentid']}&commentcontent=${commentupdateCont.text.trim()}');
    await http.get(url);
    return true;
  }

  //Desc: 댓글 삭제 확인창 출력
  //Date: 2022-12-26
  _showCommentDeleteConfirm(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '댓글 삭제',
          ),
          content: const Text(
            '댓글을 삭제하시겠습니까?',
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
                deleteComment(index).whenComplete(() {
                  Navigator.of(context).pop();
                  setState(() {
                    getComment();
                  });
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          '댓글 삭제',
                        ),
                        content: const Text(
                          '댓글이 삭제되었습니다.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              getBoardDetail();
                              getComment();
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
                });
              },
              child: const Text(
                '삭제',
              ),
            ),
          ],
        );
      },
    );
  }

  //Desc: 댓글 삭제
  //Date: 2022-12-26
  Future<bool> deleteComment(int index) async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/deletecomment?commentid=${commentdata[index]['commentid']}');
    await http.get(url);
    return true;
  }

  //Desc: 댓글 쓰기
  //Date: 2022-12-27
  Future<bool> writeComment() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/comment?boardid=${widget.boardid}&commentcontent=${commentCont.text.trim()}&userid=$userid');
    await http.get(url);
    return true;
  }

  //Desc: 댓글 쓰기 결과 확인
  //Date: 2022-12-27
  _showWriteResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '댓글 작성',
          ),
          content: const Text(
            '댓글이 작성되었습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                getBoardDetail();
                getComment();
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
}
