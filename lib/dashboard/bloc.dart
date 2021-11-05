import 'package:bloc/bloc.dart';
import 'package:photo_search/model/imageModel.dart';
import 'package:photo_search/services/PixBayNetwork.dart';

import '../Resources/StringContants.dart';
import 'event.dart';
import 'state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState().init());
  int currentPage = 1;
  List<PixBayImage> list = [];
  bool isEndData = false;
  String currentView = gridViewName;

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    print(event.toString());
    if (event is InitEvent) {
      yield await init();
    } else if (event is SearchEvent) {
      isEndData = false;
      list = [];
      currentPage = 1;
      await getData(event.searchString);
      print(list.length);
      yield PageLoadedState(list, isEndData, currentView);
    } else if (event is RefreshEvent) {
      list = [];
      currentPage = 1;
      isEndData = false;
      await getData(event.searchTerm);
      print(list.length);
      event.controller.refreshCompleted();
      yield PageLoadedState(list, isEndData, currentView);
    } else if (event is GetNextPageEvent) {
      isEndData = false;
      currentPage++;
      getData(event.searchString);
      event.controller.loadComplete();
      print(list.length);
      yield PageLoadedState(list, isEndData, currentView);
    } else if (event is InternetGoneEvent) {
      yield InternetGoneState(list, currentView);
    } else if (event is SwitchLayoutView) {
      isEndData = false;
      currentView = event.viewName;
      yield ViewChanged(list, event.viewName, isEndData);
    }
  }

  Future<void> getData(String searchTerm) async {
    List<PixBayImage> imagesList =
        await getPics(searchTerm, currentPage.toString(), defaultItemsPerPage);
    if (imagesList != null) {
      list.addAll(imagesList);
    } else {
      isEndData = true;
    }
  }

  Future<DashboardState> init() async {
    return state.clone();
  }
}
