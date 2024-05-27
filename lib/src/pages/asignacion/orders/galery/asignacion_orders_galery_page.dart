import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:serpomar_client/src/models/category_galeries.dart';
import 'package:serpomar_client/src/models/galeries.dart';
import 'package:serpomar_client/src/pages/asignacion/orders/galery/asignacion_orders_galery_controller.dart';
import 'package:serpomar_client/src/utils/AppDrawer.dart'; // Asegúrate de que la ruta de importación sea correcta
import 'package:serpomar_client/src/widgets/no_data_widget.dart';

class AsignacionOrdersGaleryPage extends StatelessWidget {
  final AsignacionOrdersGaleryController con = Get.put(AsignacionOrdersGaleryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
      length: con.categories_GaleryView.length,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(115),
            child: AppBar(
              flexibleSpace: Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.topCenter,
                child: _textFieldSearch(context),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.blueAccent,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.lightBlue,
                tabs: List<Widget>.generate(con.categories_GaleryView.length, (index) {
                  return Tab(
                    child: Text(con.categories_GaleryView[index].name ?? ''),
                  );
                }),
              ),
            ),
          ),
          // drawer: AppDrawer(currentPage: 'Mi Galeria'),  // Utilizando AppDrawer
          body: TabBarView(
            children: con.categories_GaleryView.map((CategoryGaleries categoryGaleries) {
              return FutureBuilder(
                  future: con.getGaleries(categoryGaleries.id ?? '1', con.galeryName.value),
                  builder: (context, AsyncSnapshot<List<Galeries>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardGaleries(context, snapshot.data![index]);
                            }
                        );
                      }
                      else {
                        return NoDataWidget(text: 'No hay Galerías');
                      }
                    }
                    else {
                      return NoDataWidget(text: 'Cargando Galerías...');
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
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          onChanged: con.onChangeText,
          decoration: InputDecoration(
              hintText: 'Buscar en galería',
              suffixIcon: Icon(Icons.search, color: Colors.indigoAccent),
              hintStyle: TextStyle(fontSize: 17, color: Colors.indigoAccent),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.indigoAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.all(15)
          ),
        ),
      ),
    );
  }

  Widget _cardGaleries(BuildContext context, Galeries galeries) {
    String titlePrefix;
    switch (galeries.idCategoryGaleries) {
      case '1':
        titlePrefix = 'SpEX00';
        break;
      case '2':
        titlePrefix = 'SpIM00';
        break;
      case '3':
        titlePrefix = 'SpRTV00';
        break;
      case '4':
        titlePrefix = 'SpTD00';
        break;
      default:
        titlePrefix = 'Sp00';
        break;
    }

    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => _buildImageSliderModal(context, galeries),
        );
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 18),
            child: ListTile(
              title: Text('$titlePrefix${galeries.id ?? ''}'),
              trailing: Container(
                height: 70,
                width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    image: galeries.image1 != null ? NetworkImage(galeries.image1!) : AssetImage('assets/img/no-image1.png') as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image1.png'),
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey[400], indent: 37, endIndent: 37,)
        ],
      ),
    );
  }

  Widget _buildImageSliderModal(BuildContext context, Galeries galeries) {
    List<String?> images = [
      galeries.image1,
      galeries.image2,
      galeries.image3,
      galeries.image4,
      galeries.image5,
      galeries.image6,
    ].where((image) => image != null).toList(); // Remove null images from the list

    return Container(
      padding: EdgeInsets.all(10),
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.network(
            images[index]!,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
