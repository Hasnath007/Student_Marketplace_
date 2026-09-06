import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;

  void _showEditProfileModal() {
    final bioController = TextEditingController(text: 'Senior CS student. Selling textbooks, electronics, and random dorm stuff.');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Bio & Campus Info',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Color(0xFF2563EB)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Banner Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with verified badge
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 46,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF2563EB),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Alex Rivera',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: _showEditProfileModal,
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF2563EB)),
                                  tooltip: 'Edit Profile',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.school_outlined, size: 16, color: Color(0xFF475569)),
                                const SizedBox(width: 4),
                                const Text('Stanford University', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                                const Text('  •  ', style: TextStyle(color: Color(0xFF94A3B8))),
                                const Icon(Icons.science_outlined, size: 16, color: Color(0xFF475569)),
                                const SizedBox(width: 4),
                                const Text('Computer Science', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                                const Text('  •  ', style: TextStyle(color: Color(0xFF94A3B8))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Joined Aug 2022', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Senior CS student. Selling textbooks, electronics, and random dorm stuff. Usually on campus near the engineering quad.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      // Sign Out Button
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                          context.go('/landing');
                        },
                        icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFDC2626)),
                        label: const Text('Sign Out', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEE2E2),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tabs Bar
                Row(
                  children: [
                    _buildTabItem(0, 'My Listings', '3'),
                    const SizedBox(width: 24),
                    _buildTabItem(1, 'My Joined Groups', '2'),
                    const SizedBox(width: 24),
                    _buildTabItem(2, 'Settings', null),
                  ],
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 24),

                // Dynamic Tab Content
                _buildTabContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Listings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/sell'),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Listing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildListingCard(
                  title: 'Calculus: Early Transcendentals 9th Edition',
                  price: '৳450',
                  desc: 'Used for one semester. Great condition, minimal highlighting.',
                  imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80',
                  status: 'Active',
                  isSold: false,
                  views: '12 views',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildListingCard(
                  title: 'Keychron K2 Wireless Mechanical Keyboard',
                  price: '৳1500',
                  desc: 'Brown switches. Includes original box and extra keycaps.',
                  imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=600&q=80',
                  status: 'Active',
                  isSold: false,
                  views: '45 views',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildListingCard(
                  title: 'IKEA Tertial Desk Lamp',
                  price: '৳350',
                  desc: 'Works perfectly, just upgraded my setup.',
                  imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&q=80',
                  status: 'Sold',
                  isSold: true,
                  views: 'Sold on Oct 12',
                ),
              ),
            ],
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Subscription Groups', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildJoinedGroupCard('Netflix Premium 4K', '৳250 / mo', 'Alex Chen (Host)', 'Next billing: Sep 25'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildJoinedGroupCard('Coursera Plus Annual', '৳1200 / yr', 'CS Study Group', 'Next billing: Jan 15'),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account & Privacy Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Campus Email Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Receive notifications when someone messages about your listing'),
                  value: true,
                  activeThumbColor: const Color(0xFF2563EB),
                  onChanged: (val) {},
                ),
                const Divider(),
                ListTile(
                  title: const Text('Campus Identity Verification', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Verified via alex.r@stanford.edu'),
                  trailing: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTabItem(int index, String label, String? count) {
    final isSelected = _selectedTab == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Column(
          children: [
            Row(
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  ),
                  child: Text(label),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              height: 2,
              width: isSelected ? 100 : 0,
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard({
    required String title,
    required String price,
    required String desc,
    required String imageUrl,
    required String status,
    required bool isSold,
    required String views,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          Stack(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 400,
                  cacheHeight: 250,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSold ? Colors.black.withValues(alpha: 0.6) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (!isSold)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                        ),
                      if (!isSold) const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSold ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(views, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                    if (!isSold) const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF64748B)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedGroupCard(String title, String price, String host, String billing) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6)),
                child: const Text('ACTIVE MEMBER', style: TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
          const SizedBox(height: 4),
          Text(host, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          Text(billing, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
