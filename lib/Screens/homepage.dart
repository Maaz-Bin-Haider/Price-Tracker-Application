import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scraper/Screens/notifications_tab.dart';
import 'package:scraper/Screens/websitesTab.dart';
import 'package:scraper/Services/services.dart';
import 'dart:io';



class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Services service = Get.find<Services>();  // finding 
  final bool isWindows =  Platform.isWindows;
  
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      initialIndex: 0, 
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isWindows ? 240 : 148),
          child: AppBar(
            toolbarHeight: isWindows ? 240.0 : 66.0,
            title:  Container(
              padding: isWindows ? const EdgeInsets.only(top: 10): null,
              child: Text(
                'Scraper',
                  style: TextStyle(
                  color: const Color.fromRGBO(227, 228, 228, 0.941),
                  fontWeight: FontWeight.bold,
                  fontSize: isWindows ? 80:45
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(47, 79, 79, 0.9), // Slate Gray,  
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(isWindows ? 165.0 : 90),
              child: TabBar( 
                overlayColor: WidgetStateColor.transparent,
                splashFactory: NoSplash.splashFactory, 
                indicatorColor: const Color.fromARGB(227, 29, 54, 54),// samll bar color 
                labelColor: const Color.fromARGB(227, 29, 54, 54),
                indicatorWeight: isWindows ? 6 : 2,
                unselectedLabelColor: const Color.fromARGB(255, 222, 220, 220),// Tab color 
                tabs: [ 
                  SizedBox(
                    height: isWindows ? 130 : null,
                    child: Tab(
                      icon: Icon(
                        Icons.web,
                        size: isWindows ? 60 :32,
                      ),
                      child: Text(
                        'Websites',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isWindows ? 36: 16
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isWindows ? 130 : null,
                    child: Tab(
                      icon: Icon(
                        Icons.notifications,
                        size: isWindows ? 60 :32,
                      ),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isWindows ? 36: 16
                        ),
                      ),
                    ),
                  ), 
                  SizedBox(
                    height: isWindows ? 130 : null,
                    child: Tab(
                      icon: Icon(
                        Icons.help,
                        size: isWindows ? 60 :32,
                      ),
                      child: Text(
                        'Guide & Info',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isWindows ? 36: 16
                        ),
                      ),
                    ),
                  ),
                  
                ], 
              ),
            ),
          
          ),
        ),
        floatingActionButton: InkWell(
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        
          child: SizedBox(
            width: isWindows? 100.0: null,  // Increase the width of the FAB
            height: isWindows? 100.0: null,  // Increase the height of the FAB
            child: FloatingActionButton(
              materialTapTargetSize: MaterialTapTargetSize.padded,           
              backgroundColor: const Color.fromRGBO(47, 79, 79, 0.9),
              highlightElevation: 0,
              splashColor: const Color.fromARGB(226, 21, 41, 41),
              onPressed: (){ 
                
                final formKey = GlobalKey<FormState>();
                String productName = '';
                TextEditingController productNameController = TextEditingController();
                String websiteName = '';
            
                String url = '';
                TextEditingController urlController = TextEditingController();
                String targetedPrice = '';
                TextEditingController targetedPriceController = TextEditingController();
                  // Get the screen width
                double screenWidth = MediaQuery.of(context).size.width; 
                double screenHeight = MediaQuery.of(context).size.height; 
                // Calculate 70% of the screen width
                double containerWidth = isWindows? screenWidth * 0.5: screenWidth * 0.8;
                double containerHeightForWindows = screenHeight * 0.5;
                Get.defaultDialog(
                  title: 'Add Products',
                  titleStyle:  TextStyle(
                    color: const Color.fromRGBO(47, 79, 79, 0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: isWindows? 60: 32
                  ),
                  titlePadding: const EdgeInsets.only(top: 10),
                  backgroundColor: const Color.fromARGB(255, 193, 196, 196),
                  // barrierDismissible: false,
                  content: SingleChildScrollView(
                    child: Container(
                        width: containerWidth,
                        height: isWindows? containerHeightForWindows: null ,
                        padding: isWindows? const EdgeInsets.all(20): const EdgeInsets.all(8),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                controller: productNameController,
                                autofocus: true,
                                decoration: textFieldDecoration('Enter ProductName'),
                                key: const ValueKey('productName'),
                                validator: (value) {
                                    if(value.toString().isEmpty){
                                      return 'Please Enter Some Value';
                                    }else if((value.toString().contains('/')) || (value.toString().contains('\\'))){
                                      return 'Character (/) or (\\) are not allowed';
                                    }
                                    else{
                                      return null;
                                    }
                                },
                                onChanged: (value){
                                  productName = value;
                                },
                                style: TextStyle(fontSize: isWindows ?25: null),
                              ),
                              const SizedBox(height: 4,),
                              Obx((){
                                return DropdownButtonFormField<String>(
                                  decoration:  InputDecoration(
                                    contentPadding: Platform.isWindows? const EdgeInsets.symmetric(vertical: 25,horizontal: 20): null,
                                    filled: true,
                                    fillColor: const Color.fromARGB(226, 220, 220, 220),
                                    hintText: 'Select Website Name',
                                    hintStyle: TextStyle(fontSize: isWindows? 25: null, height: isWindows ?1 : null),
                                    border: OutlineInputBorder(    
                                      borderRadius: Platform.isWindows? BorderRadius.circular(50) :BorderRadius.circular(25),
                                      borderSide: BorderSide.none,                         
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: Platform.isWindows? BorderRadius.circular(50) :BorderRadius.circular(25),
                                      borderSide: BorderSide.none
                                    ),
                                    
                                  ),
                                  value: service.selectedSiteForDropdown.value, 
                                  onChanged: (String? newValue) {
                                      service.selectedSiteForDropdown.value = newValue;
                                      websiteName = newValue!;
                                  },
                                  items: service.website_Names.map((String website) {
                                    return DropdownMenuItem<String>(
                                      value: website,
                                      child: Text(website,style: const TextStyle(color: Color.fromARGB(255, 75, 77, 75)),),
                                    );
                                  }).toList(),
            
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select a Website Name';
                                    }
                                    return null;
                                  },
                                  isExpanded: true,
                                  style: TextStyle(color: const Color.fromARGB(255, 75, 77, 75),fontSize: isWindows ?25: null),
                                  iconSize: isWindows?  35 : 19,
                                );
                              }),
                              const SizedBox(height: 4,),
                              TextFormField(
                                controller: urlController,
                                autofocus: true,
                                decoration: textFieldDecoration('Enter Url'),
                                key: const ValueKey('url'),
                                validator: (value) {
                                    if(value.toString().isEmpty){
                                      return 'Please Enter Some Value';
                                    }else{
                                      return null;
                                    }
                                },
                                onChanged: (value){
                                  url = value;
                                },
                                keyboardType: TextInputType.url,
                                style: TextStyle(fontSize: isWindows ?25: null),
                              ),
                              const SizedBox(height: 4,),
                              TextFormField(
                                controller: targetedPriceController,
                                autofocus: true,
                                decoration: textFieldDecoration('Enter TargetedPrice'),
                                key: const ValueKey('targetedPrice'),
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
                                style: TextStyle(fontSize: isWindows ?25: null),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ),
                  actions: [
                    Padding(
                      padding: isWindows? const EdgeInsets.only(bottom: 20): const EdgeInsets.only(bottom: 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  service.sendProductDetails( productName,websiteName,url,targetedPrice);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Product Added Sucessfully')),
                                  );
                                  Navigator.of(context).pop();
                                  service.selectedSiteForDropdown.value = null;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(47, 79, 79, 0.9),
                                splashFactory: NoSplash.splashFactory, 
                                overlayColor:  Colors.transparent,// Remove splash effect
                                padding: isWindows ? const EdgeInsets.fromLTRB(25, 16, 25, 16) : null
                                
                              ),
                              child: Text('Post',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isWindows? 30: 16,
                                  fontWeight: FontWeight.bold,
                                  
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                service.selectedSiteForDropdown.value = null;
                      
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
                            )
                          ],
                        ),
                    ),
            
                  ],
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: isWindows ? BorderRadius.circular(25) : BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: isWindows ? 65: 28
              ),
            
              
              
            ),
          ), 
        ),
        body: TabBarView( 
            children: [ 
              Websites(),
              NotificationsTab(), 
              Container(
                padding: const EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      ListTile(
                        title: Text('Prequations',style: maininstructionsStyle(),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              subtitle: Text('Do not include / or \\ in the product name, as these characters are not allowed in Firebase for Defining a document name in our case the product name is also the document name.',style: instructionsStyle(),),
                            ),
                            ListTile(
                              // leading: Icon(Icons.circle_rounded),
                              title: Text('Avoid special characters eg(\$, AED, USD, AUD ) in Target price.',style: instructionsStyle(),),
                            ),
                            ListTile(
                              // leading: Icon(Icons.circle_rounded),
                              title: Text('Try not to include decimal(.) in target price.',style: instructionsStyle(),),
                            ),
                            ListTile(
                              // leading: Icon(Icons.circle_rounded),
                              title: Text('If the product price returns as zero (0), it likely means the automation has been detected, prompting a human verification request. Please wait for the next scheduled script run.',
                              style: instructionsStyle(),
                            ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('App Information',style: maininstructionsStyle(),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(title: Text('App Name',style: instructionsStyle()),subtitle: const Text('Scraper'),),
                            ListTile(title: Text('Created By',style: instructionsStyle()),subtitle: const Text('Maaz Rehan'),),
                            ListTile(title: Text('Release Date',style: instructionsStyle()),subtitle: const Text('Waiting for release'),),
                            ListTile(title: Text('Last Updated',style: instructionsStyle()),subtitle: const Text('December 03, 2024'),),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('How It Works',style: maininstructionsStyle(),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                              'Add Products',
                               style: instructionsStyle()
                              ),
                              subtitle: const Text('Users can add product details, including the URL, target price, and model number, which are securely stored in Firestore.'
                              ),
                            ),
                            ListTile(
                              title: Text(
                              'Automated Price Monitoring',
                               style: instructionsStyle()
                              ),
                              subtitle: const Text('A Python script, deployed on a dedicated server, runs hourly, 24/7. It fetches product details from Firestore, scrapes the latest prices from the provided URLs, and updates the Firestore database with the current price.'),
                            ),
                            ListTile(
                              title: Text(
                              ' Smart Price Comparison',
                               style: instructionsStyle()
                              ),
                              subtitle: const Text('The script compares the current price with the user’s target price. If the actual price matches or falls below the target, the system triggers a notification.'),
                            ),
                            ListTile(
                              title: Text(
                              'Instant Notifications',
                               style: instructionsStyle()
                              ),
                              subtitle: const Text('Upon initialization, the app retrieves the user’s Firebase Cloud Messaging (FCM) token and stores it in Firestore. The Python script then uses this token to send push notifications via Firebase Messaging, alerting the user that the target price has been reached.'),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('Development Details',style: maininstructionsStyle(),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text('Frontend Technology', style: instructionsStyle()),
                              subtitle: const Text('Framework(Langauge): Flutter (Dart)'),
                            ),
                            ListTile(
                              title: Text('Backend Technology', style: instructionsStyle()),
                              subtitle: const Text('Python Scripts Depoyed on a Server'),
                            ),
                            ListTile(
                              title: Text('Firebase', style: instructionsStyle()),
                              subtitle: const Text('Firestore, Firebase Messaging'),
                            ),
                            ListTile(
                              title: Text('Database', style: instructionsStyle()),
                              subtitle: const Text('Firebase Firestore'),
                            ),
                            ListTile(
                              title: Text('Platform', style: instructionsStyle()),
                              subtitle: const Text('Andriod & Windows'),
                            ),
                          ],
                        ),
                      )
                      
                    ],
                  ),
                ),
              ),
              
            ], 
          ),

      ),
    );
  }
}


InputDecoration textFieldDecoration(String hint){
  return InputDecoration(
    contentPadding: Platform.isWindows? const EdgeInsets.symmetric(vertical: 20, horizontal: 20): null,
    filled: true,
    fillColor: const Color.fromARGB(226, 220, 220, 220),
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: Platform.isWindows? 25: null,
    ),
    border: OutlineInputBorder( 
      borderRadius: Platform.isWindows? BorderRadius.circular(50) :BorderRadius.circular(25),
      borderSide: BorderSide.none
      
    ),
  );
}

TextStyle instructionsStyle(){
  return  TextStyle(
    color: const Color.fromARGB(255, 62, 61, 61),
    fontSize: Platform.isWindows? 25: 15,
    fontWeight: Platform.isWindows? FontWeight.w400: FontWeight.w500
  );
}

TextStyle maininstructionsStyle(){
  return  TextStyle(
    color: const Color.fromARGB(255, 79, 77, 77),
    fontSize:  Platform.isWindows? 35: 25,
    fontWeight: FontWeight.w700,
  );
}
