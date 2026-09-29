import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionsNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    _listenToSubscriptions();
    return [];
  }

  void _listenToSubscriptions() {
    FirebaseFirestore.instance
        .collection('subscriptions')
        .snapshots()
        .listen((snapshot) {
      final groups = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        if (data['color'] is int) {
          data['color'] = Color(data['color']);
        }
        return data;
      }).toList();
      state = groups;
    }, onError: (error) {
      // Handle error or set empty state on error
      state = [];
    });
  }

  Future<void> addGroup(Map<String, dynamic> group) async {
    final Map<String, dynamic> dataToSave = Map.from(group);
    if (dataToSave['color'] is Color) {
      dataToSave['color'] = (dataToSave['color'] as Color).value;
    }
    dataToSave.remove('id'); 
    await FirebaseFirestore.instance.collection('subscriptions').add(dataToSave);
  }

  Future<void> updateGroup(String id, Map<String, dynamic> updatedGroup) async {
    final Map<String, dynamic> dataToUpdate = Map.from(updatedGroup);
    if (dataToUpdate['color'] is Color) {
      dataToUpdate['color'] = (dataToUpdate['color'] as Color).value;
    }
    dataToUpdate.remove('id');
    await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(id)
        .update(dataToUpdate);
  }

  Future<void> deleteGroup(String id) async {
    await FirebaseFirestore.instance.collection('subscriptions').doc(id).delete();
  }
}

final subscriptionsProvider =
    NotifierProvider<SubscriptionsNotifier, List<Map<String, dynamic>>>(
        SubscriptionsNotifier.new);
