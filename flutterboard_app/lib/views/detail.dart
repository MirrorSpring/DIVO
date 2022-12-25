import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BoardDetail extends StatefulWidget {
  final int boardid;
  const BoardDetail({super.key,required this.boardid});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}