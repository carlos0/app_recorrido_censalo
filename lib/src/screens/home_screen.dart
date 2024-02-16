import 'package:app_recorrido_mapa/src/screens/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:info_popup/info_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _searchController = TextEditingController();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffB7241E),
        title: const Text('Recorrido censal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset(
              'assets/images/logo_yocenso.png',
              opacity: const AlwaysStoppedAnimation(0.7),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => const QrScreen());
                },
                style: ElevatedButton.styleFrom(
                  textStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  minimumSize: const Size(270, 60),
                  maximumSize: const Size(270, 60),
                  backgroundColor: const Color(0xff194884),
                  foregroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 5,
                  side: BorderSide(
                      color: Colors.blue.shade900,
                      width: 2,
                      style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  tapTargetSize: MaterialTapTargetSize.padded,
                ),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Escanear el Mapa'),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.qr_code_scanner,
                        size: 40,
                      )
                    ])),
            const SizedBox(
              height: 15,
            ),
            const Row(children: [
              Expanded(child: Divider(color: Colors.black87,)),
              Text("  Ó  ", style: TextStyle(color: Colors.grey),),
              Expanded(child: Divider(color: Colors.black87,)),
            ]),
            const SizedBox(
              height: 15,
            ),
            InfoPopupWidget(
              //contentTitle: 'Esta es la información del segmento',
              customContent: () {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Column(
                    children: [
                      Text('El segmento tiene un total de 8 digitos ejemplo "32701125". si en los mapas se muestra menos digitos, se debe agregar ceros a la izquierda para completar los 8 digitos.', style: TextStyle(fontSize: 16, ), textAlign: TextAlign.justify,),
                    ]
                  )
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Color(0xffB7241E),
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Información',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder( borderRadius: BorderRadius.circular(15),),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(width: 1, color: Color(0xff010000)),
                  ),
                  hintText: ' Buscar segmento',
                  labelText: ' Buscar segmento',
                  contentPadding: const EdgeInsets.all(20.0)
                ),
                  
              ),
            ),
            ElevatedButton(
              onPressed: (){
                RegExp exp = RegExp(r'^\d{8}$');
                if (exp.hasMatch(_searchController.text)) {
                  box.write('segmento', _searchController.text);
                  Navigator.pushNamed(context, 'map', arguments: _searchController.text);
                  _searchController.text = '';
                } else {
                  Get.snackbar('Error', 'El segmento no es valido', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
                }
              }, 
              style: ElevatedButton.styleFrom(
                textStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  minimumSize: const Size(270, 50),
                  maximumSize: const Size(270, 50),
                  backgroundColor: const Color(0xffB7241E),
                  foregroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 5,
                  side: BorderSide(
                      color: Colors.red.shade900,
                      width: 2,
                      style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tapTargetSize: MaterialTapTargetSize.padded,
              ),
              child: const Text('Buscar'),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text('Versión 1.0.2', style: TextStyle(fontSize: 13, color: Colors.black54),),
          ]),
        ),
      ),
    );
  }
}
