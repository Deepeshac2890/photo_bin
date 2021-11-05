import 'package:photo_search/model/imageModel.dart';

class DashboardState {
  DashboardState init() {
    return DashboardState();
  }

  DashboardState clone() {
    return DashboardState();
  }
}

class PageLoadedState extends DashboardState {
  final List<PixBayImage> listOfImages;
  final bool dataNotFound;
  final String viewName;

  PageLoadedState(this.listOfImages, this.dataNotFound, this.viewName);
}

class LoadingState extends DashboardState {}

class LoadingNextPageState extends DashboardState {}

class InternetGoneState extends DashboardState {
  final List<PixBayImage> listOfImages;
  final String viewName;

  InternetGoneState(this.listOfImages, this.viewName);
}

class ViewChanged extends DashboardState {
  final List<PixBayImage> listOfImages;
  final String viewName;
  final bool dataNotFound;

  ViewChanged(this.listOfImages, this.viewName, this.dataNotFound);
}
