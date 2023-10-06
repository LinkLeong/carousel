import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:untitled/home/full_image.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';
import 'dart:convert';


class ImageSlideshow extends StatefulWidget {


  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  List<String> urls = ["http://192.168.2.193:8082/v1/file?path=/images/IMG_20230916_150554.jpg"];
  int currentIndex = 0;
  bool imagesLoaded = false;

  Map<String, MemoryImage> imageCache = {};

  @override
  void initState() {
    _loadUrls();

    super.initState();
    // if (imageCache.containsKey(urls[currentIndex])) {
    //   imageCache.remove(urls[currentIndex]);
    // }
    // currentIndex = (currentIndex + 1) % urls.length;
    //loadImageSync(urls[currentIndex]);
    print("当前:${currentIndex}");
    print("图片长度：${urls.length}");
    // 开启轮播
    startSlideshow();
  }

  void _loadUrls() async {
    final response = await http.get(Uri.parse('http://192.168.2.193:8082/v1/files'));
    final us = jsonDecode(response.body).cast<String>();
    await Future.delayed(Duration.zero);
    setState(() {
      urls = us;
    });
  }

  @override
  void dispose() {
    //销毁时停止轮播
    stopSlideshow();
    super.dispose();
  }

// 同步加载接口
  loadImageSync(String url) {
    return loadImage(url);
  }

// 异步加载
  loadImage(String url) async {
    if (imageCache.containsKey(url)) {
      return imageCache[url];
    }

    Uint8List bytes = await downloadImageFromNetwork(url);
    MemoryImage image = MemoryImage(bytes);
    imageCache[url] = image;

    return bytes;
  }

  downloadImageFromNetwork(String url) async {
    var client = http.Client();
    Uri uri = Uri.parse(url);
    var response = await client.get(uri);
    imagesLoaded = true;
    return response.bodyBytes;
  }

  // 开启轮播
  void startSlideshow() {
    Timer.periodic(Duration(seconds: 20), (timer) {
      if (mounted) {
        setState(() {
          if (imageCache.containsKey(urls[currentIndex])) {
            imageCache.remove(urls[currentIndex]);
          }
          currentIndex = (currentIndex + 1) % urls.length;
          if(currentIndex+1==urls.length){
            _loadUrls();
          }
          loadImage(urls[currentIndex]);
          print("当前:${currentIndex}");
          print("图片长度：${urls.length}");
        });
      }
    });
  }

  // 停止轮播
  void stopSlideshow() {
    setState(() {
      currentIndex = 0;
    });
  }

  GetImg() {
    if (urls.isNotEmpty&&imageCache.isNotEmpty) {
      return imageCache[urls[currentIndex]]!;
    }
    return imageCache[urls[currentIndex]]!;
  }

  @override
  Widget build(BuildContext context) {
    if (widget == null) return Container();
    return Scaffold(
      body: PageView.builder(
        itemCount: urls.length,
        controller: PageController(initialPage: currentIndex),
        onPageChanged: (int index) => setState(() => currentIndex = index),
        itemBuilder: (_, i) {
          print("索引：${i}");
          return  Image.network(
            urls[currentIndex],
            fit: BoxFit.contain,

          );
          // return GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               fullscreenDialog: true, //全屏
          //               builder: (_) => FullScreenImagePage(
          //                   imageUrl: "http://192.168.2.193:8082/v1/file?path=${urls[i]}")));
          //     },
          //     child: Image(image: GetImg()));
        },
      ),
    );
  }
}
// class _HomePageState extends State<HomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     const indexStr= Text("首页");
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//             title: indexStr,
//             actions: <Widget>[Container()],
//       ),
//       body: Center(
//         child: null,
//       ),
//     ),);
//   }
// }
