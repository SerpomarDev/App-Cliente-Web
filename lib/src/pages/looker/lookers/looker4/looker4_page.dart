import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'looker4_controller.dart';

class Looker4Page extends StatefulWidget {
  @override
  _Looker4PageState createState() => _Looker4PageState();
}

class _Looker4PageState extends State<Looker4Page> {
  final Looker4Controller con = Get.put(Looker4Controller());
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      webViewController = WebViewController()
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/439ee337-d79c-44b3-91bf-36568b2a29b6/page/Y4oY'));
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
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/439ee337-d79c-44b3-91bf-36568b2a29b6/page/Y4oY'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROGRAMACIÓN IMPORTACIÓN',
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
