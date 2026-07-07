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
/// Set [circleBack] for the Figma-style circular back button pinned top-left.
/// Set [alignTop] to keep content at the top (OTP) instead of vertically centered.
class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.subtitleWidget,
    this.header,
    this.showBrand = true,
    this.showBack = false,
    this.circleBack = false,
    this.alignTop = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Widget? header;
  final bool showBrand;
  final bool showBack;
  final bool circleBack;
  final bool alignTop;

  Widget _buildContent(BuildContext context) {
    final headerWidget = header ?? (showBrand ? const AppBrandMark() : null);

    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxWidth: AppConstants.authContentWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (headerWidget != null)
            Align(alignment: Alignment.center, child: headerWidget),
          if (title != null) ...[
            SizedBox(height: headerWidget != null ? 20 : 0),
            Text(
              title!,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.heading,
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
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useAppBar = showBack && context.canPop() && !circleBack;
    final horizontal = AppConstants.authHorizontalPadding;

    return Scaffold(
      appBar: useAppBar
          ? AppTopBar(
              title: const SizedBox.shrink(),
              showBack: true,
            )
          : null,
      body: SafeArea(
        child: circleBack
            ? Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(horizontal, 64, horizontal, 24),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _buildContent(context),
                    ),
                  ),
                  if (context.canPop())
                    Positioned(
                      top: 8,
                      left: horizontal,
                      child: const AuthCircleBackButton(),
                    ),
                ],
              )
            : alignTop
                ? SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontal,
                      vertical: 24,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _buildContent(context),
                    ),
                  )
                : Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontal,
                        vertical: 24,
                      ),
                      child: _buildContent(context),
                    ),
                  ),
      ),
    );
  }
}
