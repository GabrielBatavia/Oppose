import 'package:flutter/material.dart';

import '../../../components/core/avatar.dart';
import '../../../components/core/paper_card.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class LobbyFriendPreview extends StatelessWidget {
  const LobbyFriendPreview({
    super.key,
    required this.friends,
    required this.onInviteMore,
  });

  final List<Friend> friends;
  final VoidCallback onInviteMore;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${friends.length} friends are here',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: OpposeSpacing.md),
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: friends.length + 1,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: OpposeSpacing.sm),
              itemBuilder: (context, index) {
                if (index == friends.length) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(OpposeRadius.lg),
                    onTap: onInviteMore,
                    child: Container(
                      width: 64,
                      decoration: BoxDecoration(
                        color: OpposeColors.mint.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(OpposeRadius.lg),
                        border: Border.all(color: OpposeColors.warmBorder),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: OpposeColors.maroon,
                      ),
                    ),
                  );
                }

                final friend = friends[index];
                return Column(
                  children: [
                    OpposeAvatar(
                      label: friend.displayName,
                      imageAsset: friend.avatarAsset,
                      size: 48,
                    ),
                    const SizedBox(height: OpposeSpacing.xs),
                    Text(friend.displayName),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
