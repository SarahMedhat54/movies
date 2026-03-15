import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/movie_model.dart';
import '../model/user_data.dart';

Future<void> createUserInFirestore(UserData user) async {
  var userCollection = FirebaseFirestore.instance.collection("users");
  // userCollection.add();
  var emptyDoc = userCollection.doc(
    user.id,
  ); // create or search for doc with id
  emptyDoc.set(user.toJson());

  ///JSON
}

Future<UserData> getUserFromFirestore(String uid) async {
  var userCollection = FirebaseFirestore.instance.collection("users");
  DocumentSnapshot snapshot = await userCollection.doc(uid).get();
  Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
  return UserData.fromJson(json);
}
