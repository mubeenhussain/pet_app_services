import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App bar with an explicit back button when [showBack] and navigation can pop.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
  });

  final Widget title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();

    return AppBar(
      title: title,
      actions: actions,
      automaticallyImplyLeading: false,
      leading: showBack && canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack ?? () => context.pop(),
            )
          : null,
    );
  }
}
