
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageViewerState();
  }

}

class ImageViewerState extends State<ImageViewer> {

  Uint8List? imageBytesList;

  @override
  void initState() {
    super.initState();
    downloadImageBytes().then((value) {
      setState(() {
        this.imageBytesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("显示加载的图片"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: imageBytesList != null ? Image.memory(imageBytesList!) : SizedBox.shrink(),
      ),
    );
  }

  Future<Uint8List?> downloadImageBytes() async {
    var uiImage = await loadImage("https://i.pinimg.com/originals/85/03/93/85039311ce13e7cfd824e155a376003d.png");
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