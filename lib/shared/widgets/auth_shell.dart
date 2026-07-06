import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showBack = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBack && context.canPop()
          ? AppTopBar(
              title: const SizedBox.shrink(),
              showBack: true,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.pets,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  if (title != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 32),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
