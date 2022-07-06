import 'package:reading_wucc/models/models.dart';
import 'package:reading_wucc/notifiers/notifiers.dart';
import 'package:reading_wucc/services/services.dart';

Future<String> addEventToUser(UserNotifier userNotifier, EventNotifier eventNotifier, String code) async {
  // Get current User ID
  String userID = AuthService.getCurrentUserUID();

  // Get household
  Event? event = await EventDatabase.readEventFromCode(eventNotifier, code);
  AppUser? user = userNotifier.currentUser;

  if (user != null && event != null) {
    if (user.events.contains(event.uid)) {
      return 'Already part of event.';
    }
    // Update user
    user.events.add(event.uid!);
    await UserDatabase.updateUser(userNotifier, user);

    // Update event
    event.members.add(userID);
    await EventDatabase.updateEvent(eventNotifier, event);

    return event.name;
  }

  return '';
}
