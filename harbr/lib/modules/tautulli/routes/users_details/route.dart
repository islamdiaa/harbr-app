import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class UserDetailsRoute extends StatefulWidget {
  final int? userId;

  const UserDetailsRoute({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<UserDetailsRoute> with HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HarbrPageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = HarbrPageController(
      initialPage: TautulliDatabase.NAVIGATION_INDEX_USER_DETAILS.read(),
    );
  }

  @override
  Future<void> loadCallback() async {
    context.read<TautulliState>().resetUsers();
    await context.read<TautulliState>().users;
  }

  TautulliTableUser? _findUser(TautulliUsersTable users) {
    if (widget.userId == null) return null;

    return users.users!.firstWhereOrNull(
      (user) => user.userId == widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId == null) {
      return InvalidRoutePage(
        title: 'User Details',
        message: 'User Not Found',
      );
    }

    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.TAUTULLI,
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body,
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'User Details',
      pageController: _pageController,
      scrollControllers: TautulliUserDetailsNavigationBar.scrollControllers,
    );
  }

  Widget _bottomNavigationBar() =>
      TautulliUserDetailsNavigationBar(pageController: _pageController);

  Widget get _body => Selector<TautulliState, Future<TautulliUsersTable>>(
        selector: (_, state) => state.users!,
        builder: (context, future, _) => FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<TautulliUsersTable> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting)
                HarbrLogger().error(
                  'Unable to pull Tautulli user table',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              return HarbrMessage.error(onTap: loadCallback);
            }
            if (snapshot.hasData) {
              TautulliTableUser? user = _findUser(snapshot.data!);
              if (user == null)
                return HarbrMessage.goBack(
                  context: context,
                  text: 'User Not Found',
                );
              return _page(user);
            }
            return const HarbrLoader();
          },
        ),
      );

  Widget _page(TautulliTableUser user) {
    return HarbrPageView(
      controller: _pageController,
      children: [
        TautulliUserDetailsProfile(user: user),
        TautulliUserDetailsHistory(user: user),
        TautulliUserDetailsSyncedItems(user: user),
        TautulliUserDetailsIPAddresses(user: user),
      ],
    );
  }
}
