import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:cached_network_image/cached_network_image.dart';

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