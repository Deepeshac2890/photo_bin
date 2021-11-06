import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_search/dashboard/event.dart';
import 'package:photo_search/image_viewer/view.dart';
import 'package:photo_search/model/imageModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Resources/StringConstants.dart';
import '../Resources/constants.dart';
import 'bloc.dart';
import 'state.dart';

class DashboardPage extends StatefulWidget {
  static final String id = "DashboardPage";
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final DashboardBloc db = DashboardBloc();

  @override
  void initState() {
    InternetConnectionChecker().onStatusChange.listen((event) async {
      bool isInternet = await InternetConnectionChecker().hasConnection;
      if (!isInternet)
        db.add(InternetGoneEvent());
      else {
        db.add(SearchEvent(searchController.text));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        db.add(LeaveDashboardPageEvent(context));
      },
      child: BlocConsumer<DashboardBloc, DashboardState>(
          cubit: db,
          builder: (context, state) {
            if (state is LoadingState) {
              return loadingState(context);
            } else if (state is PageLoadedState) {
              if (state.dataNotFound) {
                loadFailed(context);
              }
              if (state.viewName == listViewName) {
                return listViewWidget(
                    context, state.listOfImages, state.dataNotFound);
              } else
                return gridViewWidget(
                    context, state.listOfImages, state.dataNotFound);
            } else if (state is InternetGoneState) {
              if (state.viewName == listViewName) {
                return listViewWidget(context, state.listOfImages, true);
              } else
                return gridViewWidget(context, state.listOfImages, true);
            } else if (state is ViewChanged) {
              if (state.viewName == listViewName) {
                return listViewWidget(
                    context, state.listOfImages, state.dataNotFound);
              } else {
                return gridViewWidget(context, state.listOfImages, true);
              }
            } else {
              db.add(SearchEvent(""));
              return gridViewWidget(context, null, false);
            }
          },
          listener: (context, state) {
            if (state is InternetGoneState) {
              Constants.showNoInternetAlert(context);
            }
          }),
    );
  }

  void loadFailed(BuildContext context) {
    try {
      final snackBar = SnackBar(content: Text(unableToLoadData));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(serviceDown);
    }
  }

  Widget loadingState(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget gridViewWidget(
      BuildContext context, List<PixBayImage> imagesList, bool dataNotFound) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            onPressed: () {
              db.add(SwitchLayoutView(listViewName));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypewriterAnimatedTextKit(
                      text: [dashboardAppTitleName],
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(dashboardSubTitle),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: Constants.kTextFieldDecoration,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  MaterialButton(
                    splashColor: Colors.redAccent,
                    color: Colors.blueAccent,
                    elevation: 10,
                    child: Text(
                      searchButtonTitle,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      db.add(SearchEvent(searchController.text));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (imagesList != null)
                Expanded(
                  flex: 3,
                  child: SmartRefresher(
                    enablePullUp: true,
                    controller: refreshController,
                    onRefresh: () async {
                      db.add(
                        RefreshEvent(
                          context,
                          refreshController,
                          searchController.text,
                        ),
                      );
                    },
                    onLoading: () async {
                      if (!dataNotFound)
                        db.add(GetNextPageEvent(
                            searchController.text, refreshController));
                      else {
                        loadFailed(context);
                      }
                    },
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: imagesList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Hero(
                          tag: "Image + ${imagesList[index].id}",
                          child: RawMaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageViewerPage(
                                    pixImage: imagesList[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      imagesList[index].webformatUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Center(
                      child: Text(dashboardDefaultContainerString),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewWidget(
      BuildContext context, List<PixBayImage> imagesList, bool dataNotFound) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.grid_view),
            onPressed: () {
              db.add(SwitchLayoutView(gridViewName));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypewriterAnimatedTextKit(
                      text: [dashboardAppTitleName],
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(dashboardSubTitle),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: Constants.kTextFieldDecoration,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  MaterialButton(
                    splashColor: Colors.redAccent,
                    color: Colors.blueAccent,
                    elevation: 10,
                    child: Text(
                      searchButtonTitle,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      db.add(SearchEvent(searchController.text));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (imagesList != null)
                Expanded(
                  flex: 3,
                  child: SmartRefresher(
                    enablePullUp: true,
                    controller: refreshController,
                    onRefresh: () async {
                      db.add(
                        RefreshEvent(
                          context,
                          refreshController,
                          searchController.text,
                        ),
                      );
                    },
                    onLoading: () async {
                      if (!dataNotFound)
                        db.add(GetNextPageEvent(
                            searchController.text, refreshController));
                      else {
                        loadFailed(context);
                      }
                    },
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: "Image + ${imagesList[index].id}",
                            child: Card(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ImageViewerPage(
                                        pixImage: imagesList[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                    imagesList[index].webformatUrl),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 5,
                            color: Colors.black,
                          );
                        },
                        itemCount: imagesList.length),
                  ),
                )
              else
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Center(
                      child: Text(dashboardDefaultContainerString),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
