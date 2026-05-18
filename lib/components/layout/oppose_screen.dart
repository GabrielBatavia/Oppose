import 'package:flutter/material.dart';

import '../../theme/oppose_colors.dart';
import '../../theme/oppose_spacing.dart';
import '../navigation/oppose_bottom_navigation.dart';

class OpposeScreen extends StatelessWidget {
  const OpposeScreen({
    super.key,
    required this.children,
    this.scrollable = true,
    this.showBottomNavigation = false,
    this.padding = const EdgeInsets.all(OpposeSpacing.xl),
    this.floatingActionButton,
  });

  final List<Widget> children;
  final bool scrollable;
  final bool showBottomNavigation;
  final EdgeInsetsGeometry padding;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    return Scaffold(
      backgroundColor: OpposeColors.cream,
      body: SafeArea(
        child: scrollable ? SingleChildScrollView(child: content) : content,
      ),
      bottomNavigationBar: showBottomNavigation
          ? const OpposeBottomNavigation()
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}
