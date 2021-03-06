import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_wucc/models/member.dart';
import 'package:reading_wucc/notifiers/notifiers.dart';
import 'package:reading_wucc/services/event_database.dart';
import 'package:reading_wucc/support/theme.dart';

class MemberTile extends StatefulWidget {
  final Member member;
  const MemberTile({Key? key, required this.member}) : super(key: key);

  @override
  State<MemberTile> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberTile> {
  bool _value = false;
  bool _disabled = false;
  @override
  void initState() {
    super.initState();

    EventNotifier eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

    _value = eventNotifier.currentEvent!.admins.contains(widget.member.uid);
    _disabled = widget.member.uid == userNotifier.currentUser!.uid;
  }

  Future _udpateUserLevel(EventNotifier eventNotifier, bool admin) async {
    if (admin) {
      await EventDatabase.addAdmin(eventNotifier, widget.member.uid);
    } else {
      await EventDatabase.removeAdmin(eventNotifier, widget.member.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    EventNotifier eventNotifier = Provider.of<EventNotifier>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: MyColors.lightBlueColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.member.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            _disabled
                ? const SizedBox()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Admin?',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 28,
                        width: 50,
                        child: Switch(
                          value: _value,
                          onChanged: (value) async {
                            await _udpateUserLevel(eventNotifier, value);
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
