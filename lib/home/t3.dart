import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageViewerState();
  }
}

class ImageViewerState extends State<ImageViewer> {
  List<String> urls = [
    'https://img0.baidu.com/it/u=3367946648,1557880515&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500',
    'https://www.w3school.com.cn/example/html5/mov_bbb.mp4',
    'https://img2.baidu.com/it/u=3369768849,1534109460&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800',
    'https://img2.baidu.com/it/u=3611151199,133363241&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800',
    'https://i.pinimg.com/originals/85/03/93/85039311ce13e7cfd824e155a376003d.png'
  ];
  int index = 0;
  VideoPlayerController? _controller;
  Uint8List? imageBytesList;

  @override
  void initState() {
    super.initState();
    loadAsset(urls[index]);

    Timer.periodic(Duration(seconds: 5), (timer) {
      index++;
      if (index >= urls.length) index = 0;
      loadAsset(urls[index]);
      // downloadImageBytes(urls[aaa]).then((value) {
      //   setState(() {
      //     this.imageBytesList = value;
      //   });
      // });
      // aaa++;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("显示加载的图片"),
      ),
      body: Container(
          // height: double.infinity,
          // width: double.infinity,
          child: imageBytesList != null
              ? urls[index].endsWith(".mp4")
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Image.memory(imageBytesList!)
              : Container()),
    );
  }

  void loadAsset(String url) async {
    if (url.endsWith(".mp4")) {
      Uri u = Uri.parse(url);
      _controller = VideoPlayerController.networkUrl(u)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        }).catchError((error) {
          print(error);
        });
    } else {
      downloadImageBytes(url).then((value) {
        setState(() {
          imageBytesList = value;
        });
      });
    }
  }

  Future<Uint8List?> downloadImageBytes(String url) async {
    var uiImage = await loadImage(url);
    var pngBytes = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (pngBytes != null) {
      return pngBytes.buffer.asUint8List();
    }
    return null;
  }

  Future<ui.Image> loadImage(String url) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStreamListener? listener;
    ImageStream stream =
        CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image);
      if (listener != null) {
        stream.removeListener(listener);
      }
    });
    stream.addListener(listener);
    return completer.future;
  }
}
