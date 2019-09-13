// TODO: use state management of flutter
import 'package:cloud_firestore/cloud_firestore.dart';
class DataService {
  String origin = 'Kothrud, Pune';
  String destination;
  List<String> topics = [];

  void loadProfile(profileId) async {
    Firestore.instance
            .collection('insta_users')
            .document(profileId)
            .snapshots();
  }
}

DataService dataService = new DataService();