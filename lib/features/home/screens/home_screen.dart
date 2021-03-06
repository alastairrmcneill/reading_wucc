import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:reading_wucc/features/home/screens/screens.dart';
import 'package:reading_wucc/features/home/widgets/custom_dialog_box.dart';
import 'package:reading_wucc/features/home/widgets/event_list_view.dart';
import 'package:reading_wucc/features/home/widgets/widgets.dart';
import 'package:reading_wucc/models/models.dart';
import 'package:reading_wucc/notifiers/notifiers.dart';
import 'package:reading_wucc/services/event_database.dart';
import 'package:reading_wucc/services/notification_service.dart';
import 'package:reading_wucc/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

    UserDatabase.getCurrentUser(userNotifier);
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    EventNotifier eventNotifier = Provider.of<EventNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: userNotifier.currentUser == null ? const Text('Hi!') : Text('Hi ${userNotifier.currentUser!.name}'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: Scaffold.of(context).openEndDrawer,
              icon: Icon(Icons.settings_outlined),
            ),
          ),
        ],
      ),
      endDrawer: CustomRightDrawer(),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.group_add),
            label: 'Join event',
            onTap: () {
              showAddEventDialogBox(context, userNotifier, eventNotifier);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_rounded),
            label: 'Create event',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEventScreen())),
          ),
        ],
      ),
      body: EventListView(),
    );
  }
}
