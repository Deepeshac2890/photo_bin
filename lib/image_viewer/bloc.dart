import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_search/Resources/constants.dart';
import 'package:share_plus/share_plus.dart';

import '../Resources/StringConstants.dart';
import 'event.dart';
import 'state.dart';

class ImageViewerBloc extends Bloc<ImageViewerEvent, ImageViewerState> {
  bool isUserLoggedIn;

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
        if (isUserLoggedIn)
          path = await downloadImage(event.pixy.largeImageUrl);
        else {
          Constants.showNoLoginAlert(event.context);
        }
      }
      yield DownloadImageState(path);
    } else if (event is FullScreenEvent) {
      yield FullScreenState(event.isFullScreen);
    } else if (event is ShareImageEvent) {
      _onShare(event.context, event.pixy.largeImageUrl);
      yield ShareImageState();
    } else if (event is CheckCurrentLoginEvents) {
      isLoggedIn();
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

  void _onShare(BuildContext context, String downloadURL) async {
    try {
      var imageId = await ImageDownloader.downloadImage(downloadURL);
      var path = await ImageDownloader.findPath(imageId);
      final box = context.findRenderObject() as RenderBox;
      await Share.shareFiles([path],
          text: shareImageText,
          subject: shareImageSubject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      File file = File(path);
      file.delete();
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void isLoggedIn() async {
    FirebaseAuth fa = FirebaseAuth.instance;
    var currentUser = await fa.currentUser();
    if (currentUser == null)
      isUserLoggedIn = false;
    else
      isUserLoggedIn = true;
  }
}
