import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garimpoo/bloc/notification_bloc.dart';
import 'package:garimpoo/model/ProductNotification.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/auth_bloc.dart';

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<NotificationBloc>(context).add(NotificationLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
        builder: (context, state) {

          logger.d(state);

          if (state is NotificationsNothingToLoad) {
            return Container(
                color: Colors.grey.shade100.withOpacity(1),
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: IconButton(
                          iconSize: 75,
                          icon: ImageIcon(
                            AssetImage('images/refresh.png'),
                          ),
                          onPressed: () {
                            BlocProvider.of<NotificationBloc>(context)
                                .add(NotificationLoad());
                          }),
                    ),
                    Center(
                        child: Text(
                      'Ops...\nNenhum alerta por enquanto!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ))
                  ],
                ));
          }

          if (state is Loading) {
            return Container(
                color: Colors.grey.shade100.withOpacity(1),
                height: double.infinity,
                width: double.infinity,
                child: Center(
                    child: Image.asset(
                  "images/pickaxe_loading.gif",
                )));
          }

          if (state is NotificationsLoadedSuccess) {
            return Scaffold(body: dataBody(state.products));
          }

          return Container();
        },
        listener: (context, state) {});
  }

  final ItemScrollController _scrollController = ItemScrollController();

  ScrollablePositionedList dataBody(List<ProductNotification> products) {
    return ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: products.length ,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                launch(products[index].permaLink!, forceSafariVC: false);
              },
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 90,
                            height: 90,
                            child: products[index].thumbnail != null
                                ? Image.network(products[index].thumbnail)
                                : null),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "R\$ " + products[index].price.toString(),
                                      style: TextStyle(
                                          fontSize: 26, color: Colors.black54)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(products[index].title!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ))),
                                ],
                              )),
                        ),
                      ])));
        });
  }
}
