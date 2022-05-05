import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garimpoo/bloc/dash_bloc.dart';
import 'package:garimpoo/bloc/notification_bloc.dart';
import 'package:garimpoo/presentation/Dashboard/filter/filter.dart';
import 'package:garimpoo/presentation/Dashboard/search/search.dart';
import 'package:garimpoo/presentation/Dashboard/notifications/notification.dart' as not;

import '../../bloc/auth_bloc.dart';
import '../../bloc/filter_bloc.dart';
import '../../bloc/product_bloc.dart';
import '../../repository/auth_repository.dart';
import '../../repository/client_repository.dart';
import '../../util/constants.dart';

enum NavbarItems { Filter, Search, Notifications }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  static const routeName = '/dashboard';
  @override
  State<Dashboard> createState() => _DashboardSignUpState();
}

class _DashboardSignUpState extends State<Dashboard> {
  @override
  void dispose() {
    super.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {


    return MultiBlocProvider(providers: [
      BlocProvider<DashBloc>(
          create: (BuildContext context) => DashBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context))),
      BlocProvider<ProductBloc>(
          create: (BuildContext context) => ProductBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              clientRepository:
                  RepositoryProvider.of<ClientRepository>(context))),
      BlocProvider<FilterBloc>(
          create: (BuildContext context) => FilterBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              clientRepository:
                  RepositoryProvider.of<ClientRepository>(context))),
      BlocProvider<NotificationBloc>(
          create: (BuildContext context) => NotificationBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              clientRepository:
                  RepositoryProvider.of<ClientRepository>(context))),
    ], child: const _DashboardScreen());
  }
}

class _DashboardScreen extends StatefulWidget {
  const _DashboardScreen({Key? key}) : super(key: key);

  @override
  State<_DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<_DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    _preparePermissions();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
      Map<String, bool> values = ModalRoute.of(context)!.settings.arguments as Map<String, bool>;

    if (values["hasAlerts"] == true) {
      values["hasAlerts"] = false;
      BlocProvider.of<DashBloc>(context).add(
        TabChangeRequested(
            NavbarItems.Notifications),
      );
    }
  }

  void _preparePermissions() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<DashBloc, DashState>(builder: (context, state) {

      if (state is ShowNotification) {
        return buildDash("Alertas", 3, const not.Notification());
      }

      if (state is ShowFilter) {
        return buildDash("Filtros", 0, const Filter());
      }

      if (state is ShowSearch) {
        return buildDash("Carregar Items", 1, const Search());
      }


      return Container();
    }, listener: (context, state) {
      if (state is LoggedOut) {
        Navigator.pushReplacementNamed(context, "/splash");
      }
    });
  }

  Scaffold buildDash(String title, int currentIndex, Widget showComp) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.70, // 75% of screen will be occupied
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(''),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 200, 55, 1),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Deslogar'),
                  onTap: () {
                    context.read<DashBloc>().add(SignOutRequested());
                  },
                ),
              ],
            ),
          ),
        ),
        body: showComp,
        //appbar
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(title),
          backgroundColor: Color.fromRGBO(255, 200, 55, 1),
          leading: IconButton(
            icon: Image.asset(
              "./images/perfil.png",
              width: 40,
              height: 40,
            ),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
        ),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0.0,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            selectedItemColor: Colors.black,
            currentIndex: currentIndex,
            onTap: (index) {
              BlocProvider.of<DashBloc>(context).add(
                TabChangeRequested(
                    index == 0 ? NavbarItems.Filter : index == 1 ? NavbarItems.Search : NavbarItems.Notifications),
              );
            },
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "./images/filtro.png",
                    width: 40,
                    height: 40,
                  ),
                  label: txtFilter),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "./images/garimpo.png",
                    width: 40,
                    height: 40,
                  ),
                  label: txtSearch),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "./images/descarte.png",
                    width: 40,
                    height: 40,
                  ),
                  label: txtUndo),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "./images/diamond.png",
                    width: 40,
                    height: 40,
                  ),
                  label: txtNotifications)
            ]));
  }
}
