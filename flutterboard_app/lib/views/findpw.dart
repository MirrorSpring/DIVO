import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterboard_app/static/static.dart';
import 'package:flutterboard_app/views/login.dart';
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
  late bool correctbday;
  late bool correctpw;
  late bool pwcheck;

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
    correctbday = false;
    correctpw = false;
    pwcheck = false;
    pwCont.addListener(
      () {
        if (pwCont.text.trim() == pwCheckCont.text.trim()) {
          setState(() {
            pwcheck = true;
          });
        } else {
          setState(() {
            pwcheck = false;
          });
        }
        if (Static.idReg.hasMatch(pwCont.text.trim().trim()) &&
            pwCont.text.trim().length < 15) {
          setState(() {
            correctpw = true;
          });
        } else {
          setState(() {
            correctpw = false;
          });
        }
      },
    );
    pwCheckCont.addListener(
      () {
        if (pwCont.text.trim() == pwCheckCont.text.trim()) {
          setState(() {
            pwcheck = true;
          });
        } else {
          setState(() {
            pwcheck = false;
          });
        }
      },
    );
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
            '???????????? ??????',
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
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
                            '??????:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Text(
                            '????????????:   ',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: TextField(
                                controller: idCont,
                                decoration: const InputDecoration(
                                  labelText: "ID",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: TextField(
                                controller: nameCont,
                                decoration: const InputDecoration(
                                  labelText: "??????",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: TextField(
                                controller: birthdayCont,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: birthdayCont.text.trim().isNotEmpty
                                      ? correctbday
                                          ? ''
                                          : '??????????????? ????????? ????????? ?????????.'
                                      : '?????? 8??????(ex: 19000101)',
                                ),
                                onChanged: (value) {
                                  if (Static.birthdayReg
                                      .hasMatch(value.trim())) {
                                    setState(() {
                                      correctbday = true;
                                    });
                                  } else {
                                    setState(() {
                                      correctbday = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                ElevatedButton(
                  onPressed: idCont.text.trim().isNotEmpty &&
                          nameCont.text.trim().isNotEmpty &&
                          correctbday
                      ? () {
                          findPw().whenComplete(() {
                            resetPwView(context);
                          });
                        }
                      : null,
                  child: const Text('???????????? ??????'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Desc: ???????????? ??????
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

  //Desc: ???????????? ?????????
  //Date: 2022-12-26
  resetPw() async {
    var url = Uri.parse(
        'http://${Static.ipAddress}:8080/resetpw?userpw=${pwCont.text.trim()}&userid=${idCont.text.trim()}');
    await http.get(url);
  }

  //Desc: ???????????? ????????? ??????
  //Date: 2022-12-26
  resetPwView(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            height: 200,
            child: AlertDialog(
              title: Text(
                data.isNotEmpty ? '???????????? ?????????' : '???????????? ?????? ??????',
              ),
              content: data.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: pwCont,
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
                          decoration: InputDecoration(
                            labelText: pwCont.text.trim().isNotEmpty
                                ? correctpw
                                    ? '?????? ????????? ?????????????????????.'
                                    : '?????? ???????????? ?????????????????????.'
                                : '????????? ???????????? ????????? ???????????? 15??? ??????',
                            labelStyle: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextField(
                          controller: pwCheckCont,
                          obscureText: true,
                          onChanged: (value) {
                            if (pwCont.text.trim() == pwCheckCont.text.trim()) {
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
                                    ? '??????????????? ???????????????.'
                                    : '??????????????? ???????????? ????????????.'
                                : '??????????????? ?????? ??? ??? ???????????????',
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      '????????? ?????? ????????? ????????????.',
                    ),
              actions: [
                data.isEmpty
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '????????? ????????????',
                        ),
                      )
                    : TextButton(
                        onPressed: correctpw &&
                                pwcheck &&
                                pwCont.text.isNotEmpty &&
                                pwCheckCont.text.isNotEmpty
                            ? () {
                                resetPw();
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        '???????????? ?????????',
                                      ),
                                      content: const Text(
                                        '??????????????? ????????????????????????.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context);
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
                                            '??????',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null,
                        child: const Text('???????????? ?????????'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
