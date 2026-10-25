import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/features/ai_generator/presentation/widgets/prompt_box.dart';
import 'package:qr_toolkit/features/ai_generator/presentation/widgets/suggestion_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum MessageType { ai, user }

class ChatMessage {
  final String text;
  final MessageType type;
  final bool hasQrCode;
  final Map<String, String>? qrDetails;

  const ChatMessage({
    required this.text,
    required this.type,
    this.hasQrCode = false,
    this.qrDetails,
  });
}

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSuggestions = true;

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: "Hi! I'm your AI QR assistant. Describe what you want to create.",
      type: MessageType.ai,
    ),
  ];

  final List<String> _suggestions = [
    'Create a QR code for my WiFi network',
    'Generate a QR code linking to my website',
    'Make a QR code for my business card',
    'Design a colorful QR code for my event',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _showSuggestions = false;
      _messages.add(ChatMessage(text: text, type: MessageType.user));
      _controller.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(const ChatMessage(
          text: 'Great! I can help you create a WiFi QR code.',
          type: MessageType.ai,
          hasQrCode: true,
          qrDetails: {
            'networkName': 'MyWiFiNetwork',
            'security': 'WPA2',
            'password': '********',
          },
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.lightTextPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('AI QR Generator', style: AppTypography.titleLarge.copyWith(
          color: AppColors.lightTextPrimary,
        )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _showSuggestions
                ? _buildSuggestionsView()
                : _buildChatView(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          _buildAiMessage(
            "Hi! I'm your AI QR assistant. Describe what you want to create.",
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Suggestions', style: AppTypography.labelMedium.copyWith(
            color: AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: AppSpacing.md),
          ..._suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SuggestionCard(
                title: suggestion,
                onTap: () => _sendMessage(suggestion),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChatView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        if (message.type == MessageType.user) {
          return _buildUserMessage(message.text);
        }
        return _buildAiMessageWithContent(message);
      },
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.lg),
            topRight: Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(AppRadius.lg),
            bottomRight: Radius.circular(AppRadius.sm),
          ),
        ),
        child: Text(
          text,
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAiMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.sm),
            topRight: Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(AppRadius.lg),
            bottomRight: Radius.circular(AppRadius.lg),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(text, style: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextPrimary,
        )),
      ),
    );
  }

  Widget _buildAiMessageWithContent(ChatMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.sm),
                  topRight: Radius.circular(AppRadius.lg),
                  bottomLeft: Radius.circular(AppRadius.lg),
                  bottomRight: Radius.circular(AppRadius.lg),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(message.text, style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextPrimary,
              )),
            ),
            if (message.hasQrCode) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildQrCodeCard(message),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQrCodeCard(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppRadius.mdRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: AppRadius.smRadius,
            child: QrImageView(
              data: 'WIFI:T:WPA;S:${message.qrDetails?['networkName'] ?? 'Network'};P:${message.qrDetails?['password'] ?? 'password'};;',
              size: 160,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDetailRow('Network', message.qrDetails?['networkName'] ?? 'N/A'),
          const SizedBox(height: AppSpacing.xs),
          _buildDetailRow('Security', message.qrDetails?['security'] ?? 'N/A'),
          const SizedBox(height: AppSpacing.xs),
          _buildDetailRow('Password', message.qrDetails?['password'] ?? 'N/A'),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.smRadius,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                  ),
                  child: const Text('Customize QR'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _sendMessage('Create another QR code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.smRadius,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                    elevation: 0,
                  ),
                  child: const Text('Generate Another'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: PromptBox(
              controller: _controller,
              onSubmit: () => _sendMessage(_controller.text),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
