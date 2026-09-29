import 'package:flutter/material.dart';

class SubscriptionMember {
  final String name;
  final String role;
  final String status; // 'Active', 'Vacant'
  final String? avatarUrl;
  final String screenName;

  const SubscriptionMember({
    required this.name,
    required this.role,
    required this.status,
    this.avatarUrl,
    required this.screenName,
  });
}

class SubscriptionGroup {
  final String id;
  final String title;
  final String category;
  final double totalPrice;
  final int currentMembers;
  final int maxMembers;
  final String description;
  final String platformLogoUrl;
  final String adminName;
  final String period;
  final Color color;
  final String logoText;
  final String accountEmail;
  final String pinCode;
  final String assignedScreen;
  final List<SubscriptionMember> members;
  final bool isVerified;
  final bool isJoined;

  double get currentPricePerMember {
    if (maxMembers == 0) return totalPrice;
    return totalPrice / maxMembers;
  }

  double get progress => maxMembers > 0 ? currentMembers / maxMembers : 0;
  bool get isFull => currentMembers >= maxMembers;
  String get slotsText => isJoined ? 'Joined ✓' : '${maxMembers - currentMembers}/$maxMembers slots left';

  const SubscriptionGroup({
    required this.id,
    required this.title,
    required this.category,
    required this.totalPrice,
    required this.currentMembers,
    required this.maxMembers,
    required this.description,
    required this.platformLogoUrl,
    required this.adminName,
    this.period = '/mo',
    this.color = Colors.blue,
    this.logoText = 'S',
    this.accountEmail = '',
    this.pinCode = '',
    this.assignedScreen = '',
    this.members = const [],
    this.isVerified = false,
    this.isJoined = false,
  });
  
  SubscriptionGroup copyWith({
    int? currentMembers,
    bool? isJoined,
    List<SubscriptionMember>? members,
  }) {
    return SubscriptionGroup(
      id: id,
      title: title,
      category: category,
      totalPrice: totalPrice,
      currentMembers: currentMembers ?? this.currentMembers,
      maxMembers: maxMembers,
      description: description,
      platformLogoUrl: platformLogoUrl,
      adminName: adminName,
      period: period,
      color: color,
      logoText: logoText,
      accountEmail: accountEmail,
      pinCode: pinCode,
      assignedScreen: assignedScreen,
      members: members ?? this.members,
      isVerified: isVerified,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
