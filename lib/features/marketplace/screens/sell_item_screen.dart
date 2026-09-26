// ➕ Sell Item Screen (পণ্য বিক্রির পোস্ট পেজ)
// 📌 কাজ: নতুন কোনো পণ্য বিক্রির জন্য ছবি তোলা/আপলোড, নাম, দাম, ক্যাটাগরি ও কন্ডিশন দিয়ে পোস্ট করার ফর্ম।
// 🔗 স্টেট: marketplaceProvider.notifier.addProduct(newProduct) দিয়ে প্রোডাক্ট অ্যাড করা হয়।
// 🔗 ইউটিলস: FilePickerHelper দিয়ে গ্যালারি বা ফাইল থেকে ছবি নেওয়া হয়।

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/providers/marketplace_provider.dart';
import '../../../core/utils/file_picker_helper.dart';
import '../../../models/product.dart';

class SellItemScreen extends ConsumerStatefulWidget {
  const SellItemScreen({super.key});

  @override
  ConsumerState<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends ConsumerState<SellItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCondition = 'Good';
  String _selectedCategory = 'Books';
  Uint8List? _uploadedImageBytes;
  String? _uploadedImageUrl;
  bool _isPublishing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await pickImageFile();
      if (result != null) {
        setState(() {
          _uploadedImageBytes = result['bytes'] as Uint8List?;
          _uploadedImageUrl = result['path'] as String?;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Photo "${result['name'] ?? 'Image'}" uploaded successfully!'),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open file picker: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Subtitle Header
                  const Text(
                    'Create a Listing',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Turn your unused items into cash. Detailed listings with clear photos sell up to 40% faster on campus.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 32),

                  // Main Content
                  Column(
                    children: [
                            // 1. Photos Card
                            _buildCardContainer(
                              title: 'Photos',
                              badge: '${_uploadedImageBytes != null || _uploadedImageUrl != null ? '1' : '0'} / 8 Uploaded',
                              child: (_uploadedImageBytes == null && _uploadedImageUrl == null)
                                  ? MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: _pickImage,
                                        child: CustomPaint(
                                          painter: _DashedBorderPainter(),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 36),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: const Icon(Icons.add_photo_alternate_outlined, size: 36, color: Color(0xFF2563EB)),
                                                ),
                                                const SizedBox(height: 12),
                                                RichText(
                                                  text: const TextSpan(
                                                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                                                    children: [
                                                      TextSpan(
                                                        text: 'Upload a photo ',
                                                        style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                                                      ),
                                                      TextSpan(
                                                        text: 'or drag and drop',
                                                        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Text(
                                                  'SVG, PNG, JPG, WEBP or GIF (max. 10MB)',
                                                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: _uploadedImageBytes != null
                                              ? Image.memory(
                                                  _uploadedImageBytes!,
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  _uploadedImageUrl!,
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF10B981),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Text('Photo Added ✓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () => setState(() {
                                                  _uploadedImageBytes = null;
                                                  _uploadedImageUrl = null;
                                                }),
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            const SizedBox(height: 20),

                            // 2. Details Card
                            _buildCardContainer(
                              title: 'Details',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFieldLabel('Item Title'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _titleController,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: _buildInputDecoration('What are you selling?'),
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category Dropdown
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildFieldLabel('Category'),
                                            const SizedBox(height: 8),
                                            DropdownButtonFormField<String>(
                                              initialValue: _selectedCategory,
                                              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                                              decoration: _buildInputDecoration(''),
                                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                                              items: const [
                                                DropdownMenuItem(value: 'Books', child: Text('Books & Textbooks')),
                                                DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                                                DropdownMenuItem(value: 'Stationery', child: Text('Stationery & Supplies')),
                                                DropdownMenuItem(value: 'Notes', child: Text('Lecture Notes')),
                                                DropdownMenuItem(value: 'Digital Services', child: Text('Digital Services')),
                                              ],
                                              onChanged: (val) {
                                                if (val != null) setState(() => _selectedCategory = val);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),

                                      // Condition Selector
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildFieldLabel('Condition'),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: ['New', 'Good', 'Used'].map((cond) {
                                                final isSelected = _selectedCondition == cond;
                                                return Expanded(
                                                  child: GestureDetector(
                                                    onTap: () => setState(() => _selectedCondition = cond),
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 6),
                                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                                      decoration: BoxDecoration(
                                                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          cond,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w700,
                                                            color: isSelected ? Colors.white : const Color(0xFF475569),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 3. Price & Description Card
                            _buildCardContainer(
                              title: 'Price',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _priceController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                    decoration: _buildInputDecoration('৳  0.00'),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildFieldLabel('Description'),
                                      const Text('0 / 500', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _descController,
                                    maxLines: 5,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: _buildInputDecoration('Describe your item in detail. Mention any flaws or important details buyers should know.'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Actions Bar (Save Draft & Publish Listing)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isPublishing ? null : () async {
                                  if (!(_formKey.currentState?.validate() ?? false)) return;
                                  
                                  if (_uploadedImageBytes == null && _uploadedImageUrl == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please upload a photo first.')),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isPublishing = true;
                                  });

                                  try {
                                    final title = _titleController.text.trim();
                                    final price = double.tryParse(_priceController.text.trim().replaceAll('৳', '').replaceAll('\$', '')) ?? 0.0;
                                    final desc = _descController.text.trim();

                                    String finalImageUrl = _uploadedImageUrl ?? '';
                                    
                                    // Upload to Firestore directly as Base64 (100% Guaranteed to work on Web)
                                    if (_uploadedImageBytes != null) {
                                      try {
                                        final base64String = base64Encode(_uploadedImageBytes!);
                                        finalImageUrl = 'data:image/jpeg;base64,$base64String';
                                        
                                        // Check if it exceeds Firestore limit (1MB roughly, we use 900KB to be safe)
                                        if (base64String.length > 900000) {
                                          throw Exception('Image is too large! Please select a smaller image (under 700KB) or take a screenshot of it.');
                                        }
                                      } catch (e) {
                                        throw Exception(e.toString());
                                      }
                                    }

                                    // Get current user info
                                    final user = FirebaseAuth.instance.currentUser;
                                    final sellerName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Anonymous Student';

                                    final newProduct = Product(
                                      id: '', // Will be set by provider/Firestore
                                      title: title,
                                      price: price,
                                      category: _selectedCategory,
                                      condition: _selectedCondition,
                                      description: desc,
                                      imageUrl: finalImageUrl,
                                      sellerName: sellerName,
                                      sellerCampus: 'UIU Campus', // Can be made dynamic later
                                    );

                                    await ref.read(marketplaceProvider.notifier).addProduct(newProduct);

                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('"$title" published successfully!'),
                                        backgroundColor: const Color(0xFF2563EB),
                                      ),
                                    );
                                    context.go('/marketplace');
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to publish: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isPublishing = false;
                                      });
                                    }
                                  }
                                },
                                icon: _isPublishing
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.rocket_launch_rounded, size: 18),
                                label: Text(
                                  _isPublishing ? 'Publishing...' : 'Publish Listing',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContainer({required String title, String? badge, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
    );
  }


}

// Custom Painter for dashed border rectangle container
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12)));

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    for (final pathMetric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
