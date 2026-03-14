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

// ده التعديل

Future<void> toggleWishlist(MovieModel movie) async {
  String? uid = UserData.currentUser?.id;

  if (uid == null) {
    print("User is not logged in!");
    return;
  }
  var docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("wishlist")
      .doc(movie.id.toString());
  var doc = await docRef.get();

  if (doc.exists) {
    await docRef.delete();
    print("Movie removed from wishlist");
  } else {
    await docRef.set(movie.toJson());
    print("Movie added to wishlist");
  }
}