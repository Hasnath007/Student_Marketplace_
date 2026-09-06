import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/subscription_group.dart';

final sampleSubscriptions = [
  const SubscriptionGroup(
    id: 's1',
    title: 'Netflix Premium 4K UHD',
    category: 'Entertainment',
    monthlyPricePerMember: 4.50,
    currentMembers: 3,
    maxMembers: 4,
    description: 'Looking for 1 more member to share a Netflix Premium plan. Paid monthly via bKash/Nagad.',
    platformLogoUrl: 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?auto=format&fit=crop&w=300&q=80',
    adminName: 'Farhan Kabir',
  ),
  const SubscriptionGroup(
    id: 's2',
    title: 'Spotify Family Plan',
    category: 'Music',
    monthlyPricePerMember: 2.00,
    currentMembers: 5,
    maxMembers: 6,
    description: '1 slot open in Spotify Family. Automated monthly reminders, instant invitation code.',
    platformLogoUrl: 'https://images.unsplash.com/photo-1614680376593-902f749f7b64?auto=format&fit=crop&w=300&q=80',
    adminName: 'Ayesha Chowdhury',
  ),
  const SubscriptionGroup(
    id: 's3',
    title: 'Grammarly Premium Academic',
    category: 'Education',
    monthlyPricePerMember: 5.00,
    currentMembers: 2,
    maxMembers: 5,
    description: 'Share Grammarly Premium for thesis writing and paper submissions. 3 slots left.',
    platformLogoUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=300&q=80',
    adminName: 'Sadia Islam',
  ),
  const SubscriptionGroup(
    id: 's4',
    title: 'ChatGPT Plus Team',
    category: 'AI Tools',
    monthlyPricePerMember: 7.00,
    currentMembers: 4,
    maxMembers: 5,
    description: 'Shared GPT-4o & Claude 3.5 access for computer science projects.',
    platformLogoUrl: 'https://images.unsplash.com/photo-1677442136019-21780efad99a?auto=format&fit=crop&w=300&q=80',
    adminName: 'Imtiaz Hossain',
  ),
];

class SubscriptionsNotifier extends Notifier<List<SubscriptionGroup>> {
  @override
  List<SubscriptionGroup> build() => sampleSubscriptions;

  void addGroup(SubscriptionGroup group) {
    state = [group, ...state];
  }
}

final subscriptionsProvider = NotifierProvider<SubscriptionsNotifier, List<SubscriptionGroup>>(SubscriptionsNotifier.new);
