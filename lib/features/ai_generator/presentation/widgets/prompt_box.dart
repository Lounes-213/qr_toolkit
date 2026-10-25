import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';

class PromptBox extends StatelessWidget {
  const PromptBox({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(
          color: AppColors.withOpacity(const Color(0xFFFFFFFF), 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Describe what you want...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryLight),
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
