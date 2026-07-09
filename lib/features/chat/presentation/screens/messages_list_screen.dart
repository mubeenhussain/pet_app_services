import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

class _ChatPreview {
  const _ChatPreview({
    required this.id,
    required this.name,
    required this.avatarColor,
    this.initials,
    this.initialsColor,
    this.iconAsset,
    this.unread = false,
  });

  final String id;
  final String name;
  final Color avatarColor;
  final String? initials;
  final Color? initialsColor;
  final String? iconAsset;
  final bool unread;
}

const _green = Color(0xFF17A855);
const _screenBg = Color(0xFFF8F9FB);

const _chats = [
  _ChatPreview(
    id: 'hassan',
    name: 'Hassan Khan',
    initials: 'HK',
    avatarColor: Color(0xFF17A855),
    initialsColor: Colors.white,
    unread: true,
  ),
  _ChatPreview(
    id: 'farm-stables',
    name: 'Farm Stables Co.',
    iconAsset: 'assets/icons/pets/🐶.png',
    avatarColor: Color(0xFFFFF4EC),
  ),
  _ChatPreview(
    id: 'mariam',
    name: 'Mariam S.',
    initials: 'MS',
    avatarColor: Color(0xFFD9ECFF),
    initialsColor: Color(0xFF3B82F6),
  ),
  _ChatPreview(
    id: 'birds-more',
    name: 'Birds & More',
    iconAsset: 'assets/icons/pets/🐦.png',
    avatarColor: Color(0xFFE8EEF5),
  ),
];

/// Figma — Chat History
class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  static const _cardRadius = 20.0;

  String _previewFor(BuildContext context, String id) {
    final l10n = context.l10n;
    return switch (id) {
      'hassan' => l10n.previewPersianAvailable,
      'farm-stables' => l10n.previewDeliverSaturday,
      'mariam' => l10n.previewThankYouSaturday,
      'birds-more' => l10n.previewNewArrivalsFriday,
      _ => '',
    };
  }

  String _timeFor(BuildContext context, String id) {
    final l10n = context.l10n;
    return switch (id) {
      'hassan' => '2m',
      'farm-stables' => '3h',
      'mariam' => l10n.timeYesterday,
      'birds-more' => l10n.timeMonday,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const AuthCircleBackButton(),
                  Expanded(
                    child: Text(
                      context.l10n.messages,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_cardRadius),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _chats.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F2F5),
                        indent: 76,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final chat = _chats[index];
                        return InkWell(
                          onTap: () =>
                              context.push(RouteNames.chatThreadPath(chat.id)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            child: Row(
                              children: [
                                _ChatAvatar(chat: chat),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _previewFor(context, chat.id),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _timeFor(context, chat.id),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (chat.unread) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: _green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({required this.chat});

  final _ChatPreview chat;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: chat.avatarColor,
      child: chat.initials != null
          ? Text(
              chat.initials!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: chat.initialsColor ?? Colors.white,
              ),
            )
          : Image.asset(
              chat.iconAsset!,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
    );
  }
}
