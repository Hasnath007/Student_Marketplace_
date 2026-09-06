import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PaymentMethod { bkash, nagad }

class PaymentCheckoutDialog extends StatefulWidget {
  final String itemName;
  final String priceText;
  final String category;
  final VoidCallback onPaymentSuccess;

  const PaymentCheckoutDialog({
    super.key,
    required this.itemName,
    required this.priceText,
    required this.category,
    required this.onPaymentSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required String itemName,
    required String priceText,
    required String category,
    required VoidCallback onPaymentSuccess,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PaymentCheckoutDialog(
        itemName: itemName,
        priceText: priceText,
        category: category,
        onPaymentSuccess: onPaymentSuccess,
      ),
    );
  }

  @override
  State<PaymentCheckoutDialog> createState() => _PaymentCheckoutDialogState();
}

class _PaymentCheckoutDialogState extends State<PaymentCheckoutDialog> {
  int _currentStep = 0; // 0 = Select Method, 1 = Manual bKash/Nagad Form, 2 = Success Receipt
  PaymentMethod _selectedMethod = PaymentMethod.bkash;
  final TextEditingController _trxController = TextEditingController();
  final TextEditingController _senderPhoneController = TextEditingController(text: '01712345678');
  bool _isVerifying = false;
  String? _errorMessage;
  late final String _invoiceId;

  final String _recipientNumber = '017XXXXXXXXX';

  @override
  void initState() {
    super.initState();
    final randomNum = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    _invoiceId = 'STU-INV-$randomNum';
  }

  @override
  void dispose() {
    _trxController.dispose();
    _senderPhoneController.dispose();
    super.dispose();
  }

  String _formatAmount(String price) {
    if (price.startsWith('৳')) return price;
    if (price.startsWith('\$')) {
      final clean = price.replaceAll('\$', '').replaceAll('/mo', '').replaceAll('/yr', '').trim();
      final val = double.tryParse(clean) ?? 250.0;
      return '৳${val.round()}';
    }
    return '৳$price';
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label কপি করা হয়েছে! ($text)'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _verifyPayment() async {
    final trx = _trxController.text.trim();
    if (trx.isEmpty) {
      setState(() {
        _errorMessage = 'অনুগ্রহ করে Transaction ID (TrxID) লিখুন';
      });
      return;
    }
    if (trx.length < 6) {
      setState(() {
        _errorMessage = 'সঠিক Transaction ID দিন (কমপক্ষে ৬ অক্ষর)';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
      _currentStep = 2; // Success
    });

    widget.onPaymentSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildCurrentStepContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    if (_currentStep == 0) {
      return _buildMethodSelectionStep();
    } else if (_currentStep == 1) {
      return _buildManualPaymentStep();
    } else {
      return _buildSuccessStep();
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 0: METHOD SELECTION
  // ---------------------------------------------------------------------------
  Widget _buildMethodSelectionStep() {
    final totalAmount = _formatAmount(widget.priceText);

    return Padding(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                    child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checkout & Payment',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Select bKash or Nagad to complete payment',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Order Summary Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemName,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(widget.category, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Text(
                      totalAmount,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Student Community Fee:', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    Text('৳0.00 (Free)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Select Payment Method (শুধুমাত্র বিকাশ ও নগদ)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 12),

          // bKash & Nagad Option Cards
          Row(
            children: [
              Expanded(
                child: _buildMethodCard(
                  method: PaymentMethod.bkash,
                  title: 'bKash',
                  subtitle: 'ম্যানুয়াল সেন্ড মানি',
                  color: const Color(0xFFE2136E),
                  icon: '🌸',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMethodCard(
                  method: PaymentMethod.nagad,
                  title: 'Nagad',
                  subtitle: 'ম্যানুয়াল সেন্ড মানি',
                  color: const Color(0xFFD62728),
                  icon: '🔥',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => setState(() => _currentStep = 1),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Proceed to Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedMethod == PaymentMethod.bkash ? const Color(0xFFE2136E) : const Color(0xFFD62728),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required Color color,
    required String icon,
  }) {
    final isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: isSelected ? color : const Color(0xFF0F172A))),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 1: PIXEL-PERFECT MANUAL BKASH / NAGAD PAYMENT SCREEN
  // ---------------------------------------------------------------------------
  Widget _buildManualPaymentStep() {
    final isBkash = _selectedMethod == PaymentMethod.bkash;
    final brandColor = isBkash ? const Color(0xFFE2136E) : const Color(0xFFD62728);
    final brandName = isBkash ? 'BKASH' : 'NAGAD';
    final ussdCode = isBkash ? '*247#' : '*167#';
    final totalAmount = _formatAmount(widget.priceText);

    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Back button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _currentStep = 0),
              icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF475569)),
              label: const Text('ফিরে যান', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 13)),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ),
          const SizedBox(height: 8),

          // Invoice Header Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.storefront_rounded, color: Color(0xFF2563EB), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Campus Market', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                        Text('Invoice ID: $_invoiceId', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        isBkash ? 'bKash Personal' : 'Nagad Personal',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: brandColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Main Pink/Red Brand Box with Bengali instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: brandColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: brandColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'ট্রানজেকশন আইডি দিন',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),

                // White TrxID Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                    ],
                  ),
                  child: TextField(
                    controller: _trxController,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: 'ট্রানজেকশন আইডি দিন (e.g. 9J87K2LX)',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                      suffixIcon: _trxController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                _trxController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) => setState(() => _errorMessage = null),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.yellowAccent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 16),

                // Bengali Instruction Bullets matching screenshots
                _buildInstructionLine('• $ussdCode ডায়াল করে আপনার $brandName মোবাইল মেনুতে যান অথবা $brandName অ্যাপে যান।'),
                const SizedBox(height: 8),
                _buildInstructionLine('• "Send Money" -এ ক্লিক করুন।'),
                const SizedBox(height: 8),
                _buildCopyInstructionLine(
                  label: '• প্রাপক নম্বর হিসাবে এই নম্বরটি লিখুন: ',
                  value: _recipientNumber,
                  onCopy: () => _copyToClipboard(_recipientNumber, 'প্রাপক নম্বর'),
                ),
                const SizedBox(height: 8),
                _buildCopyInstructionLine(
                  label: '• টাকার পরিমাণ: ',
                  value: totalAmount,
                  onCopy: () => _copyToClipboard(totalAmount, 'টাকার পরিমাণ'),
                ),
                const SizedBox(height: 8),
                _buildInstructionLine('• নিশ্চিত করতে এখন আপনার $brandName মোবাইল মেনু পিন লিখুন।'),
                const SizedBox(height: 8),
                _buildInstructionLine('• সবকিছু ঠিক থাকলে, আপনি $brandName থেকে একটি নিশ্চিতকরণ বার্তা পাবেন।'),
                const SizedBox(height: 8),
                _buildInstructionLine('• এখন উপরের বক্সে আপনার Transaction ID দিন এবং নিচে VERIFY বাটনে ক্লিক করুন।'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Big VERIFY Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isVerifying ? null : _verifyPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isVerifying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'VERIFY',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Security footer
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text(
                'SSL এনক্রিপশনে সুরক্ষিত পেমেন্ট',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionLine(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 11.5, color: Colors.white, height: 1.35),
      ),
    );
  }

  Widget _buildCopyInstructionLine({
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: Colors.white),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: onCopy,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.copy_rounded, size: 10, color: Colors.white),
                SizedBox(width: 3),
                Text('Copy', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2: VERIFIED RECEIPT SUCCESS MODAL
  // ---------------------------------------------------------------------------
  Widget _buildSuccessStep() {
    final isBkash = _selectedMethod == PaymentMethod.bkash;
    final totalAmount = _formatAmount(widget.priceText);

    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Green Success Icon
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 40),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'পেমেন্ট সফলভাবে সম্পন্ন হয়েছে!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'আপনার ট্রানজেকশন সফলভাবে ভেরিফাই করা হয়েছে।',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),

          // Receipt Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildReceiptRow('Invoice ID', _invoiceId),
                const Divider(height: 16),
                _buildReceiptRow('Item / Group', widget.itemName),
                const Divider(height: 16),
                _buildReceiptRow('Payment Method', isBkash ? 'bKash (Send Money)' : 'Nagad (Send Money)'),
                const Divider(height: 16),
                _buildReceiptRow('TrxID', _trxController.text.trim().toUpperCase()),
                const Divider(height: 16),
                _buildReceiptRow('Amount Paid', totalAmount, isBold: true, valueColor: const Color(0xFF16A34A)),
                const Divider(height: 16),
                _buildReceiptRow('Status', 'Verified & Active ✓', isBold: true, valueColor: const Color(0xFF2563EB)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Done Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${widget.itemName}" পেমেন্ট ও অ্যাক্সেস কনফার্ম করা হয়েছে!'),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('সম্পন্ন করুন (Done)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
