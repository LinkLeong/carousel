import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:untitled/home/full_image.dart';
import 'package:http/http.dart' as http;

class ImageSlideshow extends StatefulWidget {
  final List<String> imageUrls;

  ImageSlideshow(this.imageUrls);

  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  int currentIndex = 0;
  bool imagesLoaded = false;

  Map<String, MemoryImage> imageCache = {};

  @override
  void initState() {
    super.initState();
    if (imageCache.containsKey(widget.imageUrls[currentIndex])) {
      imageCache.remove(widget.imageUrls[currentIndex]);
    }
    currentIndex = (currentIndex + 1) % widget.imageUrls.length;
    loadImageSync(widget.imageUrls[currentIndex]);
    print("当前:${currentIndex}");
    print("图片长度：${widget.imageUrls.length}");
    // 开启轮播
    startSlideshow();
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
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (imageCache.containsKey(widget.imageUrls[currentIndex])) {
            imageCache.remove(widget.imageUrls[currentIndex]);
          }
          currentIndex = (currentIndex + 1) % widget.imageUrls.length;
          loadImage(widget.imageUrls[currentIndex]);
          print("当前:${currentIndex}");
          print("图片长度：${widget.imageUrls.length}");
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
    if (widget.imageUrls.isNotEmpty&&imageCache.isNotEmpty) {
      return imageCache[widget.imageUrls[currentIndex]]!;
    }
    return Text("data");
  }

  @override
  Widget build(BuildContext context) {
    if (widget == null) return Container();
    return Scaffold(
      body: PageView.builder(
        itemCount: widget.imageUrls.length,
        controller: PageController(initialPage: currentIndex),
        onPageChanged: (int index) => setState(() => currentIndex = index),
        itemBuilder: (_, i) {
          print("索引：${i}");
          // return  Image.network(
          //   widget.imageUrls[i],
          //   fit: BoxFit.cover,
          //
          // );
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true, //全屏
                        builder: (_) => FullScreenImagePage(
                            imageUrl: widget.imageUrls[i])));
              },
              child: Image(image: GetImg()));
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
