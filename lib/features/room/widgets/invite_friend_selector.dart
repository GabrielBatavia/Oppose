import 'package:flutter/material.dart';

import '../../../components/core/avatar.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class InviteFriendSelector extends StatelessWidget {
  const InviteFriendSelector({
    super.key,
    required this.friends,
    required this.selectedFriendIds,
    required this.onToggleFriend,
    required this.onAddMore,
    this.disabledFriendIds = const <String>{},
  });

  final List<Friend> friends;
  final Set<String> selectedFriendIds;
  final ValueChanged<String> onToggleFriend;
  final VoidCallback onAddMore;
  final Set<String> disabledFriendIds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(width: OpposeSpacing.md),
        itemBuilder: (context, index) {
          if (index == friends.length) {
            return _AddMoreTile(onTap: onAddMore);
          }

          final friend = friends[index];
          final disabled = disabledFriendIds.contains(friend.id);
          final selected = selectedFriendIds.contains(friend.id) && !disabled;
          return InkWell(
            borderRadius: BorderRadius.circular(OpposeRadius.lg),
            onTap: disabled ? null : () => onToggleFriend(friend.id),
            child: Container(
              width: 92,
              padding: const EdgeInsets.all(OpposeSpacing.sm),
              decoration: BoxDecoration(
                color: disabled
                    ? OpposeColors.warmBorder.withValues(alpha: 0.28)
                    : selected
                    ? OpposeColors.mint.withValues(alpha: 0.28)
                    : OpposeColors.paper,
                borderRadius: BorderRadius.circular(OpposeRadius.lg),
                border: Border.all(
                  color: disabled
                      ? OpposeColors.mutedGray
                      : selected
                      ? OpposeColors.mint
                      : OpposeColors.warmBorder,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      OpposeAvatar(
                        label: friend.displayName,
                        imageAsset: friend.avatarAsset,
                      ),
                      if (selected)
                        const Positioned(
                          right: -2,
                          bottom: -2,
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: OpposeColors.maroon,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: OpposeSpacing.sm),
                  Text(
                    friend.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (disabled)
                    const Text(
                      'Blocked',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        color: OpposeColors.maroon,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  const _AddMoreTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(OpposeRadius.lg),
      onTap: onTap,
      child: Container(
        width: 92,
        padding: const EdgeInsets.all(OpposeSpacing.sm),
        decoration: BoxDecoration(
          color: OpposeColors.paper,
          borderRadius: BorderRadius.circular(OpposeRadius.lg),
          border: Border.all(color: OpposeColors.warmBorder),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_alt_1_rounded, color: OpposeColors.maroon),
            SizedBox(height: OpposeSpacing.sm),
            Text('Add more', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
