import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_search/Resources/constants.dart';
import 'package:photo_search/Simple_Screens/WelcomeScreen.dart';
import 'package:photo_search/model/imageModel.dart';
import 'package:photo_search/services/PixBayNetwork.dart';

import '../Resources/StringConstants.dart';
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
    if (event is InitEvent) {
      yield await init();
    } else if (event is SearchEvent) {
      isEndData = false;
      list = [];
      currentPage = 1;
      await getData(event.searchString);
      yield PageLoadedState(list, isEndData, currentView);
    } else if (event is RefreshEvent) {
      list = [];
      currentPage = 1;
      isEndData = false;
      await getData(event.searchTerm);
      event.controller.refreshCompleted();
      yield PageLoadedState(list, isEndData, currentView);
    } else if (event is GetNextPageEvent) {
      isEndData = false;
      currentPage++;
      getData(event.searchString);
      event.controller.loadComplete();
      yield PageLoadedState(list, isEndData, currentView);
    } else if (event is InternetGoneEvent) {
      yield InternetGoneState(list, currentView);
    } else if (event is SwitchLayoutView) {
      isEndData = false;
      currentView = event.viewName;
      yield ViewChanged(list, event.viewName, isEndData);
    }
    else if (event is LeaveDashboardPageEvent) {
      checkToShowLogOutConfirmationAlert(event.context);
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

  void checkToShowLogOutConfirmationAlert(BuildContext context) async {
    FirebaseAuth fa = FirebaseAuth.instance;
    var currentUser = await fa.currentUser();
    if (currentUser != null) {
      Constants.showLogOutConfirmationAlert(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, WelcomeScreen.id, (route) => false);
    }
  }
}
