import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: context.colorScheme.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: context.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
