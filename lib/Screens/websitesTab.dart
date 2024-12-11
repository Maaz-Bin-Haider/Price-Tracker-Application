import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scraper/Screens/amazon_uae.dart';
import 'package:scraper/Screens/amazon_usa.dart';
import 'package:scraper/Screens/bunnings_aus.dart';
import 'package:scraper/Screens/harvey_norman.dart';
import 'package:scraper/Screens/jb_hifi.dart';
import 'package:scraper/Screens/noon_uae.dart';

class Websites extends StatelessWidget {
  Websites({super.key});

  final bool isWindows =  Platform.isWindows;
  final List websitesNames = ['Harvey Norman','Amazon UAE','Bunnings AUS','Noon UAE','Azamon USA','Jb Hi Fi'];
  final List<String> picturesPath = [
    'Assets/images/harvey_norman.png',
    'Assets/images/amazon_ae.png',
    'Assets/images/bunnings_aus.jpg',
    'Assets/images/noon.jpg',
    'Assets/images/amazon_usa.png',
    'Assets/images/jb_hifi.png',
  ];
  final List<Widget> seperatePages = [
    HarveyNorman(),
    AmazonUAE(),
    BunningsAUS(),
    NoonUAE(),
    AmazonUSA(),
    JbHiFi(),
  ];

  @override
  Widget build(BuildContext context) {
    return isWindows
     ? ForWindowsPlatform(websitesNames: websitesNames, seperatePages: seperatePages, picturesPath: picturesPath)
     : ForMobileDevices(websitesNames: websitesNames, seperatePages: seperatePages, picturesPath: picturesPath); 
  }
}

class ForMobileDevices extends StatelessWidget {
  final  List websitesNames;
  final List<Widget> seperatePages;
  final List<String> picturesPath;
  const ForMobileDevices({
    required this.websitesNames,
    required this.seperatePages,
    required this.picturesPath,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: ListView.builder(
        itemCount: websitesNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.to(seperatePages[index]),
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 238, 234),
                borderRadius: BorderRadius.circular(8)
              ),
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(picturesPath[index]),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(websitesNames[index],style: webNameStyle(),),
                  )
                ],
              )
 
            ),
          );
        },
      )
    );
  }
}

class ForWindowsPlatform extends StatelessWidget {
  final  List websitesNames;
  final List<Widget> seperatePages;
  final List<String> picturesPath;

  const ForWindowsPlatform({
    required this.websitesNames,
    required this.seperatePages,
    required this.picturesPath,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder( 
        //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 4 ), 
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent( 
          maxCrossAxisExtent: 500,
          mainAxisExtent: 350
        ), 
        itemCount: websitesNames.length, 
        itemBuilder: (context, index) { 
          return GestureDetector(
              onTap: () => Get.to(seperatePages[index]),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 10,bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 238, 234),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration:  BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(picturesPath[index]),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(websitesNames[index],style: webNameStyle(),),
                    )
                  ],
                )
       
              ),
            ); 
        }, 
      ),
    ) ;
  }
}





TextStyle webNameStyle(){
  return const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color:  Color.fromRGBO(42, 59, 59, 0.937)
  );
}