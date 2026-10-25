class ImprovePrompt {
  const ImprovePrompt();

  String call(String prompt) {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) return 'Create a QR code for my business';
    return 'Create a high-quality QR code: $trimmed';
  }
}
