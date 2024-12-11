import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class Services extends GetxController{

  List<String> website_Names = ['Harvey Norman','Amazon UAE','Bunnings AUS','Noon UAE','Amazon USA','JB Hifi'];
  var selectedSiteForDropdown = Rx<String?>(null);


  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to add new product to database with respective website
  Future sendProductDetails(
    String productName,
    String websiteName,
    String url,
    String targetedPrice,
  ) 
  async{

      firestore.collection(websiteName).doc(productName).set({
        'Product Name': productName,
        'Website Name': websiteName,
        'Url': url,
        'Targeted Price': targetedPrice,
      });
  }

  Future<void> editProductDetails(
    String websiteName,
    String productName,
    String targetedPrice,
  )
  async{
    await firestore.collection(websiteName).doc(productName).update({
      'Targeted Price': targetedPrice
    });
  }
  Future<void> deleteProduct(
    String websiteName,
    String productName,
  )
  async{
    await firestore.collection(websiteName).doc(productName).delete();
  }
}