import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAqXW_gQuL25GRLjxTjFaB-rKLiZB5RTVk",
            authDomain: "attendrix-app.firebaseapp.com",
            projectId: "attendrix-app",
            storageBucket: "attendrix-app.firebasestorage.app",
            messagingSenderId: "1058303346843",
            appId: "1:1058303346843:web:c5420d5a78f696eb6bde3e",
            measurementId: "G-PDRWN6M40H"));
  } else {
    await Firebase.initializeApp();
  }
}
