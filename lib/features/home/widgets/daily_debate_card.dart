import 'package:flutter/material.dart';

import '../../../components/core/paper_card.dart';
import '../../../components/core/status_pill.dart';
import '../../../components/stickers/sticker_image.dart';
import '../../../state/home/home_controller.dart';
import '../../../state/home/home_dashboard_data.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class DailyDebateCard extends StatelessWidget {
  const DailyDebateCard({
    super.key,
    required this.debate,
    required this.selectedResponse,
    required this.onAgree,
    required this.onOppose,
  });

  final DailyDebate debate;
  final DailyDebateResponse? selectedResponse;
  final VoidCallback onAgree;
  final VoidCallback onOppose;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.sunflower.withValues(alpha: 0.18),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -12,
            child: Opacity(
              opacity: 0.28,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 92,
                color: OpposeColors.maroon,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StickerImage(asset: debate.heroAsset, size: 96),
                  const SizedBox(width: OpposeSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusPill(
                          label: debate.categoryLabel,
                          icon: Icons.wb_sunny_rounded,
                          color: OpposeColors.maroon,
                        ),
                        const SizedBox(height: OpposeSpacing.md),
                        Text(
                          debate.question,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: OpposeSpacing.xs),
                        Text(
                          debate.contextLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OpposeSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _DebateChoiceButton(
                      label: 'Agree',
                      selectedLabel: 'Agree selected',
                      icon: Icons.thumb_up_alt_outlined,
                      selected: selectedResponse == DailyDebateResponse.agree,
                      onTap: onAgree,
                    ),
                  ),
                  const SizedBox(width: OpposeSpacing.md),
                  Expanded(
                    child: _DebateChoiceButton(
                      label: 'Oppose',
                      selectedLabel: 'Oppose selected',
                      icon: Icons.forum_outlined,
                      selected: selectedResponse == DailyDebateResponse.oppose,
                      onTap: onOppose,
                    ),
                  ),
                ],
              ),
              if (selectedResponse != null) ...[
                const SizedBox(height: OpposeSpacing.md),
                StatusPill(
                  label: selectedResponse == DailyDebateResponse.agree
                      ? 'Agree selected'
                      : 'Oppose selected',
                  icon: Icons.check_circle_rounded,
                  color: OpposeColors.success,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DebateChoiceButton extends StatelessWidget {
  const _DebateChoiceButton({
    required this.label,
    required this.selectedLabel,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String selectedLabel;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: selected ? selectedLabel : label,
      child: InkWell(
        borderRadius: BorderRadius.circular(OpposeRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: OpposeSpacing.md,
            vertical: OpposeSpacing.md,
          ),
          decoration: BoxDecoration(
            color: selected
                ? OpposeColors.mint.withValues(alpha: 0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(OpposeRadius.lg),
            border: Border.all(
              color: selected ? OpposeColors.mint : OpposeColors.warmBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : icon,
                color: selected ? OpposeColors.maroon : OpposeColors.softInk,
                size: 18,
              ),
              const SizedBox(width: OpposeSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? OpposeColors.maroon
                        : OpposeColors.softInk,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
