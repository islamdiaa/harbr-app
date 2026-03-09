import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class NotEnabledPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String module;

  NotEnabledPage({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: HarbrAppBar(title: module),
      body: HarbrMessage.moduleNotEnabled(
        context: context,
        module: module,
      ),
    );
  }
}
