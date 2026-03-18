import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

Future<void> updateUserInFirestore(UserData user) async {
  var userCollection = FirebaseFirestore.instance.collection("users");
  await userCollection.doc(user.id).update(user.toJson());
}

Future<void> toggleWatchList(MovieModel movie) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final docId = "${user.uid}_${movie.id}";

  final docRef =
  FirebaseFirestore.instance.collection("watchlist").doc(docId);

  final snapshot = await docRef.get();

  if (snapshot.exists) {
    /// remove movie
    await docRef.delete();

  } else {
    /// add movie
    await docRef.set({
      "userId": user.uid,
      "movieId": movie.id,
      "title": movie.title,
      "image": movie.image,
      "rating": movie.rating,
      "runtime": movie.runtime,
      "year": movie.year,
    });
  }
}
Future<bool> isMovieBookmarked(MovieModel movie) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return false;

  final docId = "${user.uid}_${movie.id}";

  final doc = await FirebaseFirestore.instance
      .collection("watchlist")
      .doc(docId)
      .get();

  return doc.exists;
}




