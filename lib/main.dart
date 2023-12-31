import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/index/index.dart';


void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, // 竖屏
  //   DeviceOrientation.landscapeLeft, // 横屏
  //   DeviceOrientation.landscapeRight, // 横屏
  // ]);
  WidgetsFlutterBinding.ensureInitialized(); //不加这个强制横/竖屏会报错
  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        print("当前屏幕的方向是：$orientation");
        return new MaterialApp(
          title: 'Flutter Demo',
          home: new ImageSlideshow(),  // 指定去加载 Index页面。
        );
      },
    );



  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("四个菜单按钮页面"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MenuButton(text: "菜单1"),
            MenuButton(text: "菜单2"),
            MenuButton(text: "菜单3"),
            MenuButton(text: "菜单4"),
          ],
        ),
      ),


    );
  }
}
// 自定义菜单按钮 Widget
class MenuButton extends StatelessWidget {

  final String text;

  MenuButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () {
        //按钮点击事件处理
      },
    );
  }
}
