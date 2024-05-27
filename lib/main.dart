import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:serpomar_client/src/models/user.dart';
import 'package:serpomar_client/src/pages/administrador/home/administrador_home_page.dart';
import 'package:serpomar_client/src/pages/administrador/orders/detail/administrador_orders_detail_page.dart';
import 'package:serpomar_client/src/pages/administrador/orders/list/administrador_orders_list_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/devolucion/modalidad_devolucion_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/expo/modalidad_expo_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/impo/modalidad_impo_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/modalidades_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/redireccion/modalidad_redireccion_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/traslado/modalidad_traslado_page.dart';
import 'package:serpomar_client/src/pages/administrador/products/create/modalidades/vacio/modalidad_vacio_page.dart';
import 'package:serpomar_client/src/pages/asignacion/address/create/asignacion_address_create_page.dart';
import 'package:serpomar_client/src/pages/asignacion/address/list/asignacion_address_list_page.dart';
import 'package:serpomar_client/src/pages/asignacion/home/asignacion_home_page.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/create/asignacion_orders_create_page.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/detail/asignacion_orders_detail_page.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery/asignacion_orders_galery_page.dart';
import 'package:serpomar_client/src/pages/asignacion/payments/create/asignacion_payments_create_page.dart';
import 'package:serpomar_client/src/pages/asignacion/profile/info/asignacion_profile_info_page.dart';
import 'package:serpomar_client/src/pages/asignacion/profile/update/asignacion_profile_update_page.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/list/asignacion_rutas_list_page.dart';
import 'package:serpomar_client/src/pages/conductor/home/conductor_home_page.dart';
import 'package:serpomar_client/src/pages/conductor/orders/detail/conductor_orders_detail_page.dart';
import 'package:serpomar_client/src/pages/conductor/orders/imgencargo/conductor_orders_imgencargo_page.dart';
import 'package:serpomar_client/src/pages/conductor/orders/list/conductor_orders_list_page.dart';
import 'package:serpomar_client/src/pages/conductor/orders/map/conductor_orders_map_page.dart';
import 'package:serpomar_client/src/pages/flota/preventa/preventas_home_page.dart';
import 'package:serpomar_client/src/pages/home/home_page.dart';
import 'package:serpomar_client/src/pages/login/login_page.dart';
import 'package:serpomar_client/src/pages/looker/looker_page.dart';
import 'package:serpomar_client/src/pages/looker/lookers/looker1/looker1_page.dart';
import 'package:serpomar_client/src/pages/register/register_page.dart';
import 'package:serpomar_client/src/pages/roles/roles_page.dart';
import 'package:serpomar_client/src/utils/firebase_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

import 'src/pages/flota/flota_home_page.dart';
import 'src/pages/asignacion/orders/map/asignacion_orders_map_page.dart';
import 'src/pages/looker/lookers/looker2/looker2_page.dart';
import 'src/pages/looker/lookers/looker3/looker3_page.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseConfig.currentPlatform,
  );

  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print('EL TOKEN DE SESION DEL USUARIO: ${userSession.sessionToken}');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Serpomar Cliente",
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null ? '/home' : '/',
      getPages: [
        GetPage(name: "/", page: () => LoginPage()),
        GetPage(name: "/register", page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => RolesPage()),
        GetPage(name: '/administrador/home', page: () => AdministradorHomePage()),
        GetPage(name: '/flota', page: () => FlotaHomePage()),
        GetPage(name: '/flota/preventa/', page: () => PreventasHomePage()),
        GetPage(name: '/looker', page: () => LookerPage()),
        GetPage(name: '/looker/lookers/looker1', page: () => Looker1Page()),
        GetPage(name: '/looker/lookers/looker2', page: () => Looker2Page()),
        GetPage(name: '/looker/lookers/looker3', page: () => Looker3Page()),
        GetPage(name: '/administrador/products/modalidades/', page: () => ModalidadesPage()),
        GetPage(name: '/administrador/products/modalidades/expo', page: () => ModalidadExpoPage()),
        GetPage(name: '/administrador/products/modalidades/impo', page: () => ModalidadImpoPage()),
        GetPage(name: '/administrador/products/modalidades/vacio', page: () => ModalidadVacioPage()),
        GetPage(name: '/administrador/products/modalidades/devolucion', page: () => ModalidadDevolucionPage()),
        GetPage(name: '/administrador/products/modalidades/traslado', page: () => ModalidadTrasladoPage()),
        GetPage(name: '/administrador/products/modalidades/redireccion', page: () => ModalidadRedireccionPage()),
        GetPage(name: '/administrador/orders/list', page: () => AdministradorOrdersListPage()),
        GetPage(name: '/administrador/orders/detail', page: () => AdministradorOrdersDetailPage()),
        GetPage(name: '/conductor/orders/list', page: () => ConductorOrdersListPage()),
        GetPage(name: '/conductor/orders/detail', page: () => ConductorOrdersDetailPage()),
        GetPage(name: '/conductor/orders/map', page: () => ConductorOrdersMapPage()),
        GetPage(name: '/conductor/orders/imgencargo', page: () => ConductorOrdersImgencargoPage()),
        GetPage(name: '/conductor/home', page: () => ConductorHomePage()),
        GetPage(name: '/Asignacion/rutas/list', page: () => AsignacionRutasListPage()),
        GetPage(name: '/Asignacion/home', page: () => AsignacionHomePage()),
        GetPage(name: '/asignacion/profile/info', page: () => AsignacionProfileInfoPage()),
        GetPage(name: '/asignacion/profile/update', page: () => AsignacionProfileUpdatePage()),
        GetPage(name: '/asignacion/orders/create', page: () => AsignacionOrdersCreatePage()),
        GetPage(name: '/asignacion/orders/detail', page: () => AsignacionOrdersDetailPage()),
        GetPage(name: '/asignacion/orders/galery', page: () => AsignacionOrdersGaleryPage()),
        GetPage(name: '/asignacion/orders/map', page: () => AsignacionOrdersMapPage()),
        GetPage(name: '/asignacion/address/create', page: () => AsignacionAddressCreatePage()),
        GetPage(name: '/asignacion/address/list', page: () => AsignacionAddressListPage()),
        GetPage(name: '/asignacion/payments/create', page: () => AsignacionPaymentsCreatePage()),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF0073FF),
        colorScheme: const ColorScheme(
          primary: Color(0xFF0073FF),
          secondary: Colors.redAccent,
          brightness: Brightness.light,
          onBackground: Colors.grey,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.blueAccent,
          onSecondary: Colors.grey,
          background: Colors.white,
        ),
      ),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: Get.key,
    );
  }
}
