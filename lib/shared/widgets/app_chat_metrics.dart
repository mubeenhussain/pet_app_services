import 'package:flutter/material.dart';

/// Shared horizontal spacing for the chat thread screen.
abstract final class AppChatMetrics {
  AppChatMetrics._();

  static const designScreenWidth = 390.0;
  static const designHorizontalPadding = 16.0;
  static const designComposerHorizontalPadding = 40.0;
  static const designBarHeight = 88.0;
  static const designInputHeight = 44.0;
  static const designComposerTopMargin = 24.0;
  static const designScreenTopMargin = 16.0;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width * designHorizontalPadding / designScreenWidth;
  }

  static double composerHorizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width * designComposerHorizontalPadding / designScreenWidth;
  }

  static double composerContainerTopMargin(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width * designComposerTopMargin / designScreenWidth;
  }

  static double screenTopMargin(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width * designScreenTopMargin / designScreenWidth;
  }

  static EdgeInsets screenHorizontalPadding(BuildContext context) {
    final horizontal = horizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  static EdgeInsets threadHeaderPadding(BuildContext context) {
    final horizontal = horizontalPadding(context);
    final top = screenTopMargin(context);
    return EdgeInsets.fromLTRB(horizontal, top, horizontal, 8);
  }

  static EdgeInsets messageListVerticalPadding(BuildContext context) =>
      const EdgeInsets.fromLTRB(0, 8, 0, 16);

  /// Inner spacing for the bottom composer section (input + send button).
  static EdgeInsets composerSectionPadding(BuildContext context) {
    final horizontal = composerHorizontalPadding(context);
    final width = MediaQuery.sizeOf(context).width;
    final barHeight =
        (width * designBarHeight / designScreenWidth).clamp(80.0, 88.0);
    final inputHeight =
        (width * designInputHeight / designScreenWidth).clamp(40.0, 44.0);
    final vertical = ((barHeight - inputHeight) / 2).clamp(18.0, 24.0);
    return EdgeInsets.fromLTRB(horizontal, vertical, horizontal, vertical);
  }
}
