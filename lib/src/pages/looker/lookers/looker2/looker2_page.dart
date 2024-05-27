import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker2/looker2_controller.dart';

class Looker2Page extends StatefulWidget {
  @override
  _Looker2PageState createState() => _Looker2PageState();
}

class _Looker2PageState extends State<Looker2Page> {
  final Looker2Controller con = Get.put(Looker2Controller());
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      webViewController = WebViewController()
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/cd22b306-ca60-473b-920a-08bb37f9f9d5/page/Y4oY'));
    } else {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Puedes manejar el progreso aquí si es necesario
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/cd22b306-ca60-473b-920a-08bb37f9f9d5/page/Y4oY'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROGRAMACIÓN VACIOS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
