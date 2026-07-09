import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

class _ChatPreview {
  const _ChatPreview({
    required this.id,
    required this.name,
    required this.preview,
    required this.time,
    required this.avatarColor,
    this.initials,
    this.initialsColor,
    this.iconAsset,
    this.unread = false,
  });

  final String id;
  final String name;
  final String preview;
  final String time;
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
    preview: 'Is the Persian still avai…',
    time: '2m',
    initials: 'HK',
    avatarColor: Color(0xFF17A855),
    initialsColor: Colors.white,
    unread: true,
  ),
  _ChatPreview(
    id: 'farm-stables',
    name: 'Farm Stables Co.',
    preview: 'We can deliver it Satur…',
    time: '3h',
    iconAsset: 'assets/icons/pets/🐶.png',
    avatarColor: Color(0xFFFFF4EC),
  ),
  _ChatPreview(
    id: 'mariam',
    name: 'Mariam S.',
    preview: 'Thank you! See you S…',
    time: 'Yesterday',
    initials: 'MS',
    avatarColor: Color(0xFFD9ECFF),
    initialsColor: Color(0xFF3B82F6),
  ),
  _ChatPreview(
    id: 'birds-more',
    name: 'Birds & More',
    preview: 'New arrivals this Frid…',
    time: 'Mon',
    iconAsset: 'assets/icons/pets/🐦.png',
    avatarColor: Color(0xFFE8EEF5),
  ),
];

/// Figma — Chat History
class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  static const _cardRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  AuthCircleBackButton(),
                  Expanded(
                    child: Text(
                      'Messages',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
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
                                        chat.preview,
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
                                      chat.time,
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
