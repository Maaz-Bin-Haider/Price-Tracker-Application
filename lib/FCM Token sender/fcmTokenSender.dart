import 'package:cloud_firestore/cloud_firestore.dart';

fcmTokenSender({String? fCMToken}) async{
  try {
      if (fCMToken != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Check if the token already exists in the Firestore collection
        QuerySnapshot snapshot = await firestore.collection('FCMTokens').where('fcmToken', isEqualTo: fCMToken).get();

        if (snapshot.docs.isEmpty) {
          // If the token doesn't exist, add it to the Firestore collection
          await firestore.collection('FCMTokens').add({
            'fcmToken': fCMToken,
            'timestamp': FieldValue.serverTimestamp(), // Optional: Add a timestamp
          });

          print('FCM token added');
        } else {
          // If the token is already present, log that it's already stored
          print('FCM token already stored');
        }
      } else {
        print('No FCM token available');
      }
    } catch (e) {
      print('Error storing FCM token: $e');
    }
}