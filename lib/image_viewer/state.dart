class ImageViewerState {
  ImageViewerState init() {
    return ImageViewerState();
  }

  ImageViewerState clone() {
    return ImageViewerState();
  }
}

class InternetGoneState extends ImageViewerState {}

class DownloadImageState extends ImageViewerState {
  final String path;

  DownloadImageState(this.path);
}

class FullScreenState extends ImageViewerState {
  final bool isFullScreen;

  FullScreenState(this.isFullScreen);
}
