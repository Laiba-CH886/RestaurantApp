// lib/helpers/firebase_helper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kkgfrontend/utils/constants.dart'; // Corrected import path


class FirebaseHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // 1. Get Current User
  static User? get currentUser => _auth.currentUser;

  // 2. Sign Up User
  static Future<User?> signUpUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // 3. Sign In User
  static Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  // 4. Sign Out User
  static Future<void> signOutUser() async {
    await _auth.signOut();
  }

  // 5. Get User Data from Firestore
  static Future<DocumentSnapshot?> getUserData(String uid) async {
    try {
      return await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
    } catch (e) {
      print("Get User Data Error: $e");
      return null;
    }
  }

  // 6. Add Food Item to Firestore
  static Future<void> addFoodItem(Map<String, dynamic> foodData) async {
    try {
      await _firestore.collection(AppConstants.foodItemsCollection).add(foodData);
    } catch (e) {
      print("Add Food Item Error: $e");
    }
  }

  // 7. Get Food Items List
  static Future<List<DocumentSnapshot>> getFoodItems() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection(AppConstants.foodItemsCollection).get();
      return querySnapshot.docs;
    } catch (e) {
      print("Get Food Items Error: $e");
      return [];
    }
  }

  // 8. Upload Image to Firebase Storage
  static Future<String?> uploadImage(String filePath, String fileName) async {
    try {
      Reference ref = _storage.ref().child("${AppConstants.foodImagesPath}$fileName");
      UploadTask uploadTask = ref.putFile(filePath as dynamic);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image Upload Error: $e");
      return null;
    }
  }
}
