import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// Reusable chat composer bar (Figma: 388×81, top border 0.8px #DDEFE2).
class AppChatInputBar extends StatelessWidget {
  const AppChatInputBar({
    super.key,
    required this.hintText,
    this.onSend,
    this.controller,
  });

  final String hintText;
  final VoidCallback? onSend;
  final TextEditingController? controller;

  static const _designScreenWidth = 390.0;
  static const _designBarHeight = 81.0;
  static const _inputHeight = 44.0;
  static const _inputRadius = 10.0;
  static const _sendSize = 44.0;
  static const _horizontalPadding = 16.0;
  static const _sendGreen = Color(0xFF17A855);

  static double barHeightFor(double screenWidth) =>
      (screenWidth * _designBarHeight / _designScreenWidth).clamp(72.0, 81.0);

  @override
  Widget build(BuildContext context) {
    final barHeight = barHeightFor(MediaQuery.sizeOf(context).width);
    final verticalPadding =
        ((barHeight - _inputHeight) / 2).clamp(14.0, 20.0);

    return ColoredBox(
      color: AppColors.chatBarBg,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.inputBorder,
                width: 0.8,
              ),
            ),
          ),
          child: SizedBox(
            height: barHeight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                _horizontalPadding,
                verticalPadding,
                _horizontalPadding,
                verticalPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _ChatTextField(hintText: hintText, controller: controller)),
                  const SizedBox(width: 10),
                  _ChatSendButton(onSend: onSend),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatTextField extends StatelessWidget {
  const _ChatTextField({
    required this.hintText,
    this.controller,
  });

  final String hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppChatInputBar._inputHeight,
      child: Material(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppChatInputBar._inputRadius),
          side: const BorderSide(
            color: AppColors.inputBorder,
            width: 0.8,
          ),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatSendButton extends StatelessWidget {
  const _ChatSendButton({this.onSend});

  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppChatInputBar._sendGreen,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onSend,
        child: const SizedBox(
          width: AppChatInputBar._sendSize,
          height: AppChatInputBar._sendSize,
          child: Center(child: _SendPlaneIcon()),
        ),
      ),
    );
  }
}

class _SendPlaneIcon extends StatelessWidget {
  const _SendPlaneIcon();

  static const _figmaTiltCorrection = -0.60;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(1.5, -0.5),
      child: Transform.rotate(
        angle: _figmaTiltCorrection,
        child: const Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
