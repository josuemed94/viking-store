import 'package:app_ventas_ropa/src/pages/client/products/list/client_products_list_page.dart';
import 'package:app_ventas_ropa/src/pages/client/update/client_update_page.dart';
import 'package:app_ventas_ropa/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:app_ventas_ropa/src/pages/register/register_page.dart';
import 'package:app_ventas_ropa/src/pages/tienda/categories/create/tienda_categories_create_page.dart';
import 'package:app_ventas_ropa/src/pages/tienda/orders/list/tienda_orders_list_page.dart';
import 'package:app_ventas_ropa/src/pages/roles/roles_page.dart';
import 'package:app_ventas_ropa/src/pages/tienda/products/create/tienda_products_create_page.dart';
import 'package:app_ventas_ropa/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_ventas_ropa/src/pages/login/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TE LO VENDO',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login' : (BuildContext context) => LoginPage(),
        'register' : (BuildContext context) => RegisterPage(),
        'roles' : (BuildContext context) => RolesPage(),
        'client/products/list' : (BuildContext context) => ClientProductsListPage(),
        'client/update' : (BuildContext context) => ClientUpdatePage(),
        'tienda/categories/create' : (BuildContext context) => TiendaCategoriesCreatePage(),
        'tienda/products/create' : (BuildContext context) => TiendaProductsCreatePage(),
        'tienda/orders/list' : (BuildContext context) => TiendatOrdersListPage(),
        'delivery/orders/list' : (BuildContext context) => DeliveryOrdersListPage(),
      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0)
      ),
    );
  }

}
