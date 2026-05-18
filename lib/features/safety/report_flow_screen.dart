import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/paper_card.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../components/stickers/sticker_image.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';

class ReportFlowScreen extends StatefulWidget {
  const ReportFlowScreen({super.key});

  @override
  State<ReportFlowScreen> createState() => _ReportFlowScreenState();
}

class _ReportFlowScreenState extends State<ReportFlowScreen> {
  String? selectedReason;
  bool alsoBlock = false;

  @override
  Widget build(BuildContext context) {
    return OpposeScreen(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const Expanded(
              child: OpposeHeader(
                title: 'Report a problem',
                subtitle: 'Tell us what happened.',
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
        for (final reason in _reasons) ...[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => setState(() => selectedReason = reason),
            child: PaperCard(
              color: selectedReason == reason
                  ? OpposeColors.mint.withValues(alpha: 0.22)
                  : OpposeColors.paper,
              borderColor: selectedReason == reason
                  ? OpposeColors.mint
                  : OpposeColors.warmBorder,
              child: Row(
                children: [
                  Icon(
                    selectedReason == reason
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selectedReason == reason
                        ? OpposeColors.maroon
                        : OpposeColors.mutedGray,
                  ),
                  const SizedBox(width: OpposeSpacing.md),
                  Expanded(child: Text(reason)),
                ],
              ),
            ),
          ),
          const SizedBox(height: OpposeSpacing.sm),
        ],
        const SizedBox(height: OpposeSpacing.md),
        const OpposeTextInput(label: 'Optional note', maxLines: 3),
        const SizedBox(height: OpposeSpacing.md),
        SwitchListTile(
          title: const Text('Also block this user'),
          value: alsoBlock,
          activeThumbColor: OpposeColors.maroon,
          onChanged: (value) => setState(() => alsoBlock = value),
        ),
        const SizedBox(height: OpposeSpacing.md),
        const PaperCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.favorite_rounded),
            title: Text('Your safety comes first'),
            subtitle: Text('You can leave or mute anytime.'),
          ),
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Submit report',
          onPressed: selectedReason == null
              ? null
              : () => context.go(AppRoutes.home),
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Cancel',
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}

const _reasons = <String>[
  'Harassment',
  'Spam',
  'Unsafe behavior',
  'Hate or discrimination',
  'Privacy concern',
  'Other',
];
