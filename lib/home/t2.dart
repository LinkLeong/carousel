import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:untitled/home/t1.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<Uint8List?> downloadImageBytes() async {
  var uiImage = await loadImage("https://i.pinimg.com/originals/85/03/93/85039311ce13e7cfd824e155a376003d.png");
  var pngBytes = await uiImage.toByteData(format: ui.ImageByteFormat.png);
  if (pngBytes != null) {
    return pngBytes.buffer.asUint8List();
  }
  return null;
}