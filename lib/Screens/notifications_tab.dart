import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  NotificationsTab({super.key});
  final bool isWindows = Platform.isWindows;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isWindows?const EdgeInsets.all(20): const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Notifications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading indicator
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No data available')); // No data message
          } else {
            final List notifications = snapshot.data!.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(notifications[index]['siteName'],style: maininstructionsStyle(),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The price dropped to ${notifications[index]['newPrice']} ',
                          style: TextStyle(
                            fontSize: isWindows? 25: 14,
                            fontWeight: isWindows? FontWeight.bold: FontWeight.w600,
                            color:const Color.fromRGBO(47, 79, 79, 0.9),
                          )
                        ),
                        Text('For ${notifications[index]['name']}',style: instructionsStyle(),),
                        Text('from ${notifications[index]['target']}',style: instructionsStyle(),)
                      ],
                    ),
                    
                  ),
                );
              },
              itemCount: notifications.length,
            ) ;
          }
        }
      ),
    );
  }
}

TextStyle instructionsStyle(){
  return  TextStyle(
    color: const Color.fromARGB(255, 62, 61, 61),
    fontSize: Platform.isWindows? 25: 12,
    fontWeight: Platform.isWindows? FontWeight.w400: FontWeight.w500
  );
}

TextStyle maininstructionsStyle(){
  return  TextStyle(
    color: const Color.fromARGB(255, 79, 77, 77),
    fontSize:  Platform.isWindows? 25: 16,
    fontWeight: FontWeight.w700,
  );
}