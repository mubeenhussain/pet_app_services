import 'package:flutter/material.dart';
import 'package:pet_app/core/theme/app_colors.dart';

/// Rounded placeholder block used in skeleton layouts.
class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeleton,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Profile screen skeleton (Figma SKELETON LOADING — PROFILE).
class AppProfileSkeleton extends StatelessWidget {
  const AppProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          const AppSkeletonBox(width: 88, height: 88, borderRadius: 44),
          const SizedBox(height: 16),
          const AppSkeletonBox(width: 140, height: 18, borderRadius: 8),
          const SizedBox(height: 8),
          const AppSkeletonBox(width: 100, height: 14, borderRadius: 8),
          const SizedBox(height: 28),
          const AppSkeletonBox(width: double.infinity, height: 48, borderRadius: 10),
          const SizedBox(height: 12),
          const AppSkeletonBox(width: double.infinity, height: 48, borderRadius: 10),
          const SizedBox(height: 12),
          const AppSkeletonBox(width: double.infinity, height: 48, borderRadius: 10),
        ],
      ),
    );
  }
}

/// Generic list-row skeleton.
class AppListSkeleton extends StatelessWidget {
  const AppListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) => const Row(
        children: [
          AppSkeletonBox(width: 48, height: 48, borderRadius: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeletonBox(width: 120, height: 14, borderRadius: 6),
                SizedBox(height: 8),
                AppSkeletonBox(width: 180, height: 12, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
