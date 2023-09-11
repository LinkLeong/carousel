import 'package:flutter/material.dart';
class MyPage extends StatefulWidget{
  @override
  State<StatefulWidget>  createState() =>   _MyPageState();
}
class _MyPageState extends State<MyPage>  {
@override
Widget build(BuildContext context) {
  return  MaterialApp(
    home:  Scaffold(
        appBar:  AppBar(
          title:  Text('我的'),
// 后面的省略
// ......
        )
    ),
  );
}
}