import 'dart:async';
import 'package:flutter/material.dart';

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
  bool _isTyping = false;

  late final List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    if (widget.isHostMode) {
      // Host Perspective: Members are asking the Host questions!
      _messages = [
        {
          'isMe': false,
          'sender': 'Sarah Jenkins (Member)',
          'text': 'Hi Alex! I just paid my monthly share via bKash. Could you confirm?',
          'time': '10:15 AM',
        },
        {
          'isMe': false,
          'sender': 'Tanvir Hossain (Member)',
          'text': 'Alex, is the new token or profile PIN updated for this month?',
          'time': '10:22 AM',
        },
      ];
    } else if (widget.isSellerMode) {
      // Marketplace Buyer Perspective: Buyer is chatting with the Campus Seller
      _messages = [
        {
          'isMe': false,
          'sender': widget.hostName,
          'text': 'Hi! Thanks for checking out "${widget.groupTitle}". 👋',
          'time': 'Just now',
        },
        {
          'isMe': false,
          'sender': widget.hostName,
          'text': 'Feel free to ask any questions about product condition, handover location (Central Library / TSC), or timing on campus!',
          'time': 'Just now',
        },
      ];
    } else {
      // Subscription Member Perspective: Member is chatting with the Group Host
      _messages = [
        {
          'isMe': false,
          'sender': widget.hostName,
          'text': 'Hi! Welcome to the ${widget.groupTitle} split group. 👋',
          'time': 'Just now',
        },
        {
          'isMe': false,
          'sender': widget.hostName,
          'text': 'I manage this subscription. Feel free to ask any questions about profile access, PIN, or payment.',
          'time': 'Just now',
        },
      ];
    }
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

  void _sendMessage(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    _msgController.clear();
    setState(() {
      _messages.add({
        'isMe': true,
        'sender': widget.isHostMode ? 'You (Host / Admin)' : 'You',
        'text': clean,
        'time': 'Just now',
      });
    });
    _scrollToBottom();

    if (widget.isHostMode) {
      // Host answered members -> Members acknowledge!
      _simulateMemberAcknowledgement();
    } else {
      // Member asked Host -> Host answers!
      _simulateHostReply(clean);
    }
  }

  void _simulateMemberAcknowledgement() {
    setState(() => _isTyping = true);
    _scrollToBottom();

    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add({
          'isMe': false,
          'sender': 'Sarah Jenkins (Member)',
          'text': 'Got it, thank you so much Alex! Working great now 👍',
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
  }

  void _simulateHostReply(String userMessage) {
    setState(() => _isTyping = true);
    _scrollToBottom();

    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final lower = userMessage.toLowerCase();
      String reply;

      if (widget.isSellerMode) {
        if (lower.contains('meet') ||
            lower.contains('where') ||
            lower.contains('library') ||
            lower.contains('লাইব্রেরি') ||
            lower.contains('tsc') ||
            lower.contains('ক্যাম্পাস') ||
            lower.contains('দেখা') ||
            lower.contains('জায়গা')) {
          reply = 'Sure! I am on campus today and can meet near Central Library or TSC around 3:30 PM. Let me know when you arrive!';
        } else if (lower.contains('condition') ||
            lower.contains('page') ||
            lower.contains('বই') ||
            lower.contains('অবস্থা') ||
            lower.contains('ছিঁড়া') ||
            lower.contains('fresh')) {
          reply = 'The item is in great condition, properly preserved with clean pages and no missing sections.';
        } else if (lower.contains('price') ||
            lower.contains('টাকা') ||
            lower.contains('দাম') ||
            lower.contains('discount') ||
            lower.contains('কম')) {
          reply = 'The price is already student-discounted, but I can offer a small ৳20-30 concession if you pick it up today!';
        } else if (lower.contains('paid') ||
            lower.contains('payment') ||
            lower.contains('bkash') ||
            lower.contains('nagad') ||
            lower.contains('টাকা পাঠিয়েছি')) {
          reply = 'Received your payment escrow notification! I will bring the item directly to our meetup spot.';
        } else if (lower.contains('hi') ||
            lower.contains('hello') ||
            lower.contains('hey') ||
            lower.contains('সালাম')) {
          reply = 'Hello! Yes, "${widget.groupTitle}" is still available. When would you like to collect it on campus?';
        } else {
          reply = 'Got your message! Let me know what time works best for you to meet on campus for the handover. 😊';
        }
      } else {
        if (lower.contains('pin') || lower.contains('password') || lower.contains('code') || lower.contains('লগইন')) {
          reply = 'Your profile PIN is "${widget.pinCode ?? '5829'}" for ${widget.assignedScreen ?? 'Screen 3'}. Enter it on your device to log in!';
        } else if (lower.contains('invite') || lower.contains('email') || lower.contains('link') || lower.contains('ইমেইল')) {
          reply = 'I have sent the family plan invite link to ${widget.accountEmail ?? 'your campus email'}. Please check your inbox!';
        } else if (lower.contains('payment') || lower.contains('bkash') || lower.contains('nagad') || lower.contains('টাকা')) {
          reply = 'Payment verified successfully! Your slot is 100% active for the entire month.';
        } else if (lower.contains('hi') || lower.contains('hello') || lower.contains('hey') || lower.contains('সালাম')) {
          reply = 'Hello! Hope everything is working smoothly with ${widget.groupTitle}. Let me know if you face any issues!';
        } else {
          reply = 'Thanks for your message! Everything is set up for you. Enjoy streaming/access! 😊';
        }
      }

      setState(() {
        _isTyping = false;
        _messages.add({
          'isMe': false,
          'sender': widget.hostName,
          'text': reply,
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
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
        height: 620,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isMe = msg['isMe'] as bool;
                    final sender = msg['sender'] as String?;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? (isHost ? const Color(0xFF059669) : const Color(0xFF2563EB))
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
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
                            if (!isMe && sender != null) ...[
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
                              msg['text'] as String,
                              style: TextStyle(
                                color: isMe ? Colors.white : const Color(0xFF1E293B),
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  msg['time'] as String,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : const Color(0xFF94A3B8),
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
                ),
              ),
            ),

            // Typing Indicator
            if (_isTyping)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                color: const Color(0xFFF8FAFC),
                child: Text(
                  isHost ? 'Sarah Jenkins is typing...' : '${widget.hostName} is typing...',
                  style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                ),
              ),

            // Quick Answer Chips for Host, Seller, or Member
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: isHost
                      ? [
                          _buildQuickChip('🔑 Send PIN (5829)', 'Hi Sarah & Tanvir, your profile PIN for this month is 5829!'),
                          const SizedBox(width: 6),
                          _buildQuickChip('✅ Confirm Payment', 'Thanks! Your monthly payment has been verified and confirmed.'),
                          const SizedBox(width: 6),
                          _buildQuickChip('🔗 Invite Link Sent', 'I have approved and sent the new invite link to your campus emails.'),
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
                              _buildQuickChip('🔑 Need Profile PIN', 'Can you please give me the profile PIN?'),
                              const SizedBox(width: 6),
                              _buildQuickChip('📩 Resend Invite Link', 'Could you resend the family invite link?'),
                              const SizedBox(width: 6),
                              _buildQuickChip('⚡ Slot Active?', 'Is my slot fully active now?'),
                            ]),
                ),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: isHost
                            ? 'Reply to members or send announcement as Host...'
                            : (isSeller
                                ? 'Type a message to ${widget.hostName} (Seller)...'
                                : 'Type a message to ${widget.hostName}...'),
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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
          ? const Color(0xFFECFDF5)
          : (isSeller ? const Color(0xFFEEF2FF) : const Color(0xFFEFF6FF)),
      side: BorderSide(
        color: isHost
            ? const Color(0xFFA7F3D0)
            : (isSeller ? const Color(0xFFC7D2FE) : const Color(0xFFBFDBFE)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onPressed: () => _sendMessage(messageToSend),
    );
  }
}
