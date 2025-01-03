import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HowItWorksView extends StatelessWidget {
  const HowItWorksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.menu.how_it_works'.tr()),
      ),
    );
  }
}
