import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reading_wucc/models/models.dart';
import 'package:reading_wucc/notifiers/notifiers.dart';
import 'package:reading_wucc/services/services.dart';
import 'package:reading_wucc/support/theme.dart';
import 'package:reading_wucc/support/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Scheduled notifications for reminders',
        locked: false,
        importance: NotificationImportance.Default,
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppUser?>.value(
          value: AuthService().appUserStream,
          initialData: null,
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (_) => UserNotifier(FirebaseAuth.instance.currentUser),
        ),
        ChangeNotifierProvider<EventNotifier>(
          create: (_) => EventNotifier(),
        ),
        ChangeNotifierProvider<ResponseNotifier>(
          create: (_) => ResponseNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyThemes.lightTheme,
        home: const Wrapper(),
      ),
    );
  }
}
