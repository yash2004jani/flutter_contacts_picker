class Contact {
  final String displayName;
  final String? phoneNumber;
  final String? email;
  final String? photoUrl;
  final Map<String, dynamic>? extraData;

  Contact({
    required this.displayName,
    this.phoneNumber,
    this.email,
    this.photoUrl,
    this.extraData,
  });

  String get initials {
    if (displayName.isEmpty) return '';
    final parts = displayName.trim().split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
