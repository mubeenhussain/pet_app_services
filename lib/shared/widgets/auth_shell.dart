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
    this.footer,
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
  final Widget? footer;
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
        child: Stack(
          children: [
            _body(context, horizontal),
            if (circleBack && context.canPop())
              Positioned(
                top: 8,
                left: horizontal,
                child: const AuthCircleBackButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, double horizontal) {
    const bottomPadding = 24.0;
    final topPadding = circleBack ? 72.0 : 24.0;
    // Screens flagged [alignTop] (OTP, register) start from the top; others
    // (login, forgot-password) are vertically centered in the available space.
    final alignment = alignTop ? Alignment.topCenter : Alignment.center;

    final scroll = LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.fromLTRB(horizontal, topPadding, horizontal, bottomPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - topPadding - bottomPadding,
            ),
            child: Align(
              alignment: alignment,
              child: _buildContent(context),
            ),
          ),
        );
      },
    );

    // Footer pinned to the bottom, content fills/centres above it.
    if (footer != null) {
      return Column(
        children: [
          Expanded(child: scroll),
          Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 16),
            child: footer,
          ),
        ],
      );
    }

    return scroll;
  }
}
