import 'package:flutter/material.dart';

class OpposeTextInput extends StatelessWidget {
  const OpposeTextInput({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.helperText,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? errorText;
  final String? helperText;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return OpposeTextInput(
      label: 'Search',
      hintText: 'Search friends or chats',
      onChanged: onChanged,
      suffixIcon: const Icon(Icons.search_rounded),
    );
  }
}
