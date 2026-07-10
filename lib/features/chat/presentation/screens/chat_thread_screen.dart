import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/widgets/app_chat_input_bar.dart';
import 'package:pet_app/shared/widgets/app_feedback_banner.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

// Figma chat screen tokens.
const _green = Color(0xFF17A855);
const _bubbleRadius = 12.0;

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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.link,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                Center(
                  child: AppFeedbackBanner(
                    message: l10n.chatSafetyBanner,
                    variant: AppFeedbackVariant.chatSafety,
                    layout: AppFeedbackLayout.compact,
                  ),
                ),
                const SizedBox(height: 16),
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
                Center(
                  child: AppFeedbackBanner(
                    message: l10n.contactInfoWarning,
                    variant: AppFeedbackVariant.chatWarning,
                    layout: AppFeedbackLayout.compact,
                  ),
                ),
              ],
            ),
          ),
          AppChatInputBar(hintText: l10n.typeMessage),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isMine ? _green : AppColors.chatIncomingBubble,
            borderRadius: BorderRadius.circular(_bubbleRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
