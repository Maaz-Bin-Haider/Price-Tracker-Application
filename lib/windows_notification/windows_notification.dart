
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

double cleanAndParsePrice(String price) {
  // Remove currency symbols and non-numeric characters except the decimal point
  String cleanedPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
  return double.tryParse(cleanedPrice) ?? 0.0;
}
// Store sent notifications (IDs or product names) in memory
Set<String> sentNotifications = {};

Future<void> checkAndSendNotifications() async {
  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Collection names
  List<String> collections = ['Harvey Norman','Amazon UAE','Bunnings AUS','Noon UAE','Amazon USA','JB Hifi'];

  // Create an instance of WindowsNotification
  

  // Loop through each collection
  for (String collection in collections) {
    QuerySnapshot querySnapshot = await firestore.collection(collection).get();

    // Loop through each document in the collection
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Clean and parse the productPrice and targetedPrice
      String productName = data['Product Name'].toString();
      String siteName = data['Website Name'].toString();
      double productPrice = cleanAndParsePrice(data['productPrice'].toString());
      double targetedPrice = cleanAndParsePrice(data['Targeted Price'].toString());

      print(productPrice);
      print(targetedPrice);

      String uniqueId = productName;
      final _winNotifyPlugin = WindowsNotification(applicationId: uniqueId);
      if (productPrice <= targetedPrice && !sentNotifications.contains(uniqueId)) { 
        // Send notification if the productPrice meets or goes below the targetedPrice
        NotificationMessage message = NotificationMessage.fromPluginTemplate(
          'Scraper' ,                              // Notification ID
          "Scraper Price Alert! $siteName ",                      // Notification title
          "The price has dropped to $productPrice, for the product $productName",  // Notification body
        );

        // Show the notification
        _winNotifyPlugin.showNotificationPluginTemplate(message);
        sentNotifications.add(uniqueId);
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }
}
