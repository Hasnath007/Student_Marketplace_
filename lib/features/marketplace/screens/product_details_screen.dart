import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/product.dart';
import '../../subscriptions/widgets/host_chat_dialog.dart';
import '../widgets/payment_checkout_dialog.dart';
import '../../../core/providers/marketplace_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product? product;
  final String? productId;

  const ProductDetailsScreen({super.key, this.product, this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  late String _activeImage;
  bool _isOrderPlaced = false;
  bool _isReceived = false;

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

  @override
  Widget build(BuildContext context) {
    Product? activeProductOrNull = widget.product;
    
    if (activeProductOrNull == null && widget.productId != null) {
      final allProducts = ref.watch(marketplaceProvider);
      try {
        activeProductOrNull = allProducts.firstWhere((p) => p.id == widget.productId);
      } catch (e) {
        activeProductOrNull = null;
      }
    }

    if (activeProductOrNull == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
      );
    }
    
    final Product activeProduct = activeProductOrNull;

    if (_activeImage == 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=800&q=80' && activeProduct.imageUrl.isNotEmpty) {
      _activeImage = activeProduct.imageUrl;
    }

    final title = activeProduct.title;
    final priceStr = '৳${activeProduct.price.toStringAsFixed(0)}';
    final desc = activeProduct.description.isNotEmpty ? activeProduct.description :
        'Mint condition textbook required for MATH 220. No highlighting, dog-eared pages, or spine damage. Includes the unused digital access code card inside the front cover.\n\nOriginally purchased for ৳1200 at the campus bookstore. Selling because I ended up dropping the class during syllabus week. Pick up near North Campus library preferred.';
    final condition = activeProduct.condition;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: StreamBuilder<DocumentSnapshot>(
        stream: () {
          if (Firebase.apps.isEmpty) return const Stream<DocumentSnapshot>.empty();
          
          String targetUid = activeProduct.sellerId;
          
          if (targetUid.isEmpty) {
            final currUser = FirebaseAuth.instance.currentUser;
            if (currUser != null) {
              final prefix = currUser.email?.split('@')[0] ?? '';
              final isOwner = activeProduct.sellerName == currUser.displayName ||
                  (prefix.isNotEmpty && activeProduct.sellerName == prefix);
              if (isOwner) targetUid = currUser.uid;
            }
          }

          return targetUid.isNotEmpty 
              ? FirebaseFirestore.instance.collection('users').doc(targetUid).snapshots()
              : const Stream<DocumentSnapshot>.empty();
        }(),
        builder: (context, snapshot) {
          String displaySellerName = widget.product?.sellerName ?? 'Sarah Jenkins';
          String? sellerPhotoUrl;

          if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;
            if (userData != null) {
              displaySellerName = userData['name'] ?? displaySellerName;
              sellerPhotoUrl = userData['photoUrl'] ?? userData['profileImageUrl'];
            }
          }

          final seller = displaySellerName;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
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
                          // Main Big Image with Hero & AnimatedSwitcher
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  height: 380,
                                  width: double.infinity,
                                  child: Hero(
                                    tag: 'product-img-${activeProduct.id}',
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 250),
                                      switchInCurve: Curves.easeOutCubic,
                                      switchOutCurve: Curves.easeInCubic,
                                      child: Image.network(
                                        _activeImage,
                                        key: ValueKey<String>(_activeImage),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 380,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: const Color(0xFFF1F5F9),
                                          child: const Icon(Icons.image_outlined, size: 48, color: Color(0xFF94A3B8)),
                                        ),
                                      ),
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

                          // Thumbnails Row removed as products only have one main image
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
                                  activeProduct.category.toUpperCase(),
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Category', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text(activeProduct.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      const Text('Condition', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text(condition, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Campus', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      Text(activeProduct.sellerCampus, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: const Color(0xFF2563EB),
                                      backgroundImage: sellerPhotoUrl != null ? NetworkImage(sellerPhotoUrl) : null,
                                      child: sellerPhotoUrl == null
                                          ? Text(
                                              displaySellerName.isNotEmpty ? displaySellerName[0].toUpperCase() : '?',
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(displaySellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        const SizedBox(height: 2),
                                        const Text('Verified Student', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.chevron_right, color: Color(0xFF475569)),
                                  ],
                                ),
                              ),
                          const SizedBox(height: 20),

                          // Order & Handover Status Section if purchased
                          if (_isOrderPlaced) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _isReceived ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _isReceived ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            _isReceived ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                                            color: _isReceived ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _isReceived ? 'Order Completed ✓' : 'Awaiting Campus Handover',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: _isReceived ? const Color(0xFF14532D) : const Color(0xFF92400E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _isReceived ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _isReceived ? 'COMPLETED' : 'ESCROW SECURED',
                                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _isReceived
                                        ? 'You have received the item. $priceStr has been released to $seller.'
                                        : 'Payment verified! $priceStr is safely held in Escrow. Meet $seller on campus to inspect and receive.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _isReceived ? const Color(0xFF15803D) : const Color(0xFF78350F),
                                      height: 1.3,
                                    ),
                                  ),
                                  if (!_isReceived) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 42,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              title: const Row(
                                                children: [
                                                  Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                                                  SizedBox(width: 8),
                                                  Text('Confirm Handover?'),
                                                ],
                                              ),
                                              content: Text('Did you receive and inspect "$title" from $seller? This will release $priceStr to the seller.'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Not Yet')),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(ctx);
                                                    setState(() => _isReceived = true);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('🎉 Handover confirmed! $priceStr released to $seller.'),
                                                        backgroundColor: const Color(0xFF10B981),
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF10B981),
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text('Yes, Item Received ✓'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                                        label: const Text('Item Received (Complete Handover)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF059669),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ] else if (activeProduct.isSold) ...[
                            // Sold Out state
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                              ),
                              child: const Center(
                                child: Text(
                                  '🚫 THIS ITEM IS SOLD OUT',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ] else ...[
                            // Buy Now / Pay with bKash/Nagad Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  PaymentCheckoutDialog.show(
                                    context,
                                    itemName: title,
                                    priceText: priceStr,
                                    category: activeProduct.category,
                                    onOpenChat: () {
                                      HostChatDialog.show(
                                        context,
                                        hostName: seller,
                                        groupTitle: title,
                                        assignedScreen: 'Campus Meetup Spot',
                                        isSellerMode: true,
                                      );
                                    },
                                    onPaymentSuccess: () {
                                      setState(() => _isOrderPlaced = true);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.account_balance_wallet_rounded, size: 18),
                                label: const Text('PAY WITH BKASH / NAGAD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE2136E),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          // Contact Seller Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                HostChatDialog.show(
                                  context,
                                  hostName: seller,
                                  groupTitle: title,
                                  assignedScreen: 'Campus Meetup Spot',
                                  isSellerMode: true,
                                );
                              },
                              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                              label: Text(
                                _isOrderPlaced ? 'CHAT WITH SELLER (SCHEDULE MEETUP)' : 'CONTACT SELLER',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                                foregroundColor: const Color(0xFF2563EB),
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
                Consumer(
                  builder: (context, ref, child) {
                    final allProducts = ref.watch(marketplaceProvider);
                    final moreDeals = allProducts
                        .where((p) => p.id != activeProduct.id)
                        .take(4)
                        .toList();
                        
                    if (moreDeals.isEmpty) return const SizedBox.shrink();

                    return Row(
                      children: moreDeals.map((deal) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: InkWell(
                              onTap: () => context.go('/product-details/${deal.id}', extra: deal),
                              child: _buildSmallCard(deal.title, '৳${deal.price.toStringAsFixed(0)}', deal.condition, deal.imageUrl),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
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
