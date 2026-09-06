import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFeatures() {
    _scrollController.animateTo(
      700,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _showHowItWorksModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        elevation: 8,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.help_outline_rounded, color: Color(0xFF2563EB), size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How Student Market Works',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Safe, verified student-to-student platform',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildHowItWorksStep(
                  num: '1',
                  title: 'Verified Student ID & .edu Email',
                  desc: 'Join with your official university credentials to browse listings and connect safely with verified peers.',
                  icon: Icons.verified_user_outlined,
                  color: const Color(0xFF2563EB),
                ),
                const SizedBox(height: 16),

                _buildHowItWorksStep(
                  num: '2',
                  title: 'Buy, Sell & Campus Meetups',
                  desc: 'Find textbooks, electronics, notes, and study gear from students near you. Meet up on campus with zero shipping costs.',
                  icon: Icons.storefront_outlined,
                  color: const Color(0xFF059669),
                ),
                const SizedBox(height: 16),

                _buildHowItWorksStep(
                  num: '3',
                  title: 'Split Group Subscriptions',
                  desc: 'Form or join groups for Netflix, Spotify, Adobe, or Coursera to share subscriptions and split bills automatically.',
                  icon: Icons.hub_outlined,
                  color: const Color(0xFF7C3AED),
                ),
                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _scrollToFeatures();
                      },
                      icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                      label: const Text('View All Features', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildHowItWorksStep({
    required String num,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Top Navigation Bar
            _buildNavbar(context),

            // Hero Section
            _buildHeroSection(context),

            // Trusted Universities Logos
            _buildTrustedSection(),

            // Features Grid
            _buildFeaturesSection(context),

            // Bottom CTA Banner
            _buildCtaSection(context),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Top Navbar
  // ---------------------------------------------------------------------------
  Widget _buildNavbar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF0F2F5))),
          ),
          child: Row(
            children: [
              // Logo
              InkWell(
                onTap: () => context.go('/landing'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.storefront_rounded, color: Color(0xFF2563EB), size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Student Marketplace',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              if (isDesktop) ...[
                // Navigation Links
                TextButton(
                  onPressed: () => context.go('/landing'),
                  child: const Text(
                    'Home',
                    style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2563EB), fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => context.go('/marketplace'),
                  child: const Text(
                    'Marketplace',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => context.go('/subscriptions'),
                  child: const Text(
                    'Subscription Groups',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontSize: 14),
                  ),
                ),
                const SizedBox(width: 24),
              ],

              // Login Button
              OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Hero Section
  // ---------------------------------------------------------------------------
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFAFAFC),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;

              final leftContent = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove_red_eye_outlined, size: 14, color: Color(0xFF4F46E5)),
                        SizedBox(width: 6),
                        Text(
                          'STUDENT EXCLUSIVE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4F46E5),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Heading
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        height: 1.15,
                        fontFamily: 'Roboto',
                      ),
                      children: [
                        TextSpan(text: 'The Marketplace for\n'),
                        TextSpan(
                          text: 'Students',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Buy and sell academic materials or share subscriptions\nwithin your university community. Secure, verified, and\nbuilt for your campus life.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // CTA Buttons Row
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/signup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Get Started', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: () => _showHowItWorksModal(context),
                        icon: const Icon(Icons.play_circle_outline_rounded, color: Color(0xFF475569), size: 20),
                        label: const Text(
                          'How it works',
                          style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Social Proof
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 32,
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 0,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100'),
                              ),
                            ),
                            const Positioned(
                              left: 20,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=100'),
                              ),
                            ),
                            const Positioned(
                              left: 40,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Joined by 10k+ students',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );

              final rightMockup = Container(
                constraints: const BoxConstraints(maxHeight: 460),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&q=80&w=1000',
                        fit: BoxFit.cover,
                        cacheWidth: 800,
                        cacheHeight: 440,
                        width: double.infinity,
                        height: 440,
                      ),
                    ),

                    // Overlay Badge 1 (Top Left)
                    Positioned(
                      top: 24,
                      left: -20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Color(0xFF2563EB), size: 18),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verified Seller', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                                Text('Calc 101 Textbook\nSold in 12 mins', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Overlay Badge 2 (Bottom Right)
                    Positioned(
                      bottom: 24,
                      right: -16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 15, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
                              child: const Icon(Icons.group_rounded, color: Color(0xFF2563EB), size: 16),
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Netflix Group', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                                Text('1 spot remaining', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: leftContent),
                    const SizedBox(width: 48),
                    Expanded(flex: 5, child: rightMockup),
                  ],
                );
              } else {
                return Column(
                  children: [
                    leftContent,
                    const SizedBox(height: 48),
                    rightMockup,
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Trusted Section Logos
  // ---------------------------------------------------------------------------
  Widget _buildTrustedSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'TRUSTED BY STUDENTS FROM TOP UNIVERSITIES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF94A3B8),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 48,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              _LogoItem(icon: Icons.diamond_outlined, text: 'FI'),
              _LogoItem(icon: Icons.change_history_rounded, text: 'AF'),
              _LogoItem(icon: Icons.square_outlined, text: 'DT'),
              _LogoItem(icon: Icons.pie_chart_outline_rounded, text: 'EI'),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Features Section (Bento Grid)
  // ---------------------------------------------------------------------------
  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Everything you need, right on campus.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Designed specifically to solve the hassle of student-to-student transactions.',
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 48),

              // Bento Grid Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 768;

                  if (isDesktop) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            // Card 1
                            Expanded(
                              flex: 6,
                              child: _buildBentoCard(
                                bgColor: const Color(0xFFEFF6FF),
                                icon: Icons.shopping_bag_outlined,
                                title: 'Frictionless Trading',
                                desc: 'Buy and sell textbooks, electronics, and dorm essentials instantly. No shipping, no scammers, just meet up on campus.',
                                rightWidget: Container(
                                  width: 140,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                                    ],
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.inventory_2_outlined, color: Color(0xFF2563EB), size: 32),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Card 2
                            Expanded(
                              flex: 4,
                              child: _buildBentoCard(
                                bgColor: const Color(0xFFF1F5F9),
                                icon: Icons.verified_user_outlined,
                                title: 'Verified Security',
                                desc: 'Every user requires a valid .edu email address to join.',
                                rightWidget: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '***@UNIVERSITY.EDU',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Card 3 (Full width dark card)
                        _buildBentoCard(
                          bgColor: const Color(0xFF1E293B),
                          textColor: Colors.white,
                          subtitleColor: const Color(0xFF94A3B8),
                          icon: Icons.pie_chart_outline_rounded,
                          title: 'Split Costs, Keep Access',
                          desc: 'Form subscription groups for streaming services, software, or premium tools. Manage payments and access automatically without the awkward text messages.',
                          rightWidget: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.hub_rounded, color: Color(0xFF60A5FA), size: 36),
                                SizedBox(width: 12),
                                Text('৳250 / mo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildBentoCard(
                          bgColor: const Color(0xFFEFF6FF),
                          icon: Icons.shopping_bag_outlined,
                          title: 'Frictionless Trading',
                          desc: 'Buy and sell textbooks, electronics, and dorm essentials instantly. No shipping, no scammers, just meet up on campus.',
                        ),
                        const SizedBox(height: 20),
                        _buildBentoCard(
                          bgColor: const Color(0xFFF1F5F9),
                          icon: Icons.verified_user_outlined,
                          title: 'Verified Security',
                          desc: 'Every user requires a valid .edu email address to join.',
                        ),
                        const SizedBox(height: 20),
                        _buildBentoCard(
                          bgColor: const Color(0xFF1E293B),
                          textColor: Colors.white,
                          subtitleColor: const Color(0xFF94A3B8),
                          icon: Icons.pie_chart_outline_rounded,
                          title: 'Split Costs, Keep Access',
                          desc: 'Form subscription groups for streaming services, software, or premium tools.',
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required Color bgColor,
    Color textColor = const Color(0xFF0F172A),
    Color subtitleColor = const Color(0xFF64748B),
    required IconData icon,
    required String title,
    required String desc,
    Widget? rightWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: textColor == Colors.white ? Colors.white : const Color(0xFF2563EB), size: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: TextStyle(fontSize: 14, height: 1.5, color: subtitleColor),
                ),
              ],
            ),
          ),
          if (rightWidget != null) ...[
            const SizedBox(width: 24),
            rightWidget,
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. CTA Section
  // ---------------------------------------------------------------------------
  Widget _buildCtaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEEF2FF),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Ready to join your Student market?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Stop overpaying for textbooks and start saving with your\npeers today.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text(
              'Create Your Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Requires a valid university email address.',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Footer
  // ---------------------------------------------------------------------------
  Widget _buildFooter(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20, vertical: 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: isDesktop
              ? Row(
                  children: [
                    // Left Logo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.storefront_rounded, color: Color(0xFF2563EB), size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Campus Market',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Links
                    const Text('About', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    const SizedBox(width: 24),
                    const Text('Support', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    const SizedBox(width: 24),
                    const Text('Terms', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                    const SizedBox(width: 24),
                    const Text('Privacy', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),

                    const Spacer(),

                    // Copyright
                    const Text(
                      '© 2024 Campus Market. Built for Students.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.storefront_rounded, color: Color(0xFF2563EB), size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Campus Market',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        Text('About', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        Text('Support', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        Text('Terms', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        Text('Privacy', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '© 2024 Campus Market. Built for Students.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _LogoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LogoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF64748B), size: 22),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF475569),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
