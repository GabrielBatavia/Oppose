import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';

class OpposeBottomNavigation extends StatelessWidget {
  const OpposeBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _selectedIndex(location);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => context.go(_destinations[index].route),
      destinations: [
        for (final destination in _destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: destination.label,
          ),
      ],
    );
  }

  int _selectedIndex(String location) {
    if (location == AppRoutes.chats || location == AppRoutes.directChat) {
      return 1;
    }
    if (location == AppRoutes.createRoom) {
      return 2;
    }
    if (location == AppRoutes.roomLobby ||
        location == AppRoutes.liveRoom ||
        location == AppRoutes.roomSummary) {
      return 3;
    }
    if (location == AppRoutes.profile) {
      return 4;
    }
    return 0;
  }
}

class _BottomDestination {
  const _BottomDestination({
    required this.label,
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final String route;
  final IconData icon;
  final IconData selectedIcon;
}

const _destinations = <_BottomDestination>[
  _BottomDestination(
    label: 'Home',
    route: AppRoutes.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  _BottomDestination(
    label: 'Chats',
    route: AppRoutes.chats,
    icon: Icons.chat_bubble_outline_rounded,
    selectedIcon: Icons.chat_bubble_rounded,
  ),
  _BottomDestination(
    label: 'Create',
    route: AppRoutes.createRoom,
    icon: Icons.add_circle_outline_rounded,
    selectedIcon: Icons.add_circle_rounded,
  ),
  _BottomDestination(
    label: 'Rooms',
    route: AppRoutes.roomLobby,
    icon: Icons.graphic_eq_rounded,
    selectedIcon: Icons.graphic_eq_rounded,
  ),
  _BottomDestination(
    label: 'Profile',
    route: AppRoutes.profile,
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];
