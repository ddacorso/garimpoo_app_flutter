import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garimpoo/model/Filter.dart' as model;

import '../../../bloc/filter_bloc.dart';
import '../../../model/Keyword.dart';
import '../../../shared/Credentials.dart';
import '../../../util/constants.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterUpState();
}

class _FilterUpState extends State<Filter> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FilterBloc>(context).add(FilterRequestLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state is FilterShowReady) {
            return buildFilters(state.index, state.filterScreen);
          }

          if (state is FilterLoading) {
            return Container(
                color: Colors.grey.shade100.withOpacity(1),
                height: double.infinity,
                width: double.infinity,
                child: Center(
                    child: Image.asset(
                  "images/pickaxe_loading.gif",
                )));
          }

          return Container();
        },
        listener: (context, state) {});
  }

  ListView buildListMoreFilters(model.FilterScreen filterScreen, int currentIndex) {
    return ListView(children: [
      //title 1
      Padding(
        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
        child: Center(
          child: Text(
            txtGarimpooAdditionalFilters,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      // finalizados
      Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text("Anunciados Hoje"),
                Switch(
                  activeColor: Colors.yellow.shade800,
                  value: filterScreen.isPublishedToday,
                  onChanged: (value) {
                    BlocProvider.of<FilterBloc>(context).add(
                        FilterSwitchValue(filterScreen, value, 0, currentIndex)
                    );
                  },
                ),
              ],
            ),
            Column(
              children: [
                Text("Finalizados Hoje"),
                Switch(
                  activeColor: Colors.yellow.shade800,
                  value: filterScreen.isFinishingToday,
                  onChanged: (value) {
                    BlocProvider.of<FilterBloc>(context).add(
                        FilterSwitchValue(filterScreen, value, 1, currentIndex)
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }

  ListView buildListKeyNot(model.FilterScreen filterScreen, int currentIndex) {

    List<TextEditingController> controllers = currentIndex == 0 ? filterScreen.keywordController! : filterScreen.notificationController!;


    List<Keyword> data = filterScreen.keywords.where((element) => element.type == (currentIndex == 0 ? 'key' : 'not')).toList();
    int maxCount = currentIndex == 0 ? filterScreen.maxKeywords : filterScreen.maxNotifications;

     String textAlert = '';

    Text alert = currentIndex == 0 ? Text(
      txtGarimpooAlert,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ) : Text(
      txtNotificationsAlert,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

    return ListView(children: [
      //title 1
       Padding(
        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
        child: Center(
          child: alert,
        ),
      ),
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            bool isEnabled = data[index].isActive;
            //filter 1
            return Padding(
              padding: EdgeInsets.only(
                  top: index == 0 ? 25 : 5, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            if (!isEnabled) {
                              BlocProvider.of<FilterBloc>(context).add(
                                FilterSwitchValue(filterScreen, true, index, currentIndex)
                              );
                            }
                          },
                          child: TextField(
                            controller: controllers[index],
                              enabled: isEnabled,
                              style: TextStyle(color: Colors.black38),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                labelText:
                                    txtKeyword + " " + (index + 1).toString(),
                                hintStyle: TextStyle(color: Colors.black26),
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                                hintText: txtTypeKeyword +
                                    " " +
                                    (index + 1).toString(),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                              )))),
                  Switch(
                    activeColor: Colors.amber.shade600,
                    value: isEnabled,
                    onChanged: (value) {
                      BlocProvider.of<FilterBloc>(context).add(
                          FilterSwitchValue(filterScreen, value, index, currentIndex)
                      );
                    },
                  ),
                ],
              ),
            );
          },
          itemCount: data.length),
      //more
      Padding(
        padding: EdgeInsets.only(top: 5, left: 20, right: 20),
        child: Center(
          child: MaterialButton(
            onPressed: () {
              if (data.length < maxCount) {
                BlocProvider.of<FilterBloc>(context).add(
                  FilterAddKeyword(filterScreen, currentIndex == 0 ? 'key' : 'not'),
                );
              }
            },
            color: Colors.amber.shade600,
            textColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 25,
            ),
            padding: EdgeInsets.all(0),
            shape: CircleBorder(),
          ),
        ),
      ),
    ]);
  }

  Scaffold buildFilters(int currentIndex, model.FilterScreen filterScreen) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(239, 241, 248, 1),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child:
              SizedBox(height: MediaQuery.of(context).size.height,   child:   Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                     BlocProvider.of<FilterBloc>(context)
                         .add(FilterLoadTab(index, filterScreen));
                  },
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height - 240),
              items: [0, 1, 2].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: currentIndex == 2 || currentIndex == 0 ?  buildListKeyNot(filterScreen, currentIndex) : buildListMoreFilters(filterScreen, currentIndex));
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0, 1, 2].map((url) {
                int index = [0, 1, 2].indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, right: 20.0, left: 20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  onPressed: () {
                    //
                     BlocProvider.of<FilterBloc>(context)
                         .add(FilterRequestSave(filterScreen, currentIndex));
                  },
                  child: Text(txtSave,
                      style: TextStyle(
                          color: Colors.yellow.shade800,
                          fontWeight: FontWeight.bold)),
                )),
          ])),
        ));
  }
}
