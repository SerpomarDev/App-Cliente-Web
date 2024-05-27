import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:serpomar_client/src/models/category.dart';
import 'package:serpomar_client/src/models/product.dart';
import 'package:serpomar_client/src/pages/asignacion/rutas/list/asignacion_rutas_list_controller.dart';
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class AsignacionRutasListPage extends StatelessWidget {
  AsignacionRutasListController con = Get.put(AsignacionRutasListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        DefaultTabController(
          length: con.categories.length,
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(115),
                child: AppBar(
                  flexibleSpace: Container(
                    margin: EdgeInsets.only(top: 15),
                    alignment: Alignment.topCenter,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        _textFieldSearch(context),
                      ],
                    ),
                  ),

                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.blueAccent,
                    labelColor: Colors.indigoAccent,
                    unselectedLabelColor: Colors.grey[600],
                    tabs: List<Widget>.generate(con.categories.length, (index) {
                      return Tab(
                        child: Text(con.categories[index].name ?? ''),
                      );
                    }),
                  ),
                ),
              ),
              body: TabBarView(
                children: con.categories.map((Category category) {
                  return FutureBuilder(
                      future: con.getProducts(
                          category.id ?? '1', con.productName.value),
                      builder: (context, AsyncSnapshot<List<
                          Product>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (_, index) {
                                  return _cardProduct(
                                      context, snapshot.data![index]);
                                }
                            );
                          } else {
                            return NoDataWidget(text: 'No hay rutas');
                          }
                        } else {
                          return NoDataWidget(text: 'No hay rutas');
                        }
                      }
                  );
                }).toList(),
              )
          ),
        ));
  }


  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.75,
        child: TextField(
          onChanged: con.onChangeText,
          decoration: InputDecoration(
              hintText: 'Buscar solicitud',
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              hintStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.grey
              ),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: Colors.blueGrey.shade400 // Color modificado
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: Colors.blue // Color modificado
                  )
              ),
              contentPadding: EdgeInsets.all(15)
          ),
        ),
      ),
    );
  }

  Widget _cardProduct(BuildContext context, Product product) {
    String titlePrefix;
    switch (product.idCategory) {
      case '4': // el ID de la categoría de exportación
        titlePrefix = 'SpEX00';
        break;
      case '3': // el ID de la categoría de importación
        titlePrefix = 'SpIM00';
        break;
      case '5': // el ID de la categoría de retiro de vacío
        titlePrefix = 'SpRTV00';
        break;
      case '8': // el ID de la categoría de traslado
        titlePrefix = 'SpTD00';
        break;
      default:
        titlePrefix = 'Sp00'; // Prefijo por defecto
        break;
    }

    return GestureDetector(
      onTap: () => con.openBottomSheet(context, product),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            color: Colors.blueAccent,
            child: ListTile(
              title: Text(
                '$titlePrefix${product.id ?? ''}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DO: ${product.doNumber ?? ''}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Ruta: ${product.selectedRoute ?? ''}',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'T. de Contenedor: ${product.containerTypes ?? ''}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '# contenedores: ${product.numContainers ?? ''}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!product.isAssigned) IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () => _confirmAssignment(context, product),
                  ),
                  Container(
                    height: 120,
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage(
                        image: product.image1 != null
                            ? NetworkImage(product.image1!)
                            : AssetImage('assets/img/no-image.png') as ImageProvider,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAssignment(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmación"),
            content: Text("¿Ya asignó todos los contenedores?"),
            actions: <Widget>[
              TextButton(
                child: Text("No"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                  child: Text("Sí"),
                  onPressed: () {
                    // Here we assume the controller is named 'con' and the method to update the server is defined within it
                    con.updateProductAssignedStatus(product.id!, true);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

