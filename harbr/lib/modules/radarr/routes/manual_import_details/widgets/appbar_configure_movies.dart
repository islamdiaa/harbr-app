import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrManualImportDetailsConfigureMoviesSearchBar extends StatefulWidget
    implements PreferredSizeWidget {
  const RadarrManualImportDetailsConfigureMoviesSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(HarbrTextInputBar.defaultAppBarHeight);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrManualImportDetailsConfigureMoviesSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      Consumer<RadarrManualImportDetailsTileState>(
        builder: (context, state, _) => SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: HarbrTextInputBar(
                  controller: _controller,
                  autofocus: false,
                  onChanged: (value) => context
                      .read<RadarrManualImportDetailsTileState>()
                      .configureMoviesSearchQuery = value,
                  margin: HarbrTextInputBar.appBarMargin,
                ),
              ),
            ],
          ),
          height: HarbrTextInputBar.defaultAppBarHeight,
        ),
      );
}
