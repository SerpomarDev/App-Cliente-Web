import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker3/looker3_controller.dart';

class Looker3Page extends StatefulWidget {
  @override
  _Looker3PageState createState() => _Looker3PageState();
}

class _Looker3PageState extends State<Looker3Page> {
  final Looker3Controller con = Get.put(Looker3Controller());
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      webViewController = WebViewController()
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/d9b5d198-40d7-4f84-9d97-2a821e5e83db/page/Y4oY'));
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
        ..loadRequest(Uri.parse('https://lookerstudio.google.com/embed/reporting/d9b5d198-40d7-4f84-9d97-2a821e5e83db/page/Y4oY'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROGRAMACIÓN LLENOS',
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
