import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scraper/Services/services.dart';
import 'dart:io';
class NoonUAE extends StatelessWidget {
  NoonUAE({super.key});
  final bool isWindows = Platform.isWindows;
  final Services service = Get.find<Services>();
  String siteName = 'Noon UAE';

  String targetedPrice = '';
  final TextEditingController _targatedPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isWindows ? 160 : 80),
        child: AppBar(
          toolbarHeight: isWindows ? 240.0 : 66.0,      
          title: Text(
            siteName,
            style:  TextStyle(
              color:  Color.fromRGBO(227, 228, 228, 0.941),
              fontWeight: FontWeight.bold,
              fontSize: isWindows ? 80:32
            ),
          ),
          backgroundColor:  const Color.fromRGBO(47, 79, 79, 0.9),
          centerTitle: isWindows ? true: false,
          leading: Container(
            margin: const EdgeInsets.only(left: 10),
            child: IconButton(
              style: IconButton.styleFrom( 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55)
                ),
                // padding: isWindows? const EdgeInsets.only(left: 0) : const EdgeInsets.only(left: 10),
                splashFactory: NoSplash.splashFactory, 
                highlightColor: const Color.fromARGB(24, 208, 203, 203), 
                backgroundColor: Colors.transparent, 
                iconSize: isWindows? 65: 24,
                hoverColor: Colors.transparent,
                    
              ),
              icon: const Icon(Icons.arrow_back_ios,color: Color.fromARGB(255, 252, 251, 251),), // Custom icon
              onPressed: () {
                Navigator.pop(context); // Action to perform when pressed
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(siteName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading indicator
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No data available')); // No data message
          } else {
            final List itemDocuments = snapshot.data!.docs;
            return Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final isProductPriceExists = itemDocuments[index].data().containsKey('productPrice');
                  double screenWidth = MediaQuery.of(context).size.width; 
                  // Calculate 70% of the screen width
                  double containerWidth = isWindows?screenWidth * 0.45 : screenWidth * 0.8;
                  return ListTile(
                    title: Text(
                      itemDocuments[index]['Product Name'],
                      style:  TextStyle(
                        color: const Color.fromRGBO(47, 79, 79, 0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: isWindows? 35: 20,
                      ),
                    ),
                    subtitle: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [  
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isProductPriceExists
                                  ? 'Price: AED ${itemDocuments[index]['productPrice'].toString()}'
                                  : 'Wating for Scraper',
                                  style: TextStyle(fontSize: isWindows? 28: null),
                                ),
                                Text(
                                  'Target: ${itemDocuments[index]['Targeted Price'].toString()}',
                                  style: TextStyle(fontSize: isWindows? 26: null),
                                ),
                              ],
                            ),
                            const SizedBox(width: 6,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    Get.defaultDialog(
                                      titlePadding: const EdgeInsets.all(10),
                                      contentPadding: const EdgeInsets.all(6),
                                      title: 'Update Target',
                                      titleStyle:  TextStyle(
                                        color: const Color.fromRGBO(47, 79, 79, 0.9),
                                        fontWeight: FontWeight.bold,
                                        fontSize:isWindows? 45: 24
                                      ),
                                      backgroundColor: const Color.fromARGB(255, 193, 196, 196),
                                      barrierDismissible: false,
                                      content: Container(
                                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                                        width: containerWidth,
                                        child: Column(
                                          children: [
                                            Form(
                                              key: _formKey,
                                              child: TextFormField(
                                              controller: _targatedPriceController,
                                              autofocus: true,
                                              decoration: textFieldDecoration('enter price...'),
                                              key: const ValueKey('targatedprice'),
                                              validator: (value) {
                                                    if(value.toString().isEmpty){
                                                      return 'Please Enter Some Value';
                                                    }else{
                                                      return null;
                                                    }
                                                },
                                                onChanged: (value){
                                                  targetedPrice = value;
                                                },
                                                keyboardType: TextInputType.number,
                                                style: TextStyle(fontSize: isWindows ?32: null),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                                ],
                                              ),
                                            ),
                                            const Text('Without any special character or (.)', style: TextStyle(color: Color.fromARGB(255, 80, 79, 79)),)
                                          ],
                                        )
                                      ),
                                      actions: [
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  _targatedPriceController.clear();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromARGB(228, 239, 241, 241),
                                                  splashFactory: NoSplash.splashFactory, 
                                                  overlayColor:  Colors.transparent,// Remove splash effect
                                                  padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                                  
                                                ),
                                                child: Text('Cancel',
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(47, 79, 79, 0.9),
                                                    fontSize: isWindows? 30: 16,
                                                    fontWeight: FontWeight.bold,
                                                    
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: (){
                                                  if(_formKey.currentState!.validate()){
                                                    service.editProductDetails(
                                                      siteName,
                                                      itemDocuments[index]['Product Name'].toString(),
                                                      targetedPrice.toString(),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Updated Sucessfully')),
                                                    );
                                                    Navigator.pop(context);
                                                    _targatedPriceController.clear();
                                                    
                                                  }
                                                  else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Unable to Update')),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromRGBO(47, 79, 79, 0.9),
                                                  splashFactory: NoSplash.splashFactory, 
                                                  overlayColor:  Colors.transparent,// Remove splash effect
                                                  padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                                  
                                                ),
                                                child: Text('Update',
                                                  style: TextStyle(
                                                    color:  Colors.white,
                                                    fontSize: isWindows? 30: 16,
                                                    fontWeight: FontWeight.bold,
                                                    
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ]
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(47, 79, 79, 0.9),
                                    splashFactory: NoSplash.splashFactory, 
                                    overlayColor:  Colors.transparent,// Remove splash effect
                                    padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                    
                                  ),
                                  child: Text('Edit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isWindows? 30: 16,
                                      fontWeight: FontWeight.bold,
                                      
                                    ),
                                  ),
                                ),
                                SizedBox(width: isWindows?16: 4,),
                                ElevatedButton(
                                  onPressed: (){
                                    Get.defaultDialog(
                                      title: 'Confirmation',
                                      titleStyle:  TextStyle(
                                        color: const Color.fromRGBO(47, 79, 79, 0.9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: isWindows? 55: 26
                                      ),
                                      content:
                                      isWindows
                                      ? const SizedBox(
                                        height: 90,
                                        width:600,
                                        child: Center(child: Text(
                                            'Are you sure you want to delete',
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                       )
                                      : null,
                                      middleText: isWindows ? '': 'Are you sure you want to delete',
                                      backgroundColor: const Color.fromARGB(255, 193, 196, 196),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: (){
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromRGBO(47, 79, 79, 0.9),
                                            splashFactory: NoSplash.splashFactory, 
                                            overlayColor:  Colors.transparent,// Remove splash effect
                                            padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                            
                                          ),
                                          child: Text('No',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isWindows? 30: 16,
                                              fontWeight: FontWeight.bold,
                                              
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            service.deleteProduct(
                                              siteName,
                                              itemDocuments[index]['Product Name'].toString(),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Product Deleted Sucessfully')),
                                            );
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(228, 239, 241, 241),
                                            splashFactory: NoSplash.splashFactory, 
                                            overlayColor:  Colors.transparent,// Remove splash effect
                                            padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                            
                                          ),
                                          child: Text('Yes',
                                            style: TextStyle(
                                              color: const Color.fromRGBO(47, 79, 79, 0.9),
                                              fontSize: isWindows? 30: 16,
                                              fontWeight: FontWeight.bold,
                                              
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(228, 239, 241, 241),
                                    splashFactory: NoSplash.splashFactory, 
                                    overlayColor:  Colors.transparent,// Remove splash effect
                                    padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                    
                                  ),
                                  child: Text('Delete',
                                    style: TextStyle(
                                      color: const Color.fromRGBO(47, 79, 79, 0.9),
                                      fontSize: isWindows? 30: 16,
                                      fontWeight: FontWeight.bold,
                                      
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            
                          ],
                        ),

                    
                  );
                },
                separatorBuilder: (context, index) => const Divider(thickness: 0.4,height: 0.4,),
                itemCount: itemDocuments.length,
              ),
            );
          }
        }
      ),
    );
  }
}


InputDecoration textFieldDecoration(String hint){
  return InputDecoration(
    contentPadding: Platform.isWindows? const EdgeInsets.symmetric(vertical: 35, horizontal: 20): null,
    filled: true,
    fillColor: const Color.fromARGB(226, 220, 220, 220),
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: Platform.isWindows? 32: null,
    ),
    border: OutlineInputBorder( 
      borderRadius: Platform.isWindows? BorderRadius.circular(50) :BorderRadius.circular(25),
      borderSide: BorderSide.none
      
    ),
  );
}

