import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

class HostChatDialog extends StatefulWidget {
  final String hostName;
  final String groupTitle;
  final String? avatarUrl;
  final String? accountEmail;
  final String? pinCode;
  final String? assignedScreen;
  final bool isHostMode;
  final bool isSellerMode;

  const HostChatDialog({
    super.key,
    required this.hostName,
    required this.groupTitle,
    this.avatarUrl,
    this.accountEmail,
    this.pinCode,
    this.assignedScreen,
    this.isHostMode = false,
    this.isSellerMode = false,
  });

  static Future<void> show(
    BuildContext context, {
    required String hostName,
    required String groupTitle,
    String? avatarUrl,
    String? accountEmail,
    String? pinCode,
    String? assignedScreen,
    bool isHostMode = false,
    bool isSellerMode = false,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => HostChatDialog(
        hostName: hostName,
        groupTitle: groupTitle,
        avatarUrl: avatarUrl,
        accountEmail: accountEmail,
        pinCode: pinCode,
        assignedScreen: assignedScreen,
        isHostMode: isHostMode,
        isSellerMode: isSellerMode,
      ),
    );
  }

  @override
  State<HostChatDialog> createState() => _HostChatDialogState();
}

class _HostChatDialogState extends State<HostChatDialog> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String get _chatId {
    String hName = widget.hostName.trim();
    if (hName.startsWith('You')) {
      final user = FirebaseAuth.instance.currentUser;
      hName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Host';
    }
    final cleanTitle = widget.groupTitle.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final cleanHost = hName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return '${cleanTitle}_$cleanHost';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    _msgController.clear();

    final user = FirebaseAuth.instance.currentUser;
    final currentUserName = user?.displayName ?? user?.email?.split('@')[0] ?? 'You';
    final senderName = widget.isHostMode ? '$currentUserName (Admin)' : currentUserName;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add({
      'text': clean,
      'sender': senderName,
      'isHost': widget.isHostMode,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('chats').doc(_chatId).set({
      'lastMessage': clean,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'groupTitle': widget.groupTitle,
      'hostName': widget.hostName,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final isHost = widget.isHostMode;
    final isSeller = widget.isSellerMode;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 490,
        constraints: BoxConstraints(
          maxWidth: 490,
          maxHeight: (MediaQuery.of(context).size.height * 0.88).clamp(400.0, 640.0),
        ),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.borderColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isHost
                    ? const Color(0xFF0F172A)
                    : (isSeller ? const Color(0xFF1E1B4B) : const Color(0xFF1E293B)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isHost
                            ? const Color(0xFF10B981)
                            : (isSeller ? const Color(0xFF4F46E5) : const Color(0xFF3B82F6)),
                        backgroundImage: (!isHost && widget.avatarUrl != null) ? NetworkImage(widget.avatarUrl!) : null,
                        child: isHost
                            ? const Icon(Icons.shield_rounded, color: Colors.white, size: 20)
                            : (widget.avatarUrl == null
                                ? Text(
                                    widget.hostName.isNotEmpty ? widget.hostName[0].toUpperCase() : (isSeller ? 'S' : 'H'),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                                : null),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1E293B), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                isHost ? '${widget.groupTitle} (Host Hub)' : widget.hostName,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isHost
                                        ? const Color(0xFF10B981)
                                        : (isSeller ? const Color(0xFFF97316) : const Color(0xFF3B82F6)))
                                    .withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isHost ? 'YOU (ADMIN)' : (isSeller ? 'SELLER' : 'HOST'),
                                style: TextStyle(
                                  color: isHost
                                      ? const Color(0xFF6EE7B7)
                                      : (isSeller ? const Color(0xFFFDBA74) : const Color(0xFF93C5FD)),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHost
                              ? '3 Active Members in this group'
                              : (isSeller
                                  ? '${widget.groupTitle} • Verified Campus Seller'
                                  : '${widget.groupTitle} • Online'),
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
                    tooltip: 'Close Chat',
                  ),
                ],
              ),
            ),

            // Context Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isHost
                  ? const Color(0xFFECFDF5)
                  : (isSeller ? const Color(0xFFEEF2FF) : const Color(0xFFF1F5F9)),
              child: Row(
                children: [
                  Icon(
                    isHost
                        ? Icons.record_voice_over_rounded
                        : (isSeller ? Icons.storefront_rounded : Icons.shield_outlined),
                    size: 14,
                    color: isHost
                        ? const Color(0xFF059669)
                        : (isSeller ? const Color(0xFF4F46E5) : const Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isHost
                          ? 'Answer member queries & announce credentials as Host'
                          : (isSeller
                              ? 'Direct Campus Meetup & Order Chat for ${widget.groupTitle}'
                              : 'Direct End-to-End Chat for ${widget.groupTitle}'),
                      style: TextStyle(
                        fontSize: 11,
                        color: isHost
                            ? const Color(0xFF065F46)
                            : (isSeller ? const Color(0xFF3730A3) : const Color(0xFF475569)),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    isHost
                        ? '👑 Host Control'
                        : (isSeller ? '🤝 Campus Meetup' : '⚡ Fast Reply'),
                    style: TextStyle(
                      fontSize: 10,
                      color: isHost
                          ? const Color(0xFF059669)
                          : (isSeller ? const Color(0xFF4F46E5) : const Color(0xFF10B981)),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Messages Thread
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(_chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages yet. Say hi!',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final msg = doc.data() as Map<String, dynamic>;

                        final user = FirebaseAuth.instance.currentUser;
                        final currentUserName = user?.displayName ?? user?.email?.split('@')[0] ?? 'You';

                        final sender = msg['sender'] as String? ?? 'Unknown';
                        final isMe = sender == currentUserName || sender == '$currentUserName (Admin)';

                        String timeStr = 'Just now';
                        if (msg['timestamp'] != null) {
                          timeStr = DateFormat('hh:mm a').format((msg['timestamp'] as Timestamp).toDate());
                        }

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? (isHost ? const Color(0xFF059669) : const Color(0xFF2563EB))
                                  : context.containerBg,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 16),
                              ),
                              border: isMe ? null : Border.all(color: context.borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                if (!isMe) ...[
                                  Text(
                                    sender,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSeller ? const Color(0xFF4F46E5) : const Color(0xFF2563EB),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                ],
                                Text(
                                  msg['text'] as String? ?? '',
                                  style: TextStyle(
                                    color: isMe ? Colors.white : context.textPrimary,
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      timeStr,
                                      style: TextStyle(
                                        color: isMe ? Colors.white70 : context.textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (isMe) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.done_all_rounded, size: 12, color: Colors.white70),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Quick Answer Chips for Host, Seller, or Member
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: context.cardBg,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: isHost
                      ? [
                          _buildQuickChip('👋 Welcome', 'Welcome to the group! Everything is ready for you to enjoy.'),
                          const SizedBox(width: 6),
                          _buildQuickChip('✅ Confirm Payment', 'Thanks! Your payment is confirmed and slot is active.'),
                          const SizedBox(width: 6),
                          _buildQuickChip('⚙️ Check Vault', 'Please check the blue Credentials Vault on your screen for login details.'),
                        ]
                      : (isSeller
                          ? [
                              _buildQuickChip('📍 Central Library Meetup', 'Can we meet near Central Library today around 3:30 PM?'),
                              const SizedBox(width: 6),
                              _buildQuickChip('📖 Condition & Notes', 'Is the item in clean condition with no markings or missing pages?'),
                              const SizedBox(width: 6),
                              _buildQuickChip('⏰ Free for Handover?', 'Are you free on campus today for the handover?'),
                              const SizedBox(width: 6),
                              _buildQuickChip('💵 Is Price Negotiable?', 'Is the price negotiable if I collect it today?'),
                            ]
                          : [
                              _buildQuickChip('👋 Hi Host', 'Hi, I just joined the group!'),
                              const SizedBox(width: 6),
                              _buildQuickChip('⚙️ Issue with Login', 'I am having some trouble logging in. Can you help?'),
                              const SizedBox(width: 6),
                              _buildQuickChip('⚡ Slot Active?', 'Is my slot fully active now?'),
                            ]),
                ),
              ),
            ),

            Divider(height: 1, color: context.borderColor),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: context.cardBg,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      style: TextStyle(fontSize: 13, color: context.textPrimary),
                      decoration: InputDecoration(
                        hintText: isHost
                            ? 'Reply to members or send announcement as Host...'
                            : (isSeller
                                ? 'Type a message to ${widget.hostName} (Seller)...'
                                : 'Type a message to ${widget.hostName}...'),
                        hintStyle: TextStyle(fontSize: 13, color: context.textSecondary),
                        filled: true,
                        fillColor: context.containerBg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: isHost
                                  ? const Color(0xFF059669)
                                  : (isSeller ? const Color(0xFF4F46E5) : const Color(0xFF2563EB))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: isHost
                          ? const Color(0xFF059669)
                          : (isSeller ? const Color(0xFF4F46E5) : const Color(0xFF2563EB)),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _sendMessage(_msgController.text),
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      tooltip: isHost
                          ? 'Send Answer to Members'
                          : (isSeller ? 'Send Message to Seller' : 'Send Message'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, String messageToSend) {
    final isHost = widget.isHostMode;
    final isSeller = widget.isSellerMode;
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isHost
              ? const Color(0xFF059669)
              : (isSeller ? const Color(0xFF4F46E5) : const Color(0xFF2563EB)),
        ),
      ),
      backgroundColor: isHost
          ? (context.isDarkMode ? const Color(0xFF065F46).withValues(alpha: 0.3) : const Color(0xFFECFDF5))
          : (isSeller ? (context.isDarkMode ? const Color(0xFF3730A3).withValues(alpha: 0.3) : const Color(0xFFEEF2FF)) : (context.isDarkMode ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF))),
      side: BorderSide(
        color: isHost
            ? const Color(0xFF059669).withValues(alpha: 0.5)
            : (isSeller ? const Color(0xFF6366F1).withValues(alpha: 0.5) : const Color(0xFF3B82F6).withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onPressed: () => _sendMessage(messageToSend),
    );
  }
}
