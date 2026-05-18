import 'package:flutter/material.dart';

class StickerImage extends StatelessWidget {
  const StickerImage({
    super.key,
    required this.asset,
    this.size = 96,
    this.semanticLabel,
  });

  final String asset;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
    );
  }
}

class TapeDecoration extends StatelessWidget {
  const TapeDecoration({super.key, required this.asset, this.width = 72});

  final String asset;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Image.asset(asset, width: width, fit: BoxFit.contain),
    );
  }
}
