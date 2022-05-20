
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:hg_notification_firebase_example/screens/home_screen.dart';
import 'package:hg_notification_firebase_example/widgets/custom_loader.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    (() async {
      await Future.delayed(Duration.zero).then((value) => {
        Navigator.pushReplacementNamed(
        context,
        HomeScreen.id,
        )
      });

    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: CustomLoader(),
      ),
    );
  }
}