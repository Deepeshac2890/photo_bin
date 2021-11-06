import 'package:flutter/cupertino.dart';
import 'package:photo_search/model/imageModel.dart';

abstract class ImageViewerEvent {}

class InitEvent extends ImageViewerEvent {}

class InternetGoneEvent extends ImageViewerEvent {}

class DownloadImageEvent extends ImageViewerEvent {
  final PixBayImage pixy;
  final int type;
  final BuildContext context;

  DownloadImageEvent(this.pixy, this.type, this.context);
}

class FullScreenEvent extends ImageViewerEvent {
  final bool isFullScreen;

  FullScreenEvent(this.isFullScreen);
}

class ShareImageEvent extends ImageViewerEvent {
  final PixBayImage pixy;
  final BuildContext context;

  ShareImageEvent(this.pixy, this.context);
}

class CheckCurrentLoginEvents extends ImageViewerEvent {}
