import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../state/safety/safety_controller.dart';
import '../../state/safety/safety_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class ReportFlowScreen extends StatelessWidget {
  const ReportFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safety = SafetyScope.watch(context);

    return OpposeScreen(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Back to safety source',
              onPressed: () => context.go(safety.returnRoute),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            Expanded(
              child: OpposeHeader(
                title: safety.submitted
                    ? 'Report submitted'
                    : safety.reportTitle(),
                subtitle: safety.submitted
                    ? 'Thanks for helping keep Oppose kind.'
                    : 'Tell us what happened. Reports are private.',
                showLogo: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const Center(
          child: StickerImage(asset: OpposeAssets.reportShield, size: 108),
        ),
        const SizedBox(height: OpposeSpacing.lg),
        if (safety.submitted)
          _ReportConfirmation(safety: safety)
        else
          _ReportForm(safety: safety),
      ],
    );
  }
}

class _ReportForm extends StatelessWidget {
  const _ReportForm({required this.safety});

  final SafetyController safety;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TargetContextCard(target: safety.target),
        const SizedBox(height: OpposeSpacing.lg),
        Text('Choose a reason', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        for (final reason in ReportReason.values) ...[
          _ReportReasonCard(
            reason: reason,
            selected: safety.selectedReason == reason,
            onTap: () => safety.selectReason(reason),
          ),
          const SizedBox(height: OpposeSpacing.sm),
        ],
        const SizedBox(height: OpposeSpacing.md),
        OpposeTextInput(
          label: 'Optional note',
          hintText: 'Add helpful context if you want.',
          maxLines: 3,
          onChanged: safety.setDetails,
        ),
        if (safety.target.isUser) ...[
          const SizedBox(height: OpposeSpacing.md),
          SwitchListTile(
            title: Text('Also block ${safety.target.displayName}'),
            subtitle: const Text(
              'Local demo block: direct messages are disabled on this device.',
            ),
            value: safety.alsoBlock,
            activeThumbColor: OpposeColors.maroon,
            onChanged: safety.setAlsoBlock,
          ),
        ],
        const SizedBox(height: OpposeSpacing.md),
        const _SafetyExplainerCard(),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Submit report',
          onPressed: safety.canSubmit ? safety.submitReport : null,
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Cancel',
          onPressed: () => context.go(safety.returnRoute),
        ),
      ],
    );
  }
}

class _TargetContextCard extends StatelessWidget {
  const _TargetContextCard({required this.target});

  final ReportTarget target;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.sunflower.withValues(alpha: 0.14),
      borderColor: OpposeColors.sunflower,
      child: Row(
        children: [
          Icon(_targetIcon(target.type), color: OpposeColors.maroon),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reporting',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: OpposeSpacing.xs),
                Text(_targetLabel(target)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _targetIcon(ReportTargetType type) => switch (type) {
    ReportTargetType.user => Icons.person_off_outlined,
    ReportTargetType.room => Icons.graphic_eq_rounded,
    ReportTargetType.chat => Icons.chat_bubble_outline_rounded,
    ReportTargetType.general => Icons.shield_outlined,
  };

  String _targetLabel(ReportTarget target) => switch (target.type) {
    ReportTargetType.user => target.displayName,
    ReportTargetType.room => target.displayName,
    ReportTargetType.chat => target.displayName,
    ReportTargetType.general => 'A general safety concern',
  };
}

class _ReportReasonCard extends StatelessWidget {
  const _ReportReasonCard({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final ReportReason reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: PaperCard(
        color: selected
            ? OpposeColors.mint.withValues(alpha: 0.22)
            : OpposeColors.paper,
        borderColor: selected ? OpposeColors.mint : OpposeColors.warmBorder,
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? OpposeColors.maroon : OpposeColors.mutedGray,
            ),
            const SizedBox(width: OpposeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reason.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: OpposeSpacing.xs),
                  Text(reason.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyExplainerCard extends StatelessWidget {
  const _SafetyExplainerCard();

  @override
  Widget build(BuildContext context) {
    return const PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(
            label: 'Private report',
            icon: Icons.lock_outline_rounded,
            color: OpposeColors.indigo,
          ),
          SizedBox(height: OpposeSpacing.md),
          Text(
            'Your safety comes first. You can leave, mute, or block anytime.',
          ),
          SizedBox(height: OpposeSpacing.sm),
          Text(
            'This demo build uses local mock state only. No report is sent to a backend yet.',
          ),
        ],
      ),
    );
  }
}

class _ReportConfirmation extends StatelessWidget {
  const _ReportConfirmation({required this.safety});

  final SafetyController safety;

  @override
  Widget build(BuildContext context) {
    final blocked = safety.target.isUser && safety.isBlocked(safety.target.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaperCard(
          color: OpposeColors.mint.withValues(alpha: 0.16),
          borderColor: OpposeColors.mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusPill(
                label: 'Report submitted',
                icon: Icons.check_circle_rounded,
                color: OpposeColors.success,
              ),
              const SizedBox(height: OpposeSpacing.md),
              Text(
                'We recorded your ${safety.selectedReason?.label.toLowerCase() ?? 'safety'} report for ${safety.target.displayName}.',
              ),
              if (blocked) ...[
                const SizedBox(height: OpposeSpacing.sm),
                Text(
                  '${safety.target.displayName} is blocked in this local demo session.',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const PaperCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.favorite_rounded),
            title: Text('What happens next'),
            subtitle: Text(
              'A real version would send this to moderation. For now, the app keeps the mock safety state visible.',
            ),
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Back to safety source',
          onPressed: () => context.go(safety.returnRoute),
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Go home',
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}
