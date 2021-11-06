import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_search/image_viewer/event.dart';
import 'package:photo_search/model/imageModel.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../Resources/StringConstants.dart';
import '../Resources/constants.dart';
import 'bloc.dart';
import 'state.dart';

class ImageViewerPage extends StatefulWidget {
  final PixBayImage pixImage;

  const ImageViewerPage({Key key, this.pixImage}) : super(key: key);

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  final ImageViewerBloc imgBloc = ImageViewerBloc();

  @override
  void initState() {
    imgBloc.add(CheckCurrentLoginEvents());
    InternetConnectionChecker().onStatusChange.listen((event) async {
      bool isInternet = await InternetConnectionChecker().hasConnection;
      if (!isInternet) imgBloc.add(InternetGoneEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    imgBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageViewerBloc, ImageViewerState>(
      cubit: imgBloc,
      builder: (context, state) {
        if (state is InternetGoneState) {
          return showError(context);
        } else if (state is FullScreenState) {
          return showImage(context, state.isFullScreen);
        } else {
          return showImage(context, false);
        }
      },
      listener: (context, state) {
        if (state is InternetGoneState) {
          Constants.showNoInternetAlert(context);
        } else if (state is DownloadImageState) {
          SnackBar snackBar;
          if (state.path == downloadFailed) {
            snackBar = SnackBar(
              content: Text(downloadFailed),
            );
          } else {
            snackBar = SnackBar(
              content: Text('Image Downloaded : ${state.path}'),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  Widget showError(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(imageViewerTitle),
        ),
      ),
      body: Center(
        child: Text(
          internetGoneViewerError,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  // Not Being used Currently
  // Zooms till we pinch the image
  Widget showImageZoomStyle2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(imageViewerTitle),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: () {
              // Add Download logic here !!
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Hero(
          tag: "Image + ${widget.pixImage.id}",
          child: Card(
            child: PinchZoom(
              child: Image.network(widget.pixImage.largeImageUrl),
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 2.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget showImage(BuildContext context, bool isFullScreen) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        actions: [
          MaterialButton(
            onPressed: () {
              imgBloc.add(DownloadImageEvent(widget.pixImage, 0, context));
            },
            child: Text(
              'SD',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          MaterialButton(
            onPressed: () {
              // Here Download Needs to be done
              imgBloc.add(
                DownloadImageEvent(widget.pixImage, 1, context),
              );
            },
            child: Text(
              'HD',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          MaterialButton(
            onPressed: () {
              imgBloc.add(
                ShareImageEvent(widget.pixImage, context),
              );
            },
            child: Icon(Icons.share),
          ),
          MaterialButton(
            onPressed: () {
              if (isFullScreen)
                imgBloc.add(FullScreenEvent(false));
              else
                imgBloc.add(FullScreenEvent(true));
            },
            child: isFullScreen
                ? Icon(Icons.fullscreen_exit)
                : Icon(Icons.fullscreen),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: "Image + ${widget.pixImage.id}",
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  maxScale: 4,
                  minScale: 0.5,
                  child: ClipRRect(
                    child: Image.network(
                      widget.pixImage.largeImageUrl,
                      fit: isFullScreen ? BoxFit.cover : BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
