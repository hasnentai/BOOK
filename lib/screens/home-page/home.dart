import 'dart:async';
import 'dart:convert';

import 'package:bookabook/models/product.dart';
import 'package:bookabook/screens/home-page/categories-controller.dart';
import 'package:bookabook/screens/service/productService.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:bookabook/screens/service/category_service.dart';
import 'package:http/http.dart' as http;

CatController catController = CatController();

class Home extends StatefulWidget {
  final String email;
  final String displayName;
  Home(this.email, this.displayName);
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  String email;
  String displayName;

  List<ProductService> productList;
  List<ProductService> filteredProducts;
  List<ProductService> auditingProducts;
  List<ProductService> bankProduct;
  List<ProductService> bookRental;
  List<ProductService> businessManagement;
  List<CatService> category;
  List<CatService> categoryList;

  bool isError = false;

  void initState() {
    email = widget.email;
    displayName = widget.displayName;

    setState(() {
      this.getCategoryData();
      this.getAccountingData();
      this.getAuditingData();
      this.getBankingData();
      this.getBookRentalData();
      this.getBusinessManagementData();
    });

    // this.getAuditingData();
    // this.getBankingData();
    // this.getBookRentalData();
    // this.getBusinessManagementData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCategoryData() async {
    var res = await http.get(
        "https://bookabook.co.za/wp-json/wc/v3/products/categories?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1");

    setState(() {
      var data = json.decode(res.body);
      var list = data as List;
      print("List of cat $list");
      categoryList =
          list.map<CatService>((json) => CatService.fromJson(json)).toList();

      category = categoryList
          .where((data) => data.count > 0 && data.catName != 'Uncategorized')
          .toList();
    });
  }
  Future<void> getBusinessManagementData() async {
    var res =await http.get(
        "https://bookabook.co.za/wp-json/wc/v3/products?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&category=905");

    var data = json.decode(res.body);
    var list = data as List;

    setState(() {
      productList = list
          .map<ProductService>((json) => ProductService.fromJson(json))
          .toList();

      businessManagement =
          productList.where((data) => data.stockStatus == "instock").toList();
    });
  }

 Future<void> getBookRentalData() async {
    var res =await http.get(
        "https://bookabook.co.za/wp-json/wc/v3/products?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&category=4047");

    var data = json.decode(res.body);
    var list = data as List;

    setState(() {
      productList = list
          .map<ProductService>((json) => ProductService.fromJson(json))
          .toList();

      bookRental =
          productList.where((data) => data.stockStatus == "instock").toList();
    });
  }
  Future<void> getAccountingData() async {
    var res = await http.get(
        "https://bookabook.co.za/wp-json/wc/v3/products?category=127&per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1");

    setState(() {
      var data = json.decode(res.body);
      var list = data as List;
      print(list);
      productList = list
          .map<ProductService>((json) => ProductService.fromJson(json))
          .toList();

      filteredProducts =
          productList.where((data) => data.stockStatus == "instock").toList();
    });
  }

  Future<void> getAuditingData() async {
    var res = await http.get(
        "https://bookabook.co.za/wp-json/wc/v3/products?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&category=139");

    var data = json.decode(res.body);
    var list = data as List;

    setState(() {
      productList = list
          .map<ProductService>((json) => ProductService.fromJson(json))
          .toList();

      auditingProducts =
          productList.where((data) => data.stockStatus == "instock").toList();
    });
  }

  Future<void> getBankingData() async {
    var res = await http.get(
        "https://bookabook.co.za/wp-json/wc/v3/products?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&category=930");

    var data = json.decode(res.body);
    var list = data as List;

    setState(() {
      productList = list
          .map<ProductService>((json) => ProductService.fromJson(json))
          .toList();

      bankProduct =
          productList.where((data) => data.stockStatus == "instock").toList();
    });
  }

  Widget navBarBuilder(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: displayName != null ? Text(displayName) : Text(""),
            accountEmail: email != null ? Text(email) : Text(""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.orange
                  : Colors.white,
              child: Text(
                displayName.split('')[0].toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            )),
        ListTile(
          title: Text('Logout'),
          onTap: () async {
            prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushReplacementNamed(context, "/myhome");
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFF900F),
          statusBarIconBrightness: Brightness.light),
    );
    return new Scaffold(
      key: _scaffoldKey,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color(0xFFFF900F),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xFFFF900F),
        child: new Container(
          height: MediaQuery.of(context).size.height / 17,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Icon(
                Icons.home,
                color: Colors.white,
              ),
              new Icon(Icons.notifications, color: Colors.white),
              new Icon(Icons.search, color: Colors.white),
              new Icon(Icons.person, color: Colors.white),
            ],
          ),
        ),
      ),
      appBar: new AppBar(
        title: new Text(
          'Home',
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF900F),
        leading: GestureDetector(
          child: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: false,
      ),
      drawer: Drawer(child: navBarBuilder(context)),
      body: !(filteredProducts == null)
          ? productListBuilder(context)
          : new Center(child: new CircularProgressIndicator()),
    );
  }

  Widget productListBuilder(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            right: 0.0, left: 14.0, top: 14.0, bottom: 14.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: category.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Color(0xFFFF900F),
                        borderRadius: new BorderRadius.circular(15.0),
                        border: new Border.all(
                          color: Colors.white,
                        ),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black45,
                            offset: new Offset(1.0, 1.0),
                            blurRadius: 4.0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text(
                          category[i].catName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      'Business Mangement',
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600,color: Color(0xFFFF900F),),
                    ),
                  ),
                  Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black45,
                              offset: new Offset(1.0, 1.0),
                              blurRadius: 6.0,
                            )
                          ],
                          borderRadius: new BorderRadius.circular(50.0),
                          border: new Border.all(color: Color(0xFFFF900F))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('See All'),
                      ))
                ],
            ),
             ),
            !(businessManagement == null)
                ? new Container(
                    height: 250.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: businessManagement.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 130.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.black26,
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black45,
                                          offset: new Offset(1.0, 1.0),
                                          blurRadius: 4.0,
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              businessManagement[i]
                                                  .images[0]
                                                  .src))),
                                ),
                              ),
                            ),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  businessManagement[i].name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0),
                                )),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  businessManagement[i].price,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ))
                          ],
                        );
                      },
                    ),
                  )
                : new CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      'Accounting',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF900F)),
                    ),
                  ),
                  Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black45,
                              offset: new Offset(1.0, 1.0),
                              blurRadius: 6.0,
                            )
                          ],
                          borderRadius: new BorderRadius.circular(50.0),
                          border: new Border.all(color: Color(0xFFFF900F))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('See All'),
                      ))
                ],
              ),
            ),
            !(filteredProducts == null)
                ? new Container(
                    height: 250.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 130.0,
                                  decoration: new BoxDecoration(
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black45,
                                          offset: new Offset(1.0, 1.0),
                                          blurRadius: 4.0,
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              filteredProducts[i]
                                                  .images[0]
                                                  .src))),
                                ),
                              ),
                            ),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  filteredProducts[i].name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0),
                                )),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  filteredProducts[i].price,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ))
                          ],
                        );
                      },
                    ),
                  )
                : new CircularProgressIndicator(),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new Text(
                    'Auditing',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black45,
                            offset: new Offset(1.0, 1.0),
                            blurRadius: 6.0,
                          )
                        ],
                        borderRadius: new BorderRadius.circular(50.0),
                        border: new Border.all(color: Color(0xFFFF900F))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('See All'),
                    ))
              ],
            ),
            !(auditingProducts == null)
                ? new Container(
                    height: 250.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: auditingProducts.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 130.0,
                                  decoration: new BoxDecoration(
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black45,
                                          offset: new Offset(1.0, 1.0),
                                          blurRadius: 4.0,
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              auditingProducts[i]
                                                  .images[0]
                                                  .src))),
                                ),
                              ),
                            ),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  auditingProducts[i].name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0),
                                )),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  auditingProducts[i].price,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ))
                          ],
                        );
                      },
                    ),
                  )
                : new CircularProgressIndicator(),
            new Row(children: <Widget>[
              Expanded(
                child: new Text(
                  'Banking',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black45,
                          offset: new Offset(1.0, 1.0),
                          blurRadius: 6.0,
                        )
                      ],
                      borderRadius: new BorderRadius.circular(50.0),
                      border: new Border.all(color: Color(0xFFFF900F))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('See All'),
                  ))
            ]),
            !(bankProduct == null)
                ? new Container(
                    height: 250.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bankProduct.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 130.0,
                                  decoration: new BoxDecoration(
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black45,
                                          offset: new Offset(1.0, 1.0),
                                          blurRadius: 4.0,
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              bankProduct[i].images[0].src))),
                                ),
                              ),
                            ),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  bankProduct[i].name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0),
                                )),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  bankProduct[i].price,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ))
                          ],
                        );
                      },
                    ),
                  )
                : new CircularProgressIndicator(),
                 new Row(children: <Widget>[
              Expanded(
                child: new Text(
                  'Book Rental',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black45,
                          offset: new Offset(1.0, 1.0),
                          blurRadius: 6.0,
                        )
                      ],
                      borderRadius: new BorderRadius.circular(50.0),
                      border: new Border.all(color: Color(0xFFFF900F))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('See All'),
                  ))
            ]),
            !(bookRental == null)
                ? new Container(
                    height: 250.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookRental.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 130.0,
                                  decoration: new BoxDecoration(
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black45,
                                          offset: new Offset(1.0, 1.0),
                                          blurRadius: 4.0,
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              bookRental[i].images[0].src))),
                                ),
                              ),
                            ),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  bookRental[i].name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0),
                                )),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  bookRental[i].price,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ))
                          ],
                        );
                      },
                    ),
                  )
                : new CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
