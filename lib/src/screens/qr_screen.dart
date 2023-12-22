import 'package:app_recorrido_mapa/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({ Key? key }) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    controller!.pauseCamera();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: const Text(
          'Volver átras',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Text('Recorrido censal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: size.height * .02,),
              const Text('Apunte al código qr del mapa', style: TextStyle(fontSize: 16),),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.fromSize(
                    size: Size(size.width * .7, size.height *.3),
                    child: QRView(
                      key: qrKey,
                      overlay: QrScannerOverlayShape(
                        borderRadius: 20,
                        borderColor: Colors.red,
                      ),
                      onQRViewCreated: _onQRViewCreated,
                    )
                  )
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/logo_yocenso.png'),
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.5), BlendMode.dstATop),
                  ),
                ),
                width: double.infinity,
                height: size.height * 0.4,
              ),
/*               ElevatedButton( onPressed: () {
                Navigator.pushNamed(context, 'map', arguments: '32700386');
              },child: const Text('Registrar')) */
            ]
          ),
        )
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        final result = scanData;
        controller.pauseCamera();
        Navigator.pushNamed(context, 'map', arguments: result.code)
          .then((value) => {
            controller.resumeCamera(),
          });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}