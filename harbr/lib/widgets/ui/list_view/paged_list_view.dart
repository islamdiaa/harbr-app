import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrPagedListView<T> extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey;
  final PagingController<int, T> pagingController;
  final ScrollController scrollController;
  final void Function(int) listener;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final double? itemExtent;
  final EdgeInsetsGeometry? padding;
  final String noItemsFoundMessage;
  final Function? onRefresh;

  const HarbrPagedListView({
    Key? key,
    required this.refreshKey,
    required this.pagingController,
    required this.listener,
    required this.itemBuilder,
    required this.noItemsFoundMessage,
    required this.scrollController,
    this.onRefresh,
    this.itemExtent,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State<T>();
}

class _State<T> extends State<HarbrPagedListView<T>> {
  @override
  void initState() {
    super.initState();
    widget.pagingController
        .addPageRequestListener((pageKey) => widget.listener(pageKey));
  }

  @override
  Widget build(BuildContext context) {
    return HarbrRefreshIndicator(
      key: widget.refreshKey,
      context: context,
      onRefresh: () => Future.sync(() {
        widget.onRefresh?.call();
        widget.pagingController.refresh();
      }),
      child: Scrollbar(
        controller: widget.scrollController,
        interactive: true,
        child: PagedListView<int, T>(
          pagingController: widget.pagingController,
          scrollController: widget.scrollController,
          itemExtent: widget.itemExtent,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: widget.itemBuilder,
            firstPageErrorIndicatorBuilder: (context) => HarbrMessage.error(
                onTap: () =>
                    Future.sync(() => widget.pagingController.refresh())),
            firstPageProgressIndicatorBuilder: (context) => const HarbrLoader(),
            newPageProgressIndicatorBuilder: (context) => Padding(
              child: Container(
                alignment: Alignment.center,
                height: 48.0,
                child: const HarbrLoader(size: 16.0, useSafeArea: false),
              ),
              padding: const EdgeInsets.only(bottom: 0.0),
            ),
            newPageErrorIndicatorBuilder: (context) => const HarbrIconButton(
              icon: Icons.error_rounded,
              color: HarbrColours.red,
            ),
            noMoreItemsIndicatorBuilder: (context) => const HarbrIconButton(
              icon: Icons.check_rounded,
              color: HarbrColours.accent,
            ),
            noItemsFoundIndicatorBuilder: (context) => HarbrMessage(
              text: widget.noItemsFoundMessage,
              buttonText: 'harbr.Refresh'.tr(),
              onTap: () => Future.sync(() => widget.pagingController.refresh()),
            ),
          ),
          padding: widget.padding ??
              MediaQuery.of(context)
                  .padding
                  .copyWith(bottom: HarbrUI.MARGIN_H_DEFAULT_V_HALF.bottom)
                  .add(
                      EdgeInsets.only(top: HarbrUI.MARGIN_H_DEFAULT_V_HALF.top)),
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
