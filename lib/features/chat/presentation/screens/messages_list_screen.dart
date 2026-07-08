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
    this.emoji,
    this.unread = false,
  });

  final String id;
  final String name;
  final String preview;
  final String time;
  final Color avatarColor;
  final String? initials;
  final String? emoji;
  final bool unread;
}

const _green = Color(0xFF17A855);

const _chats = [
  _ChatPreview(
    id: 'hassan',
    name: 'Hassan Khan',
    preview: 'Is the Persian still avai…',
    time: '2m',
    initials: 'HK',
    avatarColor: Color(0xFF17A855),
    unread: true,
  ),
  _ChatPreview(
    id: 'farm-stables',
    name: 'Farm Stables Co.',
    preview: 'We can deliver it Satur…',
    time: '3h',
    emoji: '🐕',
    avatarColor: Color(0xFFFFF4EC),
  ),
  _ChatPreview(
    id: 'mariam',
    name: 'Mariam S.',
    preview: 'Thank you! See you S…',
    time: 'Yesterday',
    initials: 'MS',
    avatarColor: Color(0xFFD9ECFF),
  ),
  _ChatPreview(
    id: 'birds-more',
    name: 'Birds & More',
    preview: 'New arrivals this Frid…',
    time: 'Mon',
    emoji: '🐦',
    avatarColor: Color(0xFFE8EEF5),
  ),
];

/// Figma — Chat History
class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _chats.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F2F5),
                  indent: 72,
                ),
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return InkWell(
                    onTap: () =>
                        context.push(RouteNames.chatThreadPath(chat.id)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: chat.avatarColor,
                            child: chat.initials != null
                                ? Text(
                                    chat.initials!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          chat.avatarColor.computeLuminance() >
                                                  0.7
                                              ? const Color(0xFF3B82F6)
                                              : Colors.white,
                                    ),
                                  )
                                : Text(
                                    chat.emoji!,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
