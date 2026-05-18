import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';

class OpposeAvatar extends StatelessWidget {
  const OpposeAvatar({
    super.key,
    required this.label,
    this.imageAsset,
    this.size = 48,
    this.isAI = false,
    this.isSpeaking = false,
  });

  final String label;
  final String? imageAsset;
  final double size;
  final bool isAI;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    final borderColor = isAI
        ? OpposeColors.indigo
        : isSpeaking
        ? OpposeColors.mint
        : OpposeColors.warmBorder;

    return Semantics(
      label: isAI ? '$label, AI participant' : label,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(isSpeaking ? 3 : 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: isSpeaking ? 3 : 2),
        ),
        child: ClipOval(
          child: imageAsset == null
              ? ColoredBox(
                  color: isAI ? OpposeColors.indigo : OpposeColors.sunflower,
                  child: Center(
                    child: Text(
                      _initials(label),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isAI ? Colors.white : OpposeColors.softInk,
                      ),
                    ),
                  ),
                )
              : Image.asset(imageAsset!, fit: BoxFit.cover),
        ),
      ),
    );
  }

  String _initials(String source) {
    final parts = source.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }
}

class AvatarGroup extends StatelessWidget {
  const AvatarGroup({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          for (final entry in labels.take(4).toList().asMap().entries)
            Positioned(
              left: entry.key * 32,
              child: OpposeAvatar(label: entry.value),
            ),
        ],
      ),
    );
  }
}
