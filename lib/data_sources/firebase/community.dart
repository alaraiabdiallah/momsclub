import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:momsclub/models/community_model.dart';

class CommunityFB {
  static Stream<QuerySnapshot> loadCommunities() => Firestore
    .instance
    .collection('communities')
    .where("active",isEqualTo: true)
    .snapshots();

  static Future<Community> loadCommunitiesByUserId(String id) async {
    var fb = await Firestore.instance.collection('communities').where("userId",isEqualTo: id).getDocuments();
    DocumentSnapshot doc = fb.documents.first;
    var data = doc.data;
    data['id'] = doc.documentID;
    return data != null ? Community.fromJson(data): null;
  } 
}