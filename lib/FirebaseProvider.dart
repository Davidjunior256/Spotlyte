import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  Future<List<DocumentSnapshot>> fetchFirstList() async {
    return (await Firestore.instance
            .collection("Groups")
            .orderBy("groupName")
            .limit(20)
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList) async {
    return (await Firestore.instance
            .collection("Groups")
            .orderBy("groupName")
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .getDocuments())
        .documents;
  }
}
