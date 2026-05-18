import 'package:flutter/material.dart';

import '../../../components/core/status_pill.dart';
import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';
import '../../../types/domain_models.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.isMine});

  final Message message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final background = message.isAI
        ? OpposeColors.indigo.withValues(alpha: 0.12)
        : isMine
        ? OpposeColors.mint.withValues(alpha: 0.3)
        : OpposeColors.paper;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        padding: const EdgeInsets.all(OpposeSpacing.lg),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(OpposeRadius.lg),
            topRight: const Radius.circular(OpposeRadius.lg),
            bottomLeft: Radius.circular(
              isMine ? OpposeRadius.lg : OpposeRadius.sm,
            ),
            bottomRight: Radius.circular(
              isMine ? OpposeRadius.sm : OpposeRadius.lg,
            ),
          ),
          border: Border.all(
            color: message.status == MessageStatus.failed
                ? OpposeColors.danger
                : OpposeColors.warmBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isAI) ...[
              const StatusPill(
                label: 'AI Helper',
                icon: Icons.smart_toy_rounded,
              ),
              const SizedBox(height: OpposeSpacing.sm),
            ],
            Text(message.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: OpposeSpacing.sm),
            Text(
              '${message.createdLabel} - ${_statusLabel(message.status)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: message.status == MessageStatus.failed
                    ? OpposeColors.danger
                    : OpposeColors.mutedGray,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(MessageStatus status) => switch (status) {
    MessageStatus.sending => 'sending',
    MessageStatus.sent => 'sent',
    MessageStatus.delivered => 'delivered',
    MessageStatus.read => 'read',
    MessageStatus.failed => 'failed',
  };
}
