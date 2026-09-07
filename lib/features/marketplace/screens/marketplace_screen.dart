import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/marketplace_provider.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(marketplaceProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final theme = Theme.of(context);

    final categories = ['All Categories', 'Books', 'Electronics', 'Stationery', 'Notes', 'Digital Services'];

    final cleanSearch = searchQuery.trim().toLowerCase();

    final filteredProducts = products.where((p) {
      final pCat = p.category.toLowerCase().trim();
      final selCat = selectedCategory.toLowerCase().trim();

      final matchesCat = (selectedCategory == 'All Categories' || selectedCategory == 'All') ||
          pCat == selCat ||
          (selCat == 'books' && (pCat.contains('book') || p.title.toLowerCase().contains('book') || p.description.toLowerCase().contains('textbook'))) ||
          (selCat == 'electronics' && (pCat.contains('electr') || p.title.toLowerCase().contains('calculator') || p.title.toLowerCase().contains('keyboard') || p.title.toLowerCase().contains('phone') || p.title.toLowerCase().contains('laptop'))) ||
          (selCat == 'stationery' && (pCat.contains('station') || p.title.toLowerCase().contains('pen') || p.title.toLowerCase().contains('notebook'))) ||
          (selCat == 'notes' && (pCat.contains('note') || p.title.toLowerCase().contains('note') || p.title.toLowerCase().contains('sheet') || p.title.toLowerCase().contains('lecture')));

      final matchesSearch = cleanSearch.isEmpty ||
          p.title.toLowerCase().contains(cleanSearch) ||
          p.description.toLowerCase().contains(cleanSearch) ||
          p.category.toLowerCase().contains(cleanSearch) ||
          p.sellerName.toLowerCase().contains(cleanSearch);
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Header
                const Text(
                  'Marketplace',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.8),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Find textbooks, notes, and services from students on campus.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // Category Pills Bar
                Row(
                  children: [
                    ...categories.map((cat) {
                      final isSel = (selectedCategory == cat) || (selectedCategory == 'All' && cat == 'All Categories');
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          onSelected: (s) {
                            if (s) {
                              ref.read(selectedCategoryProvider.notifier).setCategory(cat);
                            }
                          },
                          selectedColor: const Color(0xFF2563EB),
                          backgroundColor: const Color(0xFFEEF2FF),
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : const Color(0xFF475569),
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }),
                    if (searchQuery.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF2563EB)),
                        label: Text('Search: "$searchQuery"'),
                        backgroundColor: const Color(0xFFDBEAFE),
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                        onPressed: () {
                          ref.read(searchQueryProvider.notifier).setQuery('');
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Empty State if no items in category or search
                if (filteredProducts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'No items found matching "$searchQuery"'
                              : 'No items found in "$selectedCategory"',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try searching with different keywords or check spelling.'
                              : 'Be the first to list an item in this category!',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 16),
                        if (searchQuery.isNotEmpty)
                          OutlinedButton(
                            onPressed: () => ref.read(searchQueryProvider.notifier).setQuery(''),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF2563EB)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Clear Search', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                          )
                        else
                          ElevatedButton(
                            onPressed: () => context.go('/sell'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Post a Listing'),
                          ),
                      ],
                    ),
                  )
                else
                  // Product Cards Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 4;
                      double childAspectRatio = 0.68;
                      if (constraints.maxWidth < 600) {
                        crossAxisCount = 1;
                        childAspectRatio = 1.15;
                      } else if (constraints.maxWidth < 900) {
                        crossAxisCount = 2;
                        childAspectRatio = 0.72;
                      } else if (constraints.maxWidth < 1250) {
                        crossAxisCount = 3;
                        childAspectRatio = 0.70;
                      } else if (constraints.maxWidth < 1550) {
                        crossAxisCount = 4;
                        childAspectRatio = 0.68;
                      } else {
                        crossAxisCount = 5;
                        childAspectRatio = 0.68;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final item = filteredProducts[index];
                          return _ProductCard(item: item, theme: theme);
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final dynamic item;
  final ThemeData theme;

  const _ProductCard({required this.item, required this.theme});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? const Color(0xFF1E293B).withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.02),
              blurRadius: _isHovered ? 16 : 4,
              offset: Offset(0, _isHovered ? 8 : 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/product-details', extra: item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Banner with Hero
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Hero(
                      tag: 'product-img-${item.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF2563EB).withValues(alpha: 0.1),
                                  const Color(0xFF3B82F6).withValues(alpha: 0.25),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.category == 'Books'
                                        ? Icons.menu_book_rounded
                                        : (item.category == 'Stationery'
                                            ? Icons.draw_rounded
                                            : (item.category == 'Notes' ? Icons.description_rounded : Icons.laptop_chromebook_rounded)),
                                    size: 42,
                                    color: const Color(0xFF2563EB),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.category,
                                    style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                          SizedBox(width: 2),
                          Text(
                            '4.9',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '৳${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: widget.theme.colorScheme.primaryContainer,
                          child: Text(item.sellerName[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        Text(item.sellerName, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () => context.go('/product-details', extra: item),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _isHovered ? const Color(0xFF2563EB) : const Color(0xFFEEF2FF),
                          foregroundColor: _isHovered ? Colors.white : const Color(0xFF2563EB),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isHovered ? Colors.white : const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
