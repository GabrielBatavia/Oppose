import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/room_setup/room_setup_controller.dart';
import '../../state/room_setup/room_setup_scope.dart';
import '../../state/room_summary/room_summary_controller.dart';
import '../../state/room_summary/room_summary_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class RoomSummaryScreen extends StatefulWidget {
  const RoomSummaryScreen({super.key});

  @override
  State<RoomSummaryScreen> createState() => _RoomSummaryScreenState();
}

class _RoomSummaryScreenState extends State<RoomSummaryScreen> {
  bool _trackedViewed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_trackedViewed) return;
    _trackedViewed = true;
    final setup = RoomSetupScope.read(context);
    final summary = RoomSummaryScope.read(context);
    summary.prepareFor(setup);
    summary.trackViewedOnce(setup);
  }

  @override
  Widget build(BuildContext context) {
    final setup = RoomSetupScope.watch(context);
    final controller = RoomSummaryScope.watch(context);
    final summary = controller.buildSummary(setup);
    final hasSummary = controller.hasSummary(setup) && !controller.isDeleted;

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        OpposeHeader(
          title: 'Room Summary',
          subtitle: hasSummary
              ? '${summary.title} - ${summary.durationLabel}'
              : '${setup.roomTitle} - summary not saved',
          trailing: AIStatusPill(
            status: hasSummary ? AIStatusValue.summarizing : AIStatusValue.off,
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        _SummaryHeroCard(
          summary: summary,
          setup: setup,
          hasSummary: hasSummary,
        ),
        const SizedBox(height: OpposeSpacing.lg),
        if (controller.actionMessage != null) ...[
          _ActionMessageCard(message: controller.actionMessage!),
          const SizedBox(height: OpposeSpacing.lg),
        ],
        if (hasSummary) ...[
          _SummarySection(
            title: 'Main takeaways',
            icon: Icons.sticky_note_2_outlined,
            color: OpposeColors.sunflower,
            items: summary.takeaways,
          ),
          _SummarySection(
            title: 'Best arguments',
            icon: Icons.balance_rounded,
            color: OpposeColors.mint,
            items: summary.bestArguments,
          ),
          _SummarySection(
            title: 'Funny moments',
            icon: Icons.celebration_outlined,
            color: OpposeColors.maroon,
            items: summary.funnyMoments,
          ),
          _SummarySection(
            title: 'Open questions',
            icon: Icons.help_outline_rounded,
            color: OpposeColors.indigo,
            items: summary.openQuestions,
          ),
          _SummaryVisibilityCard(
            summary: summary,
            setup: setup,
            controller: controller,
          ),
          const SizedBox(height: OpposeSpacing.xl),
          _SummaryActions(controller: controller, setup: setup),
        ] else ...[
          _SummaryOffCard(setup: setup, controller: controller),
          const SizedBox(height: OpposeSpacing.xl),
          PrimaryButton(
            label: 'Back to home',
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ],
    );
  }
}

class _SummaryHeroCard extends StatelessWidget {
  const _SummaryHeroCard({
    required this.summary,
    required this.setup,
    required this.hasSummary,
  });

  final RoomSummary summary;
  final RoomSetupController setup;
  final bool hasSummary;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.paper,
      borderColor: OpposeColors.sunflower,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StickerImage(asset: OpposeAssets.roomSummaryBima, size: 92),
              const SizedBox(width: OpposeSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasSummary ? 'Saved room notes' : 'Summary was off',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: OpposeSpacing.sm),
                    Text(
                      summary.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: OpposeSpacing.sm),
                    Text(
                      hasSummary
                          ? 'A warm recap of what happened, what felt strongest, and what to ask next.'
                          : 'No AI summary was generated for this room.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill(
                label: setup.selectedRoomType.label,
                icon: Icons.style_rounded,
                color: OpposeColors.maroon,
              ),
              StatusPill(
                label: setup.selectedAIMode.roomLabel,
                icon: setup.selectedAIMode == AIMode.off
                    ? Icons.power_settings_new_rounded
                    : Icons.smart_toy_rounded,
                color: setup.selectedAIMode == AIMode.off
                    ? OpposeColors.mutedGray
                    : OpposeColors.indigo,
              ),
              StatusPill(
                label: 'Summary: ${setup.selectedSummarySetting.roomLabel}',
                icon: setup.selectedSummarySetting == SummarySetting.off
                    ? Icons.do_not_disturb_on_outlined
                    : Icons.lock_outline_rounded,
                color: setup.selectedSummarySetting == SummarySetting.off
                    ? OpposeColors.mutedGray
                    : OpposeColors.success,
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.lg),
          Text('Topic', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: OpposeSpacing.sm),
          Text(
            setup.effectiveTopic,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (hasSummary) ...[
            const SizedBox(height: OpposeSpacing.sm),
            Text(
              summary.durationLabel,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: OpposeColors.mutedGray),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OpposeSpacing.md),
      child: PaperCard(
        color: color.withValues(alpha: 0.12),
        borderColor: color.withValues(alpha: 0.42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill(label: title, icon: icon, color: color),
            const SizedBox(height: OpposeSpacing.md),
            for (final item in items) _SummaryBullet(text: item),
          ],
        ),
      ),
    );
  }
}

class _SummaryBullet extends StatelessWidget {
  const _SummaryBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OpposeSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 7, color: OpposeColors.maroon),
          ),
          const SizedBox(width: OpposeSpacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _SummaryVisibilityCard extends StatelessWidget {
  const _SummaryVisibilityCard({
    required this.summary,
    required this.setup,
    required this.controller,
  });

  final RoomSummary summary;
  final RoomSetupController setup;
  final RoomSummaryController controller;

  @override
  Widget build(BuildContext context) {
    final shared =
        controller.isShared ||
        setup.selectedSummarySetting == SummarySetting.sharedWithRoom;

    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              shared ? Icons.groups_rounded : Icons.lock_outline_rounded,
              color: shared ? OpposeColors.indigo : OpposeColors.success,
            ),
            title: Text(summary.visibility),
            subtitle: const Text(
              'You control save, share, and delete actions. Memory remains off.',
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill(
                label: controller.isSaved ? 'Saved' : 'Not saved yet',
                icon: controller.isSaved
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_outline_rounded,
                color: controller.isSaved
                    ? OpposeColors.success
                    : OpposeColors.mutedGray,
              ),
              StatusPill(
                label: shared ? 'Shared with room' : 'Private to you',
                icon: shared ? Icons.groups_rounded : Icons.person_rounded,
                color: shared ? OpposeColors.indigo : OpposeColors.maroon,
              ),
              const StatusPill(
                label: 'Memory Off',
                icon: Icons.lock_outline_rounded,
                color: OpposeColors.mutedGray,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryActions extends StatelessWidget {
  const _SummaryActions({required this.controller, required this.setup});

  final RoomSummaryController controller;
  final RoomSetupController setup;

  @override
  Widget build(BuildContext context) {
    final alreadyShared =
        controller.isShared ||
        setup.selectedSummarySetting == SummarySetting.sharedWithRoom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: controller.isSaved ? 'Saved' : 'Save summary',
          onPressed: controller.isSaved
              ? null
              : () => controller.saveSummary(setup),
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: alreadyShared ? 'Shared with room' : 'Share with room',
          onPressed: alreadyShared
              ? null
              : () => controller.shareSummary(setup),
        ),
        const SizedBox(height: OpposeSpacing.md),
        DangerButton(
          label: 'Delete summary',
          onPressed: () => controller.deleteSummary(setup),
        ),
      ],
    );
  }
}

class _ActionMessageCard extends StatelessWidget {
  const _ActionMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.mint.withValues(alpha: 0.16),
      borderColor: OpposeColors.mint,
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: OpposeColors.success),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _SummaryOffCard extends StatelessWidget {
  const _SummaryOffCard({required this.setup, required this.controller});

  final RoomSetupController setup;
  final RoomSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.indigo.withValues(alpha: 0.08),
      borderColor: OpposeColors.indigo.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusPill(
            label: 'No summary generated',
            icon: Icons.do_not_disturb_on_outlined,
            color: OpposeColors.mutedGray,
          ),
          const SizedBox(height: OpposeSpacing.md),
          Text(
            setup.selectedSummarySetting == SummarySetting.off
                ? 'You chose Summary Off before joining. Oppose did not create room notes.'
                : 'This summary has been deleted. You can go back home or start another room.',
          ),
          if (controller.isDeleted) ...[
            const SizedBox(height: OpposeSpacing.md),
            const Text(
              'Deleted summaries are not shown again in this mock session.',
            ),
          ],
        ],
      ),
    );
  }
}
