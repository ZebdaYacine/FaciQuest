import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

class AppBackDrop extends StatelessWidget {
  const AppBackDrop({
    super.key,
    this.showHeader = true,
    this.title,
    this.titleText,
    this.subtitleText,
    this.subtitle,
    this.actions,
    this.body,
    this.showDivider = true,
    this.paddingActions = const EdgeInsets.all(16),
    this.paddingBody = const EdgeInsets.only(
      top: 16,
      left: 16,
      right: 16,
      bottom: 8,
    ),
    //
    this.headerAlignment = BackdropHeaderAlignment.center,
    this.isRTL = false,
    this.showHandle = true,
    this.headerActions = BackdropHeaderActions.all,
    this.showHeaderContent = true,
    this.showTitle = true,
    this.showSubtitle = true,
  });

  final bool showHeader;
  final Widget? title;
  final Widget? subtitle;
  final EdgeInsets paddingBody;
  final EdgeInsets paddingActions;
  final String? titleText;
  final String? subtitleText;
  final Widget? body;
  final Widget? actions;

  /// header parameters
  final BackdropHeaderAlignment headerAlignment;
  final bool isRTL;
  final bool showHandle;
  final BackdropHeaderActions headerActions;
  final bool showHeaderContent;
  final bool showTitle;
  final bool showSubtitle;
  final bool showDivider;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          // color: SDSPallet.surfaceNeutralDefault.getColor(context.isDarkTheme),
          // borderRadius: 16.borderRadiusOnlyTop,
          ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHeader)
              BackdropHeader(
                title: title,
                subtitle: subtitle,
                titleText: titleText,
                subtitleText: subtitleText,
                actions: headerActions,
                alignment: headerAlignment,
                isRTL: isRTL,
                showContent: showHeaderContent,
                showHandle: showHandle,
                showSubtitle: showSubtitle,
                showTitle: showTitle,
                showDivider: showDivider,
              ),
            if (body != null)
              Flexible(
                child: Padding(
                  padding: paddingBody,
                  child: body,
                ),
              ),
            if (actions != null)
              Padding(
                padding: paddingActions,
                child: actions,
              ),
          ],
        ),
      ),
    );
  }
}

enum BackdropHeaderAlignment { center, side }

enum BackdropHeaderActions { none, all, closeOnly, backOnly }

class BackdropHeader extends StatelessWidget {
  const BackdropHeader({
    super.key,
    this.title,
    this.subtitle,
    this.titleText,
    this.subtitleText,
    this.alignment = BackdropHeaderAlignment.center,
    this.isRTL = false,
    this.showHandle = true,
    this.actions = BackdropHeaderActions.all,
    this.showContent = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showDivider = true,
  });
  final BackdropHeaderAlignment alignment;
  final bool isRTL;
  final bool showHandle;
  final BackdropHeaderActions actions;
  final bool showContent;
  final bool showTitle;
  final bool showSubtitle;
  final bool showDivider;
  final Widget? title;
  final Widget? subtitle;
  final String? titleText;
  final String? subtitleText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHandle) const HandleContainer(),
        if (showContent)
          Row(
            children: [
              16.widthBox,
              SizedBox(
                width: 48,
                height: 48,
                child: (actions == BackdropHeaderActions.all ||
                        actions == BackdropHeaderActions.backOnly)
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      )
                    : null,
              ),
              if (alignment == BackdropHeaderAlignment.center) const Spacer(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showTitle)
                      if (title != null)
                        Material(
                          color: Colors.transparent,
                          textStyle: context.textTheme.headlineLarge,
                          child: title,
                        )
                      else
                        Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              titleText ?? '',
                              style: context.textTheme.headlineLarge,
                            )),
                    if (showSubtitle)
                      if (subtitle != null)
                        Material(
                          textStyle: context.textTheme.bodyLarge,
                          child: subtitle,
                        )
                      else if (subtitleText != null)
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              subtitleText ?? '',
                              style: context.textTheme.bodyLarge,
                            )),
                  ],
                ),
              ),
              const Spacer(),
              if (actions == BackdropHeaderActions.all ||
                  actions == BackdropHeaderActions.closeOnly)
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                )
              else
                const SizedBox(
                  width: 48,
                  height: 48,
                ),
              16.widthBox,
            ],
          ),
        if (showDivider)
          const Divider(
            height: 0,
          ),
      ],
    );
  }
}

class HandleContainer extends StatelessWidget {
  const HandleContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Spacer(),
          Container(
            width: 72,
            height: 4,
            decoration: ShapeDecoration(
              color: const Color(0xFFEDEAF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
