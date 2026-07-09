import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/core/router/route_names.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/features/pets/presentation/models/buy_pet_listing.dart';

const _green = Color(0xFF17A855);
const _inputBorder = Color(0xFFDDEFE2);

String _defaultMessage(BuyPetListing listing) {
  final name = listing.petName.split(RegExp(r'\s+&?\s*')).first;
  return 'Hi, I\'m interested in $name — is $name still available?';
}

/// Figma — Ask about pet bottom sheet.
Future<void> showAskAboutPetSheet(
  BuildContext context,
  BuyPetListing listing,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0xFFD4EDE0).withValues(alpha: 0.92),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: _AskAboutPetSheet(listing: listing),
    ),
  );
}

class _AskAboutPetSheet extends StatefulWidget {
  const _AskAboutPetSheet({required this.listing});

  final BuyPetListing listing;

  @override
  State<_AskAboutPetSheet> createState() => _AskAboutPetSheetState();
}

class _AskAboutPetSheetState extends State<_AskAboutPetSheet> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: _defaultMessage(widget.listing),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    navigator.pop();
    router.push(RouteNames.chatThreadPath('farm-stables'));
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final priceFormat = NumberFormat('#,###');

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE3E8),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _PetAvatar(listing: listing),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ask about ${listing.petName.split(RegExp(r'\s+&?\s*')).first}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${listing.breed} · SAR ${priceFormat.format(listing.priceSar)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'YOUR MESSAGE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: 4,
                  minLines: 4,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: _inputBorder,
                        width: 0.8,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: _green,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _sendMessage,
                style: FilledButton.styleFrom(
                  backgroundColor: _green,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({required this.listing});

  final BuyPetListing listing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Center(
          child: listing.iconAsset != null
              ? Image.asset(
                  listing.iconAsset!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                )
              : Text(
                  listing.emoji ?? '🐾',
                  style: const TextStyle(fontSize: 28, height: 1),
                ),
        ),
      ),
    );
  }
}
