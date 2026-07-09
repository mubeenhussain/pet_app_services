import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';
import 'package:pet_app/core/l10n/l10n_helpers.dart';
import 'package:intl/intl.dart';
import 'package:pet_app/core/theme/app_colors.dart';
import 'package:pet_app/shared/widgets/auth_circle_back_button.dart';

enum _HistoryFilter { all, rides, services, housing, supplies }

enum _HistoryStatus { completed, pending, cancelled }

enum _HistoryCategory { rides, services, housing, supplies }

enum _HistoryTitle { homeGrooming, vetVisit, boarding, supplies }

class _HistoryItem {
  const _HistoryItem({
    required this.id,
    required this.titleKey,
    required this.date,
    required this.amountSar,
    required this.status,
    required this.category,
  });

  final String id;
  final _HistoryTitle titleKey;
  final DateTime date;
  final int amountSar;
  final _HistoryStatus status;
  final _HistoryCategory category;
}

/// Figma demo rows for Service History.
final _demoHistory = <_HistoryItem>[
  _HistoryItem(
    id: '1',
    titleKey: _HistoryTitle.homeGrooming,
    date: DateTime(2026, 6, 12),
    amountSar: 500,
    status: _HistoryStatus.completed,
    category: _HistoryCategory.services,
  ),
  _HistoryItem(
    id: '2',
    titleKey: _HistoryTitle.homeGrooming,
    date: DateTime(2026, 6, 12),
    amountSar: 500,
    status: _HistoryStatus.completed,
    category: _HistoryCategory.services,
  ),
  _HistoryItem(
    id: '3',
    titleKey: _HistoryTitle.vetVisit,
    date: DateTime(2026, 6, 18),
    amountSar: 2800,
    status: _HistoryStatus.pending,
    category: _HistoryCategory.services,
  ),
  _HistoryItem(
    id: '4',
    titleKey: _HistoryTitle.vetVisit,
    date: DateTime(2026, 6, 18),
    amountSar: 2800,
    status: _HistoryStatus.pending,
    category: _HistoryCategory.services,
  ),
  _HistoryItem(
    id: '5',
    titleKey: _HistoryTitle.boarding,
    date: DateTime(2026, 6, 2),
    amountSar: 6000,
    status: _HistoryStatus.completed,
    category: _HistoryCategory.housing,
  ),
  _HistoryItem(
    id: '6',
    titleKey: _HistoryTitle.supplies,
    date: DateTime(2026, 5, 28),
    amountSar: 950,
    status: _HistoryStatus.cancelled,
    category: _HistoryCategory.supplies,
  ),
];

/// BRD 6.12 — Service History (Figma)
class ServiceHistoryScreen extends ConsumerStatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  ConsumerState<ServiceHistoryScreen> createState() =>
      _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends ConsumerState<ServiceHistoryScreen> {
  _HistoryFilter _filter = _HistoryFilter.all;

  List<_HistoryItem> get _filtered {
    if (_filter == _HistoryFilter.all) return _demoHistory;
    final cat = switch (_filter) {
      _HistoryFilter.rides => _HistoryCategory.rides,
      _HistoryFilter.services => _HistoryCategory.services,
      _HistoryFilter.housing => _HistoryCategory.housing,
      _HistoryFilter.supplies => _HistoryCategory.supplies,
      _HistoryFilter.all => null,
    };
    return _demoHistory.where((e) => e.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const AuthCircleBackButton(),
                  Expanded(
                    child: Text(
                      context.l10n.serviceHistory,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: context.l10n.filterAll,
                    selected: _filter == _HistoryFilter.all,
                    onTap: () => setState(() => _filter = _HistoryFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: context.l10n.filterRides,
                    selected: _filter == _HistoryFilter.rides,
                    onTap: () => setState(() => _filter = _HistoryFilter.rides),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: context.l10n.filterServices,
                    selected: _filter == _HistoryFilter.services,
                    onTap: () =>
                        setState(() => _filter = _HistoryFilter.services),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: context.l10n.filterHousing,
                    selected: _filter == _HistoryFilter.housing,
                    onTap: () =>
                        setState(() => _filter = _HistoryFilter.housing),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: context.l10n.filterSupplies,
                    selected: _filter == _HistoryFilter.supplies,
                    onTap: () =>
                        setState(() => _filter = _HistoryFilter.supplies),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.noHistoryYet,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _HistoryCard(item: items[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _green = Color(0xFF17A855);
  static const _unselectedBg = Color(0xFFF0F1F3);
  static const _unselectedFg = Color(0xFF4B5563);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _green : _unselectedBg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : _unselectedFg,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final _HistoryItem item;

  static final _dateFormat = DateFormat('d MMM, yyyy');

  String _title(BuildContext context) {
    final l10n = context.l10n;
    return switch (item.titleKey) {
      _HistoryTitle.homeGrooming => l10n.historyHomeGrooming,
      _HistoryTitle.vetVisit => l10n.historyVetVisit,
      _HistoryTitle.boarding => l10n.historyBoarding,
      _HistoryTitle.supplies => l10n.historySupplies,
    };
  }

  @override
  Widget build(BuildContext context) {
    final visuals = _HistoryVisuals.fromItem(item);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: visuals.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(visuals.icon, color: visuals.iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(context),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateFormat.format(item.date),
                  style: const TextStyle(
                    fontSize: 12,
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
              _StatusPill(status: item.status),
              const SizedBox(height: 10),
              Text(
                context.l10n.sarAmount(item.amountSar),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final _HistoryStatus status;

  @override
  Widget build(BuildContext context) {
    // Figma: Completed = light green bg + dark green text (not solid green).
    final l10n = context.l10n;
    final (label, bg, fg) = switch (status) {
      _HistoryStatus.completed => (
          l10n.statusCompleted,
          const Color(0xFFE8F7EE),
          const Color(0xFF17A855),
        ),
      _HistoryStatus.pending => (
          l10n.statusPending,
          const Color(0xFFFFF0E0),
          const Color(0xFFE67E22),
        ),
      _HistoryStatus.cancelled => (
          l10n.statusCancelled,
          const Color(0xFFEEEEEE),
          const Color(0xFF6B7280),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _HistoryVisuals {
  const _HistoryVisuals({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  static _HistoryVisuals fromItem(_HistoryItem item) {
    if (item.status == _HistoryStatus.cancelled) {
      return const _HistoryVisuals(
        icon: Icons.close,
        iconBg: Color(0xFFF0F0F0),
        iconColor: Color(0xFF6B7280),
      );
    }
    if (item.status == _HistoryStatus.pending) {
      return const _HistoryVisuals(
        icon: Icons.access_time_rounded,
        iconBg: Color(0xFFFFF0E0),
        iconColor: Color(0xFFE67E22),
      );
    }
    if (item.category == _HistoryCategory.housing) {
      return const _HistoryVisuals(
        icon: Icons.hexagon_outlined,
        iconBg: Color(0xFFE8F7EE),
        iconColor: Color(0xFF17A855),
      );
    }
    // Grooming / completed services — Figma uses headset-style icon
    return const _HistoryVisuals(
      icon: Icons.headset_mic_outlined,
      iconBg: Color(0xFFE8F7EE),
      iconColor: Color(0xFF17A855),
    );
  }
}
