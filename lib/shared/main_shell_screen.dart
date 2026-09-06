import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers/marketplace_provider.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/sell')) return 1;
    if (location.startsWith('/subscriptions')) return 2;
    if (location.startsWith('/profile')) return 3;
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
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFF1F5F9)),
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
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  color: Color(0xFF2563EB),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Campus Market',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
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
                      ],

                      const Spacer(),

                      // Search Input (Center Right)
                      if (isDesktop)
                        SizedBox(
                          width: 300,
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
                              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                              suffixIcon: currentQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF94A3B8)),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(searchQueryProvider.notifier).setQuery('');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFFF1F5F9),
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

                      const SizedBox(width: 20),

                      // Profile Action Avatar with smooth hover
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: selectedIndex == 3 ? null : () => context.go('/profile'),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedIndex == 3 ? const Color(0xFF2563EB) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80'),
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
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (idx) => _onItemTapped(idx, context),
              indicatorColor: theme.colorScheme.primaryContainer,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront),
                  label: 'Marketplace',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: 'Sell',
                ),
                NavigationDestination(
                  icon: Icon(Icons.groups_outlined),
                  selectedIcon: Icon(Icons.groups),
                  label: 'Groups',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route, bool isSelected) {
    return InkWell(
      onTap: isSelected ? null : () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color(0xFFEEF2FF),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2.5,
              width: isSelected ? 36 : 0,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
