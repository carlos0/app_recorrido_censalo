import 'package:app_recorrido_mapa/src/screens/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffB7241E),
        title: const Text('Recorrido censal'),
        centerTitle: true,
      ),
      body: Container(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xffB7241E),
      onPressed: (){
        Get.to(() => const QrScreen())?.then((value) {
          print('=================');
          print(value);
          print('=================');
        });
      },
      child: const Icon(Icons.search,),
    );
  }
}