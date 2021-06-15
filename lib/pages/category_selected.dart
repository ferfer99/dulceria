import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiero_dulces/objects/cart_model.dart';
import 'package:quiero_dulces/objects/product.dart';
import 'package:quiero_dulces/objects/product_card.dart';
import 'package:quiero_dulces/widgets/constants.dart';
import 'package:quiero_dulces/widgets/lateral_menu.dart';

import 'cart_page.dart';

class CategorySelectedPage extends StatefulWidget {
  static String id = 'category_selected';
  final String category;
  CategorySelectedPage(this.category);
  @override
  _CategorySelectedPageState createState() => _CategorySelectedPageState();
}

final productReference = FirebaseDatabase.instance.reference().child('dulces');

class _CategorySelectedPageState extends State<CategorySelectedPage> {
  TextEditingController _categoryController;
  List<Product> items;
  List<ProductCard> itemsCardProduct;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangeSubscription;

  @override
  void initState() {
    items = [];
    itemsCardProduct = [];
    _categoryController =
        TextEditingController(text: widget.category.toString());
    _onProductAddedSubscription =
        productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangeSubscription =
        productReference.onChildAdded.listen(_onProductUpdate);
    super.initState();
  }

  @override
  void dispose() {
    _onProductAddedSubscription.cancel();
    _onProductChangeSubscription.cancel();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carItems = Provider.of<CartModel>(context);
    return SafeArea(
      child: Scaffold(
        drawer: LateralMenu(),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colorRojo,
              title: Text(
                '${_categoryController.text}'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.cartPlus),
                        onPressed: () {
                          setState(
                            () {
                              Navigator.pushNamed(context, CarPage.id);
                            },
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                Navigator.pushNamed(context, CarPage.id);
                              },
                            );
                          },
                          child: Container(
                            child: Text(
                              '${carItems.products.length}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontFamily: 'Impact',
                              ),
                            ),
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int position) {
                  //addProductsToList();
                  if (items[position].category == _categoryController.text) {
                    return _cardProduct(position);
                  }
                  return SizedBox.shrink();
                },
                childCount: items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onProductAdded(Event event) {
    setState(() {
      items.add(new Product.fromSnapShot(event.snapshot));
    });
  }

  void _onProductUpdate(Event event) {
    var oldProductValue =
        items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldProductValue)] =
          new Product.fromSnapShot(event.snapshot);
    });
  }

  Widget _cardProduct(int position) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ListTile(
                    title: Text(
                      '${items[position].name}',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    subtitle: Text(
                      '${items[position].description}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                containerImgItem(),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            elevatedButtonAddCarItem(position),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget containerImgItem() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, right: 5.0),
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        color: colorRojo,
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage("assets/img/logodulces.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget elevatedButtonAddCarItem(int position) {
    final carItems = Provider.of<CartModel>(context);
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 10),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => Colors.redAccent),
      ),
      onPressed: () {
        print("agregado");
        setState(() {
          carItems.add(items[position]);
        });
      },
      child: Text(
        'Agregar'.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Impact',
          fontSize: 20.0,
        ),
      ),
    );
  }
}
