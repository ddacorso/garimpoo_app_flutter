import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garimpoo/bloc/dash_bloc.dart';
import 'package:garimpoo/bloc/filter_bloc.dart';
import 'package:garimpoo/bloc/product_bloc.dart';
import 'package:garimpoo/local_storage/local_storage_repository.dart';
import 'package:garimpoo/presentation/Dashboard/dashboard.dart';
import 'package:garimpoo/presentation/SignUp/sign_up.dart';
import 'package:garimpoo/repository/client_repository.dart';
import 'package:garimpoo/splash/splash.dart';

import 'bloc/auth_bloc.dart';
import 'presentation/SignIn/sign_in.dart';
import 'repository/auth_repository.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.max,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize SharedPrefs instance.
  await LocalStorageShared.init();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );


  runApp(Application());
}

class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyApp();
}

class MyApp extends State<Application> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _prepareAndroidForegroundMessages();
    FirebaseMessaging.onMessageOpenedApp.listen(listenMsgOpened);

  }

  void listenMsgOpened(data) {

      navigatorKey.currentState?.pushReplacementNamed( "/dashboard", arguments: {"hasAlerts": true});
  }

  void _prepareAndroidForegroundMessages() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {

        var android =  const AndroidInitializationSettings('@mipmap/ic_launcher');
        var initiallizationSettingsIOS = const IOSInitializationSettings();
        var initialSetting = InitializationSettings(android: android, iOS: initiallizationSettingsIOS);
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.initialize(initialSetting);

        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
        );
        const iOSDetails = IOSNotificationDetails();
        const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iOSDetails);

        flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, platformChannelSpecifics);
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(providers: [RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
      RepositoryProvider<ClientRepository>(create: (context) => ClientRepository(Dio()))], child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                authRepository:
                RepositoryProvider.of<AuthRepository>(context),
                clientRepository:
                RepositoryProvider.of<ClientRepository>(context)
            )),

      ],
      child: MaterialApp(
      navigatorKey: navigatorKey,
        routes: {
          '/signin': (context) => const SignIn(),
          '/signup': (context) => const SignUp(),
          Dashboard.routeName: (context) => const Dashboard(),
          '/splash': (context) =>  const Splash(),
        },
        theme: ThemeData(fontFamily: 'Lexend'),
        initialRoute: "/splash",
      ),
    ));
  }
}
