import 'package:flutter/material.dart';

import 'navigation/app_router.dart';
import '../theme/oppose_theme.dart';

class OpposeApp extends StatelessWidget {
  const OpposeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Oppose',
      debugShowCheckedModeBanner: false,
      theme: OpposeTheme.light,
      routerConfig: appRouter,
    );
  }
}
