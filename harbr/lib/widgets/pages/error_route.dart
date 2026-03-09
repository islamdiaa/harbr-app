import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui.dart';

class ErrorRoutePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Exception? exception;

  ErrorRoutePage({
    Key? key,
    this.exception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: HarbrAppBar(
        title: 'Harbr',
        scrollControllers: const [],
      ),
      body: HarbrMessage.goBack(
        context: context,
        text: exception?.toString() ?? '404: Not Found',
      ),
    );
  }
}
