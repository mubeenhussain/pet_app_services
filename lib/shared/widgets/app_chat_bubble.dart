import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// Chat message bubble (Figma msg-in / msg-out).
class AppChatBubble extends StatelessWidget {
  const AppChatBubble({
    super.key,
    required this.text,
    required this.isMine,
  });

  final String text;
  final bool isMine;

  static const _outgoingGreen = Color(0xFF17A855);
  static const _incomingText = Color(0xFF12201A);
  static const _largeRadius = 16.0;
  static const _tailRadius = 4.0;
  static const _fontSize = 12.5;
  static const _lineHeight = 18.75;
  static const _designScreenWidth = 390.0;
  static const _designMaxWidth = 230.0;
  static const _listHorizontalPadding = 16.0;
  static const _padding = EdgeInsets.fromLTRB(14, 10, 14, 10);

  static double maxWidthFor(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxAvailable = screenWidth - (_listHorizontalPadding * 2);
    return (screenWidth * _designMaxWidth / _designScreenWidth)
        .clamp(0, maxAvailable);
  }

  BorderRadius get _borderRadius => isMine
      ? const BorderRadius.only(
          topLeft: Radius.circular(_largeRadius),
          topRight: Radius.circular(_largeRadius),
          bottomRight: Radius.circular(_tailRadius),
          bottomLeft: Radius.circular(_largeRadius),
        )
      : const BorderRadius.only(
          topLeft: Radius.circular(_largeRadius),
          topRight: Radius.circular(_largeRadius),
          bottomRight: Radius.circular(_largeRadius),
          bottomLeft: Radius.circular(_tailRadius),
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidthFor(context),
        ),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: ColoredBox(
            color: isMine ? _outgoingGreen : AppColors.chatIncomingBubble,
            child: Padding(
              padding: _padding,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w400,
                  height: _lineHeight / _fontSize,
                  letterSpacing: 0,
                  color: isMine ? Colors.white : _incomingText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
