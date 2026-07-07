import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_app/core/constants/app_constants.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/shared/widgets/app_brand_mark.dart';
import 'package:pet_app/shared/widgets/app_top_bar.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

/// Shared layout wrapper for authentication screens.
///
/// Pass [header] to replace the default [AppBrandMark] (e.g. mailbox on OTP).
/// Set [circleBack] for the Figma-style circular back button instead of
/// the standard app bar.
class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.subtitleWidget,
    this.header,
    this.showBack = false,
    this.circleBack = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Widget? header;
  final bool showBack;
  final bool circleBack;

  @override
  Widget build(BuildContext context) {
    final useAppBar = showBack && context.canPop() && !circleBack;

    return Scaffold(
      appBar: useAppBar
          ? AppTopBar(
              title: const SizedBox.shrink(),
              showBack: true,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.authHorizontalPadding,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppConstants.authContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (circleBack && context.canPop()) ...[
                    AuthCircleBackButton(),
                    const SizedBox(height: 24),
                  ],
                  Align(
                    alignment: Alignment.center,
                    child: header ?? const AppBrandMark(),
                  ),
                  if (title != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      title!,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (subtitleWidget != null) ...[
                    const SizedBox(height: 8),
                    subtitleWidget!,
                  ] else if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: context.textTheme.bodyMedium,
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
