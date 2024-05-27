import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker1/looker1_controller.dart';

class Looker1Page extends StatefulWidget {
  @override
  _Looker1PageState createState() => _Looker1PageState();
}

class _Looker1PageState extends State<Looker1Page> {
  final Looker1Controller con = Get.put(Looker1Controller());
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      webViewController = WebViewController()
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/d26ba2ca-4ee3-493a-b00c-21ce47b580d8/page/Y4oY'));
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
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/d26ba2ca-4ee3-493a-b00c-21ce47b580d8/page/Y4oY'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROGRAMACIÓN EXPORTACIÓN',
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
