import 'package:flutter/material.dart';

import '../../../theme/oppose_colors.dart';
import '../../../theme/oppose_radius.dart';
import '../../../theme/oppose_spacing.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({super.key, required this.onSend});

  final bool Function(String body) onSend;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OpposeSpacing.sm),
      decoration: BoxDecoration(
        color: OpposeColors.paper,
        borderRadius: BorderRadius.circular(OpposeRadius.lg),
        border: Border.all(color: OpposeColors.warmBorder),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Attachment placeholder',
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: _send,
              decoration: const InputDecoration(
                hintText: 'Type a respectful reply...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          IconButton.filled(
            tooltip: 'Send message',
            onPressed: () => _send(_controller.text),
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }

  void _send(String value) {
    final sent = widget.onSend(value);
    if (sent) _controller.clear();
  }
}
