import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

import '../Resources/StringContants.dart';
import 'event.dart';
import 'state.dart';

class ImageViewerBloc extends Bloc<ImageViewerEvent, ImageViewerState> {
  ImageViewerBloc() : super(ImageViewerState().init());

  @override
  Stream<ImageViewerState> mapEventToState(ImageViewerEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is InternetGoneEvent) {
      yield InternetGoneState();
    } else if (event is DownloadImageEvent) {
      String path = downloadFailed;
      if (event.type == 0) {
        path = await downloadImage(event.pixy.webformatUrl);
      } else if (event.type == 1) {
        path = await downloadImage(event.pixy.largeImageUrl);
      }
      yield DownloadImageState(path);
    }
    else if (event is FullScreenEvent) {
      yield FullScreenState(event.isFullScreen);
    }
  }

  Future<String> downloadImage(String downloadURL) async {
    try {
      var imageId = await ImageDownloader.downloadImage(downloadURL);
      if (imageId == null) {
        return downloadFailed;
      }
      var path = await ImageDownloader.findPath(imageId);
      return path;
    } on PlatformException catch (error) {
      print(error);
    }
    return downloadFailed;
  }

  Future<ImageViewerState> init() async {
    return state.clone();
  }
}
