import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class DashboardEvent {}

class InitEvent extends DashboardEvent {}

class GetNextPageEvent extends DashboardEvent {
  final String searchString;
  final RefreshController controller;

  GetNextPageEvent(this.searchString, this.controller);
}

class SearchEvent extends DashboardEvent {
  final String searchString;

  SearchEvent(this.searchString);
}

class RefreshEvent extends DashboardEvent {
  final BuildContext context;
  final RefreshController controller;
  final String searchTerm;

  RefreshEvent(this.context, this.controller, this.searchTerm);
}

class InternetGoneEvent extends DashboardEvent {}

class SwitchLayoutView extends DashboardEvent {
  final String viewName;

  SwitchLayoutView(this.viewName);
}

class LeaveDashboardPageEvent extends DashboardEvent {
  final BuildContext context;

  LeaveDashboardPageEvent(this.context);
}
