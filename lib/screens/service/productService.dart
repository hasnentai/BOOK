import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
class ProductService {
  int id;
  String name;
  String stockStatus;
  String price;
  String priceHtml;
  List<Images> images;

  ProductService(
      {this.id, this.name, this.stockStatus, this.price,this.images,this.priceHtml});
  
  factory ProductService.fromJson(Map<String, dynamic> json) {
  var list = json['images'] as List;
  List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();
  print(parse(json['price_html']).getElementsByClassName("woocommerce-Price-currencySymbol"));
    return ProductService(
        id: json['id'],
        name: json['name'],
        stockStatus: json['stock_status'],
        price: json['price'],
        images: imagesList,
        priceHtml: parse(json['price_html']).outerHtml
       );
  }
}

class Images {
  String src;
  Images({this.src});

  factory Images.fromJson(Map<String, dynamic> json) {
  
    return Images(src: json['src']);
  }
}
