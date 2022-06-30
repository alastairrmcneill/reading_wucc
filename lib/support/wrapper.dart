import 'package:flutter/material.dart';
import 'package:reading_wucc/models/models.dart';
import 'package:provider/provider.dart';
import 'package:reading_wucc/home/screens/screens.dart';
import 'package:reading_wucc/authentication/screens/screens.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return const WelcomeScreen();
    } else {
      return const HomeScreen();
    }
  }
}
