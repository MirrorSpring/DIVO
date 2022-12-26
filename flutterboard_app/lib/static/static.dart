import 'package:shared_preferences/shared_preferences.dart';

class Static{
  //Desc: 여러 공간에서 작업하기 위한 IP 주소 설정
  //Date: 2022-12-23
  static String ipAddress="192.168.10.213";

  //Desc: 앱 종료 혹은 로그아웃 버튼을 누를 때
  //Date: 2022-12-23
  static disposeSharedPreferences() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}