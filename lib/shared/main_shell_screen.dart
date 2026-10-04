// ⚓ Main Shell Screen (কমন ফ্রেম ও বটম নেভিগেশন বার)
// 📌 কাজ: স্ক্রিনের নিচে স্টাইলিশ Bottom Navigation Bar রাখা (Marketplace, Sell, Subscriptions, Profile ট্যাব)।
// 🔗 নেভিগেশন: GoRouter ShellRoute দিয়ে পেইজ পরিবর্তন করে।

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/providers/marketplace_provider.dart';
import '../core/services/chat_service.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  final TextEditingController _searchController = TextEditingController();
  Stream<DocumentSnapshot>? _userDocStream;

  @override
  void initState() {
    super.initState();
    _initUserDocStream();
  }

  void _initUserDocStream() {
    if (Firebase.apps.isNotEmpty) {
      final uid = FirebaseAuth.instance.currentUser?.uid.trim() ?? '';
      if (uid.isNotEmpty && !uid.contains('/')) {
        try {
          _userDocStream = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
          return;
        } catch (_) {}
      }
    }
    _userDocStream = const Stream<DocumentSnapshot>.empty();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/sell')) return 1;
    if (location.startsWith('/subscriptions')) return 2;
    if (location.startsWith('/inbox')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // /marketplace
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/marketplace');
        break;
      case 1:
        context.go('/sell');
        break;
      case 2:
        context.go('/subscriptions');
        break;
      case 3:
        context.go('/inbox');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final currentQuery = ref.watch(searchQueryProvider);

    if (_searchController.text != currentQuery && !_searchController.selection.isValid) {
      _searchController.text = currentQuery;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    border: Border(
      bottom: BorderSide(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
    ),
  ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    children: [
                      // Brand Logo & Title with smooth hover
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: selectedIndex == 0 ? null : () => context.go('/marketplace'),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  color: Color(0xFF2563EB),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                               Text(
                                'Campus Market',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),

                      // Desktop Nav Links with animated indicators
                      if (isDesktop) ...[
                        _buildNavItem(context, 'Marketplace', '/marketplace', selectedIndex == 0),
                        const SizedBox(width: 8),
                        _buildNavItem(context, 'Sell Item', '/sell', selectedIndex == 1),
                        const SizedBox(width: 8),
                        _buildNavItem(context, 'Subscription Groups', '/subscriptions', selectedIndex == 2),
                        const SizedBox(width: 8),
                        _buildNavItem(context, 'Inbox', '/inbox', selectedIndex == 3),
                      ],

                      const Spacer(),

                      // Search Input (Center Right)
                      if (isDesktop)
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: _searchController,
                            onChanged: (val) {
                              ref.read(searchQueryProvider.notifier).setQuery(val);
                              final currentLoc = GoRouterState.of(context).uri.toString();
                              if (!currentLoc.startsWith('/marketplace') && !currentLoc.startsWith('/subscriptions')) {
                                context.go('/marketplace');
                              }
                            },
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: GoRouterState.of(context).uri.toString().startsWith('/subscriptions')
                                  ? 'Search subscription groups...'
                                  : 'Search marketplace products...',
                              hintStyle: TextStyle( fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant,),
                              prefixIcon: Icon(Icons.search, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant,),
                              suffixIcon: currentQuery.isNotEmpty
                                  ? IconButton(
                                      icon:  Icon(Icons.close_rounded, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant,),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(searchQueryProvider.notifier).setQuery('');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(width: 20),


                      // Profile Action Avatar with smooth hover
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: selectedIndex == 4 ? null : () => context.go('/profile'),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedIndex == 4
    ? Theme.of(context).colorScheme.primary
    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: _userDocStream,
                              builder: (context, snapshot) {
                                String? photoUrl;
                                String userName = '';

                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                                  photoUrl = data['photoUrl'] ?? data['profileImageUrl'];
                                  userName = data['name'] ?? '';
                                }

                                return CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF2563EB),
                                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                                  child: photoUrl == null
                                      ? Text(
                                          userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        )
                                      : null,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: widget.child,
      bottomNavigationBar: isDesktop
          ? null
          : StreamBuilder<int>(
              stream: chatService.getTotalUnreadCountStream(),
              builder: (context, snapshot) {
                final unread = snapshot.data ?? 0;
                return NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (idx) => _onItemTapped(idx, context),
                  indicatorColor: theme.colorScheme.primaryContainer,
                  destinations: [
                    const NavigationDestination(
                      icon: Icon(Icons.storefront_outlined),
                      selectedIcon: Icon(Icons.storefront),
                      label: 'Marketplace',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.add_circle_outline),
                      selectedIcon: Icon(Icons.add_circle),
                      label: 'Sell',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.groups_outlined),
                      selectedIcon: Icon(Icons.groups),
                      label: 'Groups',
                    ),
                    NavigationDestination(
                      icon: unread > 0
                          ? Badge.count(
                              count: unread,
                              backgroundColor: const Color(0xFFEF4444),
                              child: const Icon(Icons.chat_bubble_outline_rounded),
                            )
                          : const Icon(Icons.chat_bubble_outline_rounded),
                      selectedIcon: unread > 0
                          ? Badge.count(
                              count: unread,
                              backgroundColor: const Color(0xFFEF4444),
                              child: const Icon(Icons.chat_bubble_rounded),
                            )
                          : const Icon(Icons.chat_bubble_rounded),
                      label: 'Inbox',
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route, bool isSelected) {
    Widget titleWidget = Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    if (label == 'Inbox') {
      titleWidget = StreamBuilder<int>(
        stream: chatService.getTotalUnreadCountStream(),
        builder: (context, snapshot) {
          final unread = snapshot.data ?? 0;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (unread > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      );
    }

    return InkWell(
      onTap: isSelected ? null : () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      hoverColor: Theme.of(context).colorScheme.primaryContainer,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleWidget,
            const SizedBox(height: 4),
            Container(
              height: 2.5,
              width: isSelected ? 36 : 0,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
