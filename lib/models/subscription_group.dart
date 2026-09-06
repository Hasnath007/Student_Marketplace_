class SubscriptionGroup {
  final String id;
  final String title;
  final String category;
  final double monthlyPricePerMember;
  final int currentMembers;
  final int maxMembers;
  final String description;
  final String platformLogoUrl;
  final String adminName;

  const SubscriptionGroup({
    required this.id,
    required this.title,
    required this.category,
    required this.monthlyPricePerMember,
    required this.currentMembers,
    required this.maxMembers,
    required this.description,
    required this.platformLogoUrl,
    required this.adminName,
  });
}
