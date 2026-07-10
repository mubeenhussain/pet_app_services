import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/widgets/app_feedback_banner.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

const _green = Color(0xFF17A855);
const _inputBorder = Color(0xFFDDEFE2);

class _ConversationInfo {
  const _ConversationInfo({
    required this.name,
    required this.avatarColor,
    this.initials,
    this.initialsColor,
    this.iconAsset,
    this.activeNow = false,
  });

  final String name;
  final Color avatarColor;
  final String? initials;
  final Color? initialsColor;
  final String? iconAsset;
  final bool activeNow;
}

const _conversations = <String, _ConversationInfo>{
  'hassan': _ConversationInfo(
    name: 'Hassan Khan',
    initials: 'HK',
    avatarColor: Color(0xFF17A855),
    initialsColor: Colors.white,
  ),
  'farm-stables': _ConversationInfo(
    name: 'Farm Stables Co.',
    iconAsset: 'assets/icons/pets/🐶.png',
    avatarColor: Color(0xFFFFF4EC),
  ),
  'mariam': _ConversationInfo(
    name: 'Mariam S.',
    initials: 'MS',
    avatarColor: Color(0xFFD9ECFF),
    initialsColor: Color(0xFF3B82F6),
    activeNow: true,
  ),
  'birds-more': _ConversationInfo(
    name: 'Birds & More',
    iconAsset: 'assets/icons/pets/🐦.png',
    avatarColor: Color(0xFFE8EEF5),
  ),
};

/// Figma — Chat Screen
class ChatThreadScreen extends StatelessWidget {
  const ChatThreadScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final info =
        _conversations[conversationId] ??
        _ConversationInfo(
          name: l10n.chatTitle,
          avatarColor: const Color(0xFFE8EEF5),
          initials: '?',
          initialsColor: const Color(0xFF3B82F6),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  const AuthCircleBackButton(),
                  const SizedBox(width: 8),
                  _ThreadAvatar(info: info),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (info.activeNow)
                          Text(
                            l10n.activeNow,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _green,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFFE8F7EE),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: Color(0xFF0F8A42),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.chatSafetyBanner,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F8A42),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              children: [
                _Bubble(
                  text: l10n.demoMsgKittenAvailable,
                  isMine: false,
                ),
                const SizedBox(height: 10),
                _Bubble(
                  text: l10n.demoMsgKittenReply,
                  isMine: true,
                ),
                const SizedBox(height: 10),
                _Bubble(
                  text: l10n.demoMsgKittenConfirm,
                  isMine: false,
                ),
                const SizedBox(height: 16),
                AppFeedbackBanner(
                  message: context.l10n.contactInfoWarning,
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ),
          ),
          ColoredBox(
            color: const Color(0xFFF8F9FB),
            child: SafeArea(
              top: false,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE8EAEF), width: 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: const BorderSide(
                              color: _inputBorder,
                              width: 0.8,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme:
                                  const InputDecorationTheme(
                                filled: false,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                              ),
                            ),
                            child: TextField(
                              minLines: 1,
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.typeMessage,
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                                filled: false,
                                fillColor: Colors.transparent,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const _ChatSendButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatSendButton extends StatelessWidget {
  const _ChatSendButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _green,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Center(child: _SendPlaneIcon()),
        ),
      ),
    );
  }
}

class _SendPlaneIcon extends StatelessWidget {
  const _SendPlaneIcon();

  // Material send glyph ~30°; Figma plane nose ≈ 45° up-right.
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

class _ThreadAvatar extends StatelessWidget {
  const _ThreadAvatar({required this.info});

  final _ConversationInfo info;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: info.avatarColor,
      child: info.initials != null
          ? Text(
              info.initials!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: info.initialsColor ?? Colors.white,
              ),
            )
          : Image.asset(
              info.iconAsset!,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.isMine});

  final String text;
  final bool isMine;

  // Figma Dev Mode: 16 / 16 / 16 / 1 corner radii + 8H / 16V padding.
  static const _tailRadius = Radius.circular(1);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isMine ? _green : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMine ? const Radius.circular(16) : _tailRadius,
              bottomRight: isMine ? _tailRadius : const Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.35,
                color: isMine ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
