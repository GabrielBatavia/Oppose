import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../assets/oppose_assets.dart';
import '../../components/buttons/oppose_buttons.dart';
import '../../components/core/avatar.dart';
import '../../components/core/badge.dart';
import '../../components/core/oppose_bottom_sheet.dart';
import '../../components/core/paper_card.dart';
import '../../components/core/status_pill.dart';
import '../../components/inputs/oppose_text_input.dart';
import '../../components/layout/oppose_header.dart';
import '../../components/layout/oppose_screen.dart';
import '../../state/messaging/messaging_scope.dart';
import '../../state/mock_data/mock_oppose_data.dart';
import '../../state/safety/safety_controller.dart';
import '../../state/safety/safety_scope.dart';
import '../../state/social/social_controller.dart';
import '../../state/social/social_scope.dart';
import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../../types/domain_models.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockOpposeData.currentUser;
    final social = SocialScope.watch(context);
    final safety = SafetyScope.watch(context);

    return OpposeScreen(
      showBottomNavigation: true,
      children: [
        const OpposeHeader(
          title: 'Oppose',
          subtitle: 'Your respectful debate identity.',
        ),
        const SizedBox(height: OpposeSpacing.xl),
        PaperCard(
          child: Column(
            children: [
              const OpposeAvatar(
                label: "Bima's Friend",
                imageAsset: OpposeAssets.profileBima,
                size: 104,
              ),
              const SizedBox(height: OpposeSpacing.md),
              Text(
                social.displayName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('@${user.username}'),
              const SizedBox(height: OpposeSpacing.sm),
              Text(social.tagline, textAlign: TextAlign.center),
              const SizedBox(height: OpposeSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final interest in user.interests)
                    StatusPill(
                      label: interest,
                      icon: Icons.favorite_outline_rounded,
                      color: OpposeColors.maroon,
                    ),
                ],
              ),
            ],
          ),
        ),
        if (social.actionMessage != null) ...[
          const SizedBox(height: OpposeSpacing.md),
          PaperCard(
            color: OpposeColors.mint.withValues(alpha: 0.14),
            borderColor: OpposeColors.mint,
            child: Text(social.actionMessage!),
          ),
        ],
        const SizedBox(height: OpposeSpacing.xl),
        Row(
          children: [
            const Expanded(
              child: _StatCard(label: 'Debates', value: '18'),
            ),
            const SizedBox(width: OpposeSpacing.md),
            const Expanded(
              child: _StatCard(label: 'Streak', value: '5'),
            ),
            const SizedBox(width: OpposeSpacing.md),
            Expanded(
              child: _StatCard(
                label: 'Friends',
                value: '${social.friends.length}',
              ),
            ),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        _FriendsPreviewCard(social: social, safety: safety),
        const SizedBox(height: OpposeSpacing.xl),
        _FriendRequestsCard(social: social),
        const SizedBox(height: OpposeSpacing.xl),
        Text('Badges', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final badge in MockOpposeData.profileBadges)
              OpposeBadge(label: badge.label),
          ],
        ),
        const SizedBox(height: OpposeSpacing.xl),
        const _WeeklySummaryCard(),
        const SizedBox(height: OpposeSpacing.xl),
        _SafetyCenterCard(social: social, safety: safety),
        const SizedBox(height: OpposeSpacing.xl),
        PrimaryButton(
          label: 'Edit profile',
          onPressed: () => showOpposeBottomSheet(
            context: context,
            child: ProfileEditSheet(social: social),
          ),
        ),
        const SizedBox(height: OpposeSpacing.md),
        SecondaryButton(
          label: 'Share profile',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile share mock copied locally.')),
          ),
        ),
      ],
    );
  }
}

class _FriendsPreviewCard extends StatelessWidget {
  const _FriendsPreviewCard({required this.social, required this.safety});

  final SocialController social;
  final SafetyController safety;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.sunflower.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Friends',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusPill(
                label: '${social.friends.length} friends',
                icon: Icons.people_alt_outlined,
                color: OpposeColors.indigo,
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final friend in social.friends.take(3))
                StatusPill(
                  label: safety.isBlocked(friend.id)
                      ? '${friend.displayName} blocked'
                      : '${friend.displayName} ${friend.status.label}',
                  icon: safety.isBlocked(friend.id)
                      ? Icons.block_rounded
                      : Icons.circle,
                  color: safety.isBlocked(friend.id)
                      ? OpposeColors.maroon
                      : OpposeColors.success,
                ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          SecondaryButton(
            label: 'Manage friends',
            onPressed: () => showOpposeBottomSheet(
              context: context,
              child: const FriendsManagementSheet(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendRequestsCard extends StatelessWidget {
  const _FriendRequestsCard({required this.social});

  final SocialController social;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Friend requests',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: OpposeSpacing.md),
          if (social.pendingRequests.isEmpty)
            const Text('No pending friend requests.')
          else
            for (final request in social.pendingRequests) ...[
              _FriendRequestRow(request: request, social: social),
              const SizedBox(height: OpposeSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _FriendRequestRow extends StatelessWidget {
  const _FriendRequestRow({required this.request, required this.social});

  final FriendRequest request;
  final SocialController social;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OpposeAvatar(
          label: request.displayName,
          imageAsset: request.avatarAsset,
        ),
        const SizedBox(width: OpposeSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text('@${request.username}'),
            ],
          ),
        ),
        TextButton(
          onPressed: () => social.declineRequest(request.id),
          child: const Text('Decline'),
        ),
        FilledButton(
          style: _compactFilledButtonStyle(),
          onPressed: () => social.acceptRequest(request.id),
          child: const Text('Accept'),
        ),
      ],
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  const _WeeklySummaryCard();

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: OpposeSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final height in const [34.0, 58.0, 42.0, 72.0, 50.0]) ...[
                Expanded(
                  child: Container(height: height, color: OpposeColors.mint),
                ),
                const SizedBox(width: OpposeSpacing.sm),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SafetyCenterCard extends StatelessWidget {
  const _SafetyCenterCard({required this.social, required this.safety});

  final SocialController social;
  final SafetyController safety;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: OpposeColors.indigo.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Safety Center', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: OpposeSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill(
                label: '${safety.blockedUserIds.length} blocked',
                icon: Icons.block_rounded,
                color: OpposeColors.maroon,
              ),
              StatusPill(
                label: '${safety.mutedUserIds.length} muted',
                icon: Icons.volume_off_rounded,
                color: OpposeColors.indigo,
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          const Text('Mock safety settings stay on this device for now.'),
          const SizedBox(height: OpposeSpacing.md),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Manage safety',
                  onPressed: () => showOpposeBottomSheet(
                    context: context,
                    child: SafetyManagementSheet(social: social),
                  ),
                ),
              ),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: SecondaryButton(
                  label: 'Report problem',
                  onPressed: () {
                    safety.prepareReport(
                      target: const ReportTarget(
                        id: 'profile_general',
                        displayName: 'Profile safety concern',
                        type: ReportTargetType.general,
                        source: 'profile',
                      ),
                      returnRoute: AppRoutes.profile,
                    );
                    context.go(AppRoutes.report);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FriendsManagementSheet extends StatelessWidget {
  const FriendsManagementSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final social = SocialScope.watch(context);
    final safety = SafetyScope.watch(context);
    final messaging = MessagingScope.read(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Manage friends', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.sm),
        const Text('Search, message, invite, mute, or block friends locally.'),
        const SizedBox(height: OpposeSpacing.lg),
        SearchInput(onChanged: social.setFriendSearchQuery),
        const SizedBox(height: OpposeSpacing.lg),
        if (social.filteredFriends.isEmpty)
          const PaperCard(child: Text('No friends match that search.'))
        else
          for (final friend in social.filteredFriends) ...[
            _FriendManagementCard(
              friend: friend,
              isBlocked: safety.isBlocked(friend.id),
              isMuted: safety.isMuted(friend.id),
              invited: social.invitedFriendIds.contains(friend.id),
              onMessage: () {
                if (friend.id == 'maya') {
                  messaging.openConversation('maya_direct');
                  Navigator.of(context).pop();
                  context.go(AppRoutes.directChat);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${friend.displayName} chat is coming soon.',
                      ),
                    ),
                  );
                }
              },
              onInvite: () => social.inviteFriend(friend.id),
              onToggleMute: () => safety.toggleMuted(friend.id),
              onToggleBlock: () {
                if (safety.isBlocked(friend.id)) {
                  safety.unblockUser(friend.id);
                } else {
                  safety.blockUser(friend.id);
                }
              },
            ),
            const SizedBox(height: OpposeSpacing.md),
          ],
        const SizedBox(height: OpposeSpacing.lg),
        PrimaryButton(
          label: 'Done',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _FriendManagementCard extends StatelessWidget {
  const _FriendManagementCard({
    required this.friend,
    required this.isBlocked,
    required this.isMuted,
    required this.invited,
    required this.onMessage,
    required this.onInvite,
    required this.onToggleMute,
    required this.onToggleBlock,
  });

  final Friend friend;
  final bool isBlocked;
  final bool isMuted;
  final bool invited;
  final VoidCallback onMessage;
  final VoidCallback onInvite;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleBlock;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      color: isBlocked
          ? OpposeColors.maroon.withValues(alpha: 0.08)
          : OpposeColors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OpposeAvatar(
                label: friend.displayName,
                imageAsset: friend.avatarAsset,
              ),
              const SizedBox(width: OpposeSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text('@${friend.username}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusPill(
                label: friend.status.label,
                icon: Icons.circle,
                color: OpposeColors.success,
              ),
              if (isMuted)
                const StatusPill(
                  label: 'Muted',
                  icon: Icons.volume_off_rounded,
                  color: OpposeColors.indigo,
                ),
              if (isBlocked)
                const StatusPill(
                  label: 'Blocked',
                  icon: Icons.block_rounded,
                  color: OpposeColors.maroon,
                ),
              if (invited)
                const StatusPill(
                  label: 'Invited',
                  icon: Icons.mail_outline_rounded,
                  color: OpposeColors.mint,
                ),
            ],
          ),
          const SizedBox(height: OpposeSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                style: _compactOutlinedButtonStyle(),
                onPressed: isBlocked ? null : onMessage,
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Message'),
              ),
              OutlinedButton.icon(
                style: _compactOutlinedButtonStyle(),
                onPressed: isBlocked ? null : onInvite,
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text(invited ? 'Invited' : 'Invite'),
              ),
              OutlinedButton.icon(
                style: _compactOutlinedButtonStyle(),
                onPressed: onToggleMute,
                icon: Icon(
                  isMuted ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                ),
                label: Text(isMuted ? 'Unmute' : 'Mute'),
              ),
              FilledButton.icon(
                style: _compactFilledButtonStyle(
                  backgroundColor: OpposeColors.danger,
                ),
                onPressed: onToggleBlock,
                icon: Icon(
                  isBlocked ? Icons.lock_open_rounded : Icons.block_rounded,
                ),
                label: Text(isBlocked ? 'Unblock' : 'Block'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SafetyManagementSheet extends StatelessWidget {
  const SafetyManagementSheet({super.key, required this.social});

  final SocialController social;

  @override
  Widget build(BuildContext context) {
    final safety = SafetyScope.watch(context);
    final blockedIds = safety.blockedUserIds.toList();
    final mutedIds = safety.mutedUserIds.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Manage safety', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.sm),
        const Text('Blocked and muted lists are local mock state for now.'),
        const SizedBox(height: OpposeSpacing.lg),
        Text('Blocked users', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        if (blockedIds.isEmpty)
          const PaperCard(child: Text('No blocked users.'))
        else
          for (final id in blockedIds) ...[
            _SafetyUserRow(
              label: _friendLabel(social, id),
              actionLabel: 'Unblock',
              icon: Icons.block_rounded,
              onPressed: () => safety.unblockUser(id),
            ),
            const SizedBox(height: OpposeSpacing.md),
          ],
        const SizedBox(height: OpposeSpacing.lg),
        Text('Muted users', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: OpposeSpacing.md),
        if (mutedIds.isEmpty)
          const PaperCard(child: Text('No muted users.'))
        else
          for (final id in mutedIds) ...[
            _SafetyUserRow(
              label: _friendLabel(social, id),
              actionLabel: 'Unmute',
              icon: Icons.volume_off_rounded,
              onPressed: () => safety.unmuteUser(id),
            ),
            const SizedBox(height: OpposeSpacing.md),
          ],
        const SizedBox(height: OpposeSpacing.lg),
        PrimaryButton(
          label: 'Done',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  String _friendLabel(SocialController social, String id) {
    return social.friendById(id)?.displayName ?? id;
  }
}

class _SafetyUserRow extends StatelessWidget {
  const _SafetyUserRow({
    required this.label,
    required this.actionLabel,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Row(
        children: [
          Icon(icon, color: OpposeColors.maroon),
          const SizedBox(width: OpposeSpacing.md),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
            width: 108,
            child: SecondaryButton(label: actionLabel, onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}

ButtonStyle _compactFilledButtonStyle({Color? backgroundColor}) {
  return FilledButton.styleFrom(
    backgroundColor: backgroundColor,
    minimumSize: const Size(0, 44),
    padding: const EdgeInsets.symmetric(horizontal: 14),
  );
}

ButtonStyle _compactOutlinedButtonStyle() {
  return OutlinedButton.styleFrom(
    minimumSize: const Size(0, 44),
    padding: const EdgeInsets.symmetric(horizontal: 14),
  );
}

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({super.key, required this.social});

  final SocialController social;

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _taglineController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.social.displayName);
    _taglineController = TextEditingController(text: widget.social.tagline);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Edit profile', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: OpposeSpacing.lg),
        OpposeTextInput(label: 'Display name', controller: _nameController),
        const SizedBox(height: OpposeSpacing.md),
        OpposeTextInput(
          label: 'Tagline',
          controller: _taglineController,
          maxLines: 2,
        ),
        const SizedBox(height: OpposeSpacing.lg),
        PrimaryButton(
          label: 'Save profile',
          onPressed: () {
            widget.social.updateProfile(
              name: _nameController.text,
              newTagline: _taglineController.text,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: OpposeSpacing.xs),
          Text(label),
        ],
      ),
    );
  }
}
