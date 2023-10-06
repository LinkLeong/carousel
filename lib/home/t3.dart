import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class ImageViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageViewerState();
  }
}

class ImageViewerState extends State<ImageViewer> {
  List<String> urls = [];
  int index = 0;
  VideoPlayerController? _controller;
  Uint8List? imageBytesList;

  @override
  void initState() {
    super.initState();
    _loadUrls();
//    loadAsset(urls[index]);
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (urls.isNotEmpty){
        index++;
        if (index >= urls.length) index = 0;
        loadAsset(urls[index]);
      }
      // downloadImageBytes(urls[aaa]).then((value) {
      //   setState(() {
      //     this.imageBytesList = value;
      //   });
      // });
      // aaa++;
    });
  }
  void _loadUrls() async {
    final response = await http.get(Uri.parse('http://192.168.2.193:8082/v1/files'));
    final u = jsonDecode(response.body).cast<String>();
    await Future.delayed(Duration.zero);
    setState(() {
      this.urls = u;
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
      // appBar: AppBar(
      //   title: Text("显示加载的图片"),
      // ),
      // body: Container(
      //     // height: double.infinity,
      //     // width: double.infinity,
      //     child: imageBytesList != null
      //         ? urls[index].endsWith(".mp4")
      //             ? AspectRatio(
      //                 aspectRatio: _controller!.value.aspectRatio,
      //                 child: VideoPlayer(_controller!),
      //               )
      //             : Image.memory(imageBytesList!)
      //         : Container()),
      body: urls.isEmpty
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
        future: downloadImageBytes(urls[index]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            } else {
              return Text('Error: ${snapshot.error}');
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void loadAsset(String url) async {
    if (url.endsWith(".mp4")) {
      Uri u = Uri.parse( url);
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
          print("下载$url完成");
          imageBytesList = value;
        });
      });
    }
  }

  Future<Uint8List?> downloadImageBytes(String url) async {
    url="http://192.168.2.193:8082/v1/file?path=$url";
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
