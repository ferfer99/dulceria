import 'package:flutter/material.dart';
import 'package:quiero_dulces/pages/all_products.dart';
import 'package:quiero_dulces/pages/cart_page.dart';
import 'package:quiero_dulces/pages/categories_page.dart';
import 'package:quiero_dulces/pages/category_selected.dart';
import 'package:quiero_dulces/pages/coupons_page.dart';
import 'package:quiero_dulces/pages/discount_page.dart';
import 'package:quiero_dulces/pages/history_page.dart';
import 'package:quiero_dulces/pages/location_page.dart';
import 'package:quiero_dulces/pages/login_page.dart';
import 'package:quiero_dulces/pages/order_page.dart';
import 'package:quiero_dulces/pages/payment_method_page.dart';
import 'package:quiero_dulces/pages/search_page.dart';
import 'package:quiero_dulces/widgets/bottom_navigation.dart';

/// rutas de las paginas 
var customRoutes = <String, WidgetBuilder>{
  LoginPage.id: (context) => LoginPage(),
  CategoriesPage.id: (_) => CategoriesPage(),
  CategorySelectedPage.id: (_) => CategorySelectedPage(""),
  CarPage.id: (_) => CarPage(),
  PaymentMethodPage.id: (_) => PaymentMethodPage(),
  HistoryPage.id: (_) => HistoryPage(),
  CouponsPage.id: (_) => CouponsPage(),
  AllProductsPage.id: (_) => AllProductsPage(),
  SearchPage.id: (_) => SearchPage(),
  MenuBottomNavigation.id: (_) => MenuBottomNavigation(),
  LocationPage.id: (_) => LocationPage(),
  OrderPage.id: (_) => OrderPage(),
  DiscountPage.id: (_) => DiscountPage(),
};
