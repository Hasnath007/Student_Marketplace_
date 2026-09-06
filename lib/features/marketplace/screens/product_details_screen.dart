import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _activeImage;

  @override
  void initState() {
    super.initState();
    _activeImage = widget.product?.imageUrl ?? 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80';
  }

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.product?.imageUrl != oldWidget.product?.imageUrl) {
      setState(() {
        _activeImage = widget.product?.imageUrl ?? 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80';
      });
    }
  }

  void _showContactSellerDialog(BuildContext context, String sellerName) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFDBEAFE),
              child: Icon(Icons.person, color: Color(0xFF2563EB)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact $sellerName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Verified Campus Seller', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send a direct message on Campus Chat:', style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Hi, is this item still available for meetup on campus?',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message sent to $sellerName! They will respond shortly.'),
                  backgroundColor: const Color(0xFF2563EB),
                ),
              );
            },
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text('Send Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.product?.title ?? 'Introduction to Linear Algebra, 5th Edition';
    final priceStr = widget.product != null ? '\$${widget.product!.price.toStringAsFixed(0)}' : '\$45';
    final seller = widget.product?.sellerName ?? 'Sarah Jenkins';
    final desc = widget.product?.description ??
        'Mint condition textbook required for MATH 220. No highlighting, dog-eared pages, or spine damage. Includes the unused digital access code card inside the front cover.\n\nOriginally purchased for \$140 at the campus bookstore. Selling because I ended up dropping the class during syllabus week. Pick up near North Campus library preferred.';
    final condition = widget.product?.condition ?? 'Like New';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back to Marketplace Button
                TextButton.icon(
                  onPressed: () => context.go('/marketplace'),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF2563EB)),
                  label: const Text('Back to Marketplace', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                ),
                const SizedBox(height: 12),

                // Main Product Details Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Main Image & Gallery
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          // Main Big Image
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  height: 380,
                                  width: double.infinity,
                                  child: Image.network(
                                    _activeImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: const Color(0xFFF1F5F9),
                                      child: const Icon(Icons.image_outlined, size: 48, color: Color(0xFF94A3B8)),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF2563EB)),
                                      const SizedBox(width: 4),
                                      Text(condition, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Thumbnails Row
                          Row(
                            children: [
                              _buildThumb('https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=300&q=80'),
                              const SizedBox(width: 10),
                              _buildThumb('https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=300&q=80'),
                              const SizedBox(width: 10),
                              _buildThumb('https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=300&q=80'),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDBEAFE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.collections_outlined, size: 20, color: Color(0xFF2563EB)),
                                        SizedBox(height: 2),
                                        Text('+2', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Right Column: Title, Specs, Actions
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  (widget.product?.category ?? 'Books & Textbooks').toUpperCase(),
                                  style: const TextStyle(color: Color(0xFF2563EB), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('•  LISTED 2H AGO', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), height: 1.2),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(priceStr, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Icon(Icons.trending_up_rounded, size: 14, color: Colors.orange.shade800),
                                  const SizedBox(width: 4),
                                  Text('High Demand', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          const Text('ITEM DESCRIPTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.8)),
                          const SizedBox(height: 6),
                          Text(
                            desc,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5),
                          ),
                          const SizedBox(height: 20),

                          // Specs Grid Box
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Author / Brand', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text('Gilbert Strang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      Text('Course', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text('MATH 220', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('ID / ISBN', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text('978-0980232776', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      Text('Format', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text('Hardcover', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Seller Info Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80'),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(seller, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    const Text('★ 4.9 (12 Sales) • Verified Student', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.chevron_right, color: Color(0xFF475569)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Contact Seller Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () => _showContactSellerDialog(context, seller),
                              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                              label: const Text('CONTACT SELLER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shield_outlined, size: 12, color: Color(0xFF64748B)),
                                SizedBox(width: 4),
                                Text('Protected by Campus Market Guarantee', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 24),

                // More Items Grid Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('More Campus Deals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    TextButton(
                      onPressed: () => context.go('/marketplace'),
                      child: const Text('View all ->', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bottom Cards Grid
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => context.go('/product-details', extra: const Product(id: 'r1', title: 'TI-84 Plus CE Graphing Calculator', price: 80.0, category: 'Electronics', condition: 'Good', description: 'Calculator with color screen', imageUrl: 'https://images.unsplash.com/photo-1594980596870-8aa52a78d8cd?auto=format&fit=crop&w=400&q=80', sellerName: 'Michael R.', sellerCampus: 'Main Campus')),
                        child: _buildSmallCard('TI-84 Plus CE Graphing Calculator', '\$80', 'Good', 'https://images.unsplash.com/photo-1594980596870-8aa52a78d8cd?auto=format&fit=crop&w=400&q=80'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => context.go('/product-details', extra: const Product(id: 'r2', title: 'Grid Rule Notebooks (Pack of 3)', price: 12.0, category: 'Stationery', condition: 'New', description: '3 notebooks for engineering', imageUrl: 'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=400&q=80', sellerName: 'Lisa W.', sellerCampus: 'Engineering Quad')),
                        child: _buildSmallCard('Grid Rule Notebooks (Pack of 3)', '\$12', 'New', 'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=400&q=80'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => context.go('/product-details', extra: const Product(id: 'r3', title: 'Comprehensive Midterm Study Guides', price: 15.0, category: 'Notes', condition: 'Digital', description: 'Exam notes and solved problems', imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=400&q=80', sellerName: 'David K.', sellerCampus: 'East Dorms')),
                        child: _buildSmallCard('Comprehensive Midterm Study Guides', '\$15', 'Digital', 'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=400&q=80'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => context.go('/product-details', extra: const Product(id: 'r4', title: 'Personal Whiteboard + Markers', price: 10.0, category: 'Stationery', condition: 'Like New', description: 'Mini whiteboard set', imageUrl: 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?auto=format&fit=crop&w=400&q=80', sellerName: 'Sarah J.', sellerCampus: 'North Campus')),
                        child: _buildSmallCard('Personal Whiteboard + Markers', '\$10', 'Like New', 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?auto=format&fit=crop&w=400&q=80'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumb(String url) {
    final isSelected = _activeImage == url;
    return GestureDetector(
      onTap: () => setState(() => _activeImage = url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 76,
            width: 76,
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, String price, String badge, String imgUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.image_outlined, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
